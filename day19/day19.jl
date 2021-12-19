module Day19

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    data = split.(split(data, "\n\n"), '\n')
    data = map(r -> map(x -> parse.(Int, x), split.(r[2:end], ',')), data)
end

function norm(v)
    sum(map(x -> x^2, v))
end

function solve1(scanners)
    norms0 = norm.(scanners[1])
    norms1 = norm.(scanners[2])
    intersect(norms0, norms1)
end

function solve2(input)
    "nog te bepalen"
end

puzzles = [
    Puzzle(19, "test 1", "input-test1.txt", solve1, 79),
    # Puzzle(19, "deel 1", solve1, nothing),
    # Puzzle(19, "test 2", "input-test1.txt", solve2, nothing),
    # Puzzle(19, "deel 2", solve2, nothing)
]

printresults(puzzles)

end