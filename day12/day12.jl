module Day12

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    # data = split(data, '\n')
end

function solve1(input)
    "nog te bepalen"
end

function solve2(input)
    "nog te bepalen"
end

puzzles = [
    Puzzle(12, "test 1", "input-test1.txt", solve1, nothing),
    Puzzle(12, "deel 1", solve1, nothing),
    Puzzle(12, "test 2", "input-test1.txt", solve2, nothing),
    Puzzle(12, "deel 2", solve2, nothing)
]

printresults(puzzles)

end