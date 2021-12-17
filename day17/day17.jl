module Day17

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    data = split(data[14:end], ", ")
    data = split.(map(d -> d[3:end], data), "..")
    (x1, x2), (y1, y2) = map(d -> parse.(Int, d), data)
    (x1=x1, x2=x2, y1=y2, y2=y1)
end

function targetunreachable(target, p)
    p[1] > target.x2 || p[2] < target.y2
end

function ontarget(target, p)
    p[1] >= target.x1 && p[1] <= target.x2 && p[2] <= target.y1 && p[2] >= target.y2
end

function step!(p, v)
    p += v
    v += [-sign(v[1]), -1]
    p, v
end

function trajectory(target, v)
    v₀ = v
    trajectory = []
    p = [0, 0]
    while !ontarget(target, p) && !targetunreachable(target, p)
        p, v = step!(p, v)
        push!(trajectory, p)
    end
    (v = v₀, targetreached = ontarget(target, trajectory[end]), maxheight = maximum(map(p -> p[2], trajectory)))
end

# Derivation for the formula below used to get vxmin
# x + (x-1) + ... + (x-(n-1)) >= target.x1, for all n
# nx + (n-1)n/2 >= target.x1
# x >= target.x1/n - n/2 -1/2
# max(target.x1/n - n/2 -1/2) => -target.x1/(n*n) - 1/2 = 0 => n = sqrt(2 * target.x1)

function velocityranges(target)
    n = sqrt(2 * target.x1)
    vxmin::Int = floor(target.x1/n + n/2)
    (xrange = vxmin:target.x2, yrange = target.y2:-target.y2-1)
end

function succesfultrajectories(target)
    r = velocityranges(target)
    velocities = [[x, y] for x in r.xrange, y in r.yrange]
    trajectories = map(v -> trajectory(target, v), velocities)
    succesfultrajectories = filter(t -> t.targetreached, trajectories)    
end

function solve1(target)    
    maximum(map(t -> t.maxheight, succesfultrajectories(target)))
end

function solve2(target)
    length(succesfultrajectories(target))
end

puzzles = [
    Puzzle(17, "test 1", "input-test1.txt", solve1, 45),
    Puzzle(17, "deel 1", solve1, 4560),
    Puzzle(17, "test 2", "input-test1.txt", solve2, 112),
    Puzzle(17, "deel 2", solve2, 3344),
]

printresults(puzzles)

end