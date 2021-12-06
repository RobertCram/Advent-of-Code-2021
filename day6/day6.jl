module Day6

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    data = parse.(Int, split(data, ','))
end

function countmap(individuals::Array{Int})
    reduce((result, individual) -> (haskey(result, individual) ? result[individual] += 1 : result[individual] = 1; result), individuals, init=Dict([]))
end

function timestep(population)
    newpopulation = Dict([k => 0 for k in 0:8])
    for (k, v) in population
        k == 0 ? (newpopulation[8] += v; newpopulation[6] += v) : newpopulation[k-1] += v
    end
    newpopulation 
end

function solve(input, timesteps)
    population = countmap(input)
    sum(values(reduce((p, _) -> timestep(p), 1:timesteps, init = population)))
end

function solve1(input)
    solve(input, 80)
end

function solve2(input)
    solve(input, 256)    
end

puzzles = [
    Puzzle(6, "test 1", "input-test1.txt", solve1, 5934),
    Puzzle(6, "deel 1", solve1, 395627),
    Puzzle(6, "test 2", "input-test1.txt", solve2, 26984457539),
    Puzzle(6, "deel 2", solve2, 1767323539209)
]

printresults(puzzles)

end