module Day18

include("./../aoc.jl")

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
    SN(s1, s2)
end

function breakapart(s::String)
    level = -1
    levels = []
    for c in s
        c == '[' && (level +=1; push!(levels, level); continue)
        c == ']' && (level -=1; push!(levels, level); continue)
        push!(levels, level)
    end
    pos = findfirst(l -> l == 0, levels[2:end]) + 2
    (left = s[2:pos-1], right = s[pos+1:end-1])    
end

function sn2str(s::SN)    
    typeof(s.left) <: Int && typeof(s.right) <: Int && return "[$(s.left),$(s.right)]"
    typeof(s.left) <: Int && return "[$(s.left),$(sn2str(s.right))]"
    typeof(s.right) <: Int && return "[$(sn2str(s.left)),$(s.right)]"

    return "[$(sn2str(s.left)),$(sn2str(s.right))]"
end

function str2sn(s::String)
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

function getleftnumber(s)
    @show "left", s
    s === nothing && return nothing
    s.parent === nothing && typeof(s.left) <: SN && return getrightnumber(s.left)
    s.parent === nothing && return s.left
    typeof(s.parent.left) <: Int && return s.parent.left
    return getleftnumber(s.parent)
end

function getrightnumber(s)
    @show "right", s
    s === nothing && return nothing
    s.parent === nothing && typeof(s.right) <: SN && return getleftnumber(s.right)
    s.parent === nothing && return s.right
    typeof(s.parent.right) <: Int && return s.parent.right
    return getrightnumber(s.parent)
end


function simplereduce(s::String)
    i = 1
    count = -1
    for c in s
        c == '[' && (count += 1)
        count == 4 && break
        i += 1
    end 
    start = i
    stop = i + findfirst(c -> c == ']', s[i:end]) - 1
    s[start:stop]
    left = split(join(replace(c -> c in ['[', ']', ','] ? ' ' : c, collect(s[1:start-1]))))
    leftint = isempty(left) ? nothing : left[end]

    right = split(join(replace(c -> c in ['[', ']', ','] ? ' ' : c, collect(s[stop+1:end]))))
    rightint = isempty(right) ? nothing : right[begin]

    leftint, rightint
end

function solve1(input)
    # sn2str(SN(SN(1,2), SN(SN(3,4), 5)))
    #str2sn("[[1,2],[[3,4],5]]")
    #str2sn("[[[[[9,8],1],2],3],4]")
    # str2sn("[1,2]")
    #@show str2sn("[[3,[2,[1,[7,8]]]],[6,[5,[4,[3,2]]]]]")
    # simplereduce("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
    # simplereduce("[[[[[9,8],1],2],3],4]")
    # str2sn("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
    # s = getlevel4number(str2sn("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]"))
    #getleftnumber(s)
    #getrightnumber(s)    
    getleftnumber(str2sn("[1,2]"))
end

function solve2(input)
    "nog te bepalen"
end


puzzles = [
    Puzzle(18, "test 1a", "input-test1.txt", solve1, "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]"),
    # Puzzle(18, "test 1b", "input-test1.txt", solve1, 4140),
    # Puzzle(18, "deel 1", solve1, nothing),
    # Puzzle(18, "test 2", "input-test1.txt", solve2, nothing),
    # Puzzle(18, "deel 2", solve2, nothing)
]

printresults(puzzles)

end