include("./../aoc.jl")

using .AOC

function processinput(input)
    # typeof(input) == String
    input = split(input, '\n')
end

function solve1(input)
    input = processinput(input)
    "nog te bepalen"
end

function solve2(input)
    input = processinput(input)
    "nog te bepalen"
end

puzzles = [
    Puzzle(2, "test 1", "input-test1.txt", solve1, nothing),
    Puzzle(2, "deel 1", solve1, nothing),
    Puzzle(2, "test 2", "input-test1.txt", solve2, nothing),
    Puzzle(2, "deel 2", solve2, nothing)
]

solve(puzzles)