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

function solve1(target)
    vs = [[x, y] for x in 0:100, y in 0:100] # but how do you reliably get the x and y ranges given the target? to be continued...
    trajectories = map(v -> trajectory(target, v), vs)
    succesfultrajectories = filter(t -> t.targetreached, trajectories)
    maximum(map(t -> t.maxheight, succesfultrajectories))
end

function solve2(target)
    vs = [[x, y] for x in 0:500, y in -100:500] # but how do you reliably get the x and y ranges given the target? to be continued...
    trajectories = map(v -> trajectory(target, v), vs)
    succesfultrajectories = filter(t -> t.targetreached, trajectories)
    length(succesfultrajectories)
end

puzzles = [
    Puzzle(17, "test 1", "input-test1.txt", solve1, 45),
    Puzzle(17, "deel 1", solve1, 4560),
    Puzzle(17, "test 2", "input-test1.txt", solve2, 112),
    Puzzle(17, "deel 2", solve2, 3344)
]

printresults(puzzles)

end