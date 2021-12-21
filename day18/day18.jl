module Day18

include("./../aoc.jl")

using Test

using .AOC

function AOC.processinput(data)
    data = split(data, '\n')
end

mutable struct SN
    left::Union{Int, SN}
    right::Union{Int, SN}
    parent::Union{Nothing, SN}
    function SN(left, right)
        result = new(left, right, nothing)
        typeof(left) <: SN && (left.parent = result)
        typeof(right) <: SN && (right.parent = result)
        result
    end
end

Base.show(io::IO, s::SN) = show(io, sn2str(s))

function add(s1::SN, s2::SN)    
    reducesn(SN(str2sn(sn2str(s1)), str2sn(sn2str(s2))))
end

function breakapart(s::AbstractString)
    level = -1
    levels = []
    for c in s
        c == '[' && (level +=1; push!(levels, level); continue)
        c == ']' && (level -=1; push!(levels, level); continue)
        push!(levels, level)
    end
    rightbracket = findfirst(l -> l == 0, levels[2:end]) + 1
    comma  = findfirst(s -> s == ',', s[rightbracket:end]) + rightbracket - 1 
    (left = s[2:comma-1], right = s[comma+1:end-1])    
end

function sn2str(s::SN)    
    typeof(s.left) <: Int && typeof(s.right) <: Int && return s == mark ? "{$(s.left),$(s.right)}" : "[$(s.left),$(s.right)]"
    typeof(s.left) <: Int && return "[$(s.left),$(sn2str(s.right))]"
    typeof(s.right) <: Int && return "[$(sn2str(s.left)),$(s.right)]"

    return "[$(sn2str(s.left)),$(sn2str(s.right))]"
end

function str2sn(s::AbstractString)
    left, right = breakapart(s)
    left[1] != '[' && right[1] != '[' && return SN(parse(Int, left), parse(Int, right))

    left[1] == '[' && right[1] == '[' && return SN(str2sn(left), str2sn(right))
    left[1] == '[' && return SN(str2sn(left), parse(Int, right))
    right[1] == '[' && return SN(parse(Int, left), str2sn(right))    
end

function getlevel4number(s::SN, level = 0)
    level == 4 && return s
    typeof(s.left) <: SN && typeof(s.right) <: SN && (s1 = getlevel4number(s.left, level+1); s1 === nothing && (s2 = getlevel4number(s.right, level+1)); return s1 === nothing ? s2 : s1)
    typeof(s.left) <: SN && return getlevel4number(s.left, level+1)
    typeof(s.right) <: SN && return getlevel4number(s.right, level+1)
    return nothing
end

function getsplitnumber(s::SN)
    typeof(s.left) <: Int && s.left >= 10 && return s
    typeof(s.left) <: Int && typeof(s.right) <: Int && s.right >= 10 && return s
    typeof(s.left) <: SN && typeof(s.right) <: Int && s.right >= 10 && (s1 = getsplitnumber(s.left); s1 === nothing && return s)

    typeof(s.left) <: SN && typeof(s.right) <: SN && (s1 = getsplitnumber(s.left); s1 === nothing && (s2 = getsplitnumber(s.right); return s1 === nothing ? s2 : s1))
    typeof(s.left) <: SN && return getsplitnumber(s.left)
    typeof(s.right) <: SN && return getsplitnumber(s.right)
    return nothing
end

function getleftnumber(s::SN)
    while s.parent !== nothing && s.parent.left == s
        s = s.parent
    end
    s.parent === nothing && return nothing
    
    typeof(s.parent.left) <: Int && return s.parent

    s = s.parent.left    
    while typeof(s.right) <: SN
        s = s.right
    end
    s
end

function getrightnumber(s::SN)
    while s.parent !== nothing && s.parent.right == s
        s = s.parent
    end
    s.parent === nothing && return nothing
    
    typeof(s.parent.right) <: Int && return s.parent

    s = s.parent.right
    while typeof(s.left) <: SN
        s = s.left
    end
    s
end

function explodesn(s::SN)
    s4 = getlevel4number(s)
    s4 === nothing && return s
    s4.parent === nothing && return s
    changeleftpart = s4.parent.left == s4
    left = getleftnumber(s4)
    right = getrightnumber(s4)
    left !== nothing && (typeof(left.right) <: Int ? left.right += s4.left : left.left += s4.left)
    right !== nothing && (typeof(right.left) <: Int ? right.left += s4.right : right.right += s4.right)
    changeleftpart ? s4.parent.left = 0 : s4.parent.right = 0
    s
end

function splitsn(s::SN)
    s10 = getsplitnumber(s)
    s10 === nothing && return s
    if typeof(s10.left) <: Int &&  s10.left >= 10
        s10.left = SN(s10.left ÷ 2, Int(ceil(s10.left / 2)))
        s10.left.parent = s10
    elseif typeof(s10.right) <: Int &&  s10.right >= 10
        s10.right = SN(s10.right ÷ 2, Int(ceil(s10.right / 2)))
        s10.right.parent = s10
    end
    s
end

function reducesn(s::SN)
    while true
        s0 = sn2str(s)
        s = explodesn(s)
        exploded = sn2str(s) != s0 
        exploded && continue
        s = splitsn(s)
        splitted = sn2str(s) != s0
        !exploded && !splitted && break
    end
    s
end

function magnitude(s::SN)
    typeof(s.left) <: Int && typeof(s.right) <: Int && return 3 * s.left + 2 * s.right
    typeof(s.left) <: Int && typeof(s.right) <: SN && return 3 * s.left + 2 * magnitude(s.right)
    typeof(s.left) <: SN && typeof(s.right) <: Int && return 3 * magnitude(s.left) + 2 * s.right
    typeof(s.left) <: SN && typeof(s.right) <: SN && return 3 * magnitude(s.left) + 2 * magnitude(s.right)
end

function solve1(input)
    input = str2sn.(input)
    s = input[1]    
    for i in 2:length(input)
        s = add(s, input[i])
    end
    magnitude(s)
end

function solve2(input)
    indices = (0,0)
    mm = 0
    input = str2sn.(input)
    for i in 1:length(input)
        for j in 1:length(input)
            if i != j
                m = magnitude(add(input[i], input[j]))
                m > mm && ((mm = m ; indices=(i,j)))
                m = magnitude(add(input[j], input[i]))
                m > mm && ((mm = m ; indices=(j,i)))
            end
        end
    end 
    mm, indices   
    mm[1]
end


puzzles = [
    Puzzle(18, "test 1c", "input-test1a.txt", solve1, 4140),
    Puzzle(18, "deel 1", solve1, 3987),
    Puzzle(18, "test 2", "input-test1a.txt", solve2, 3993),
    Puzzle(18, "deel 2", solve2, 4500)
]

printresults(puzzles)

end