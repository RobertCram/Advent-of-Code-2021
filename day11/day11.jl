module Day11

include("./../aoc.jl")

using .AOC

const Directions = [
    CartesianIndex(0, 1), 
    CartesianIndex(1, 1), 
    CartesianIndex(1, 0), 
    CartesianIndex(1, -1), 
    CartesianIndex(0, -1),
    CartesianIndex(-1, -1), 
    CartesianIndex(-1, 0), 
    CartesianIndex(-1, 1)
]

function AOC.processinput(data)
    data = split(data, '\n')
    [parse(Int, data[i][j]) for i in 1:length(data), j in 1:length(data[1])]
end

function getneighbours(index::CartesianIndex)
    indices = map(i -> index + i, Directions)
    filter(i -> i[1]>0 && i[1]<=10 && i[2]>0 && i[2]<=10, indices)
end

function getneighbours(indices::Vector{CartesianIndex{2}})
    collect(Iterators.flatten(map(i -> getneighbours(i), indices)))
end

function flash!(energymap, flashed = CartesianIndex{2}[])
    indices = CartesianIndices(energymap)
    flashers = filter(i -> energymap[i] >= 10, setdiff(indices, flashed))
    if isempty(flashers)
        energymap[flashed] .= 0
        return energymap, flashed
    else
        neighbours = filter(i -> energymap[i] < 10, getneighbours(flashers))
        map(i -> energymap[i] += 1, flashers)
        map(i -> energymap[i] += 1, neighbours)
        flashed = unique(push!(flashed, flashers...))
        flash!(energymap, flashed)
    end
end

function timestep(energymap)    
    energymap .+= 1
    flash!(energymap)
end

function solve1(timesteps, energymap)
    flashes = 0
    for i in 1:timesteps
        energymap, flashed = timestep(energymap)
        flashes += length(flashed)
    end    
    flashes
end

function solve2(energymap)
    i = 0
    while true
        i += 1
        energymap, _ = timestep(energymap)
        sum(energymap .!= 0) == 0 && return i
    end    
end

puzzles = [    
    Puzzle(11, "test 1", "input-test1.txt", input -> solve1(10, input), 204),
    Puzzle(11, "test 1", "input-test1.txt", input -> solve1(100, input), 1656),
    Puzzle(11, "deel 1", input -> solve1(100, input), 1675),
    Puzzle(11, "test 2", "input-test1.txt", solve2, 195),
    Puzzle(11, "deel 2", solve2, 515)
]

printresults(puzzles)

end