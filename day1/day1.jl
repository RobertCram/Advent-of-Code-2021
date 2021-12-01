include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    data = split(data, '\n')
    map(x -> parse(Int, x), collect(data))    
end

function solve1(input)
    data = [Inf, input...]
    sum([data[i] < data[i+1] for i in 1:length(input)])
end

function solve2(input)
    data = [Inf, Inf, Inf, input...]
    sum([sum(data[i:i+2]) < sum(data[i+1:i+3]) for i in 1:length(input)])
end

puzzles = [
    Puzzle(1, "test 1", "input-test1.txt", solve1, 7), 
    Puzzle(1, "deel 1", solve1, 1655), 
    Puzzle(1, "test 2", "input-test1.txt", solve2, 5), 
    Puzzle(1, "deel 2", solve2, 1683)
]

solve(puzzles)
