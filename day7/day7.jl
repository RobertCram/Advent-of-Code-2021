module Day7

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    parse.(Int, split(data, ','))
end

function fuelcosts1(distance)
    distance
end

function fuelcosts2(distance)
    distance * (distance + 1) ÷ 2
end

function solve(input, fuelcosts)
    minimum([sum(fuelcosts.(abs.(i .- input))) for i in minimum(input):maximum(input)])
end

function solve1(input)
    solve(input, fuelcosts1)    
end

function solve2(input)
    solve(input, fuelcosts2)    
end


puzzles = [
    Puzzle(7, "test 1", "input-test1.txt", solve1, 37),
    Puzzle(7, "deel 1", solve1, 341534),
    Puzzle(7, "test 2", "input-test1.txt", solve2, 168),
    Puzzle(7, "deel 2", solve2, 93397632)
]

printresults(puzzles)

end