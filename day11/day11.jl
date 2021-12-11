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

const FlashEnergy = 10
const MapSize = Ref{Int}()

function AOC.processinput(data)
    data = split(data, '\n')
    MapSize[] = length(data)
    [parse(Int, data[i][j]) for i in 1:MapSize[], j in 1:MapSize[]]
end

function getneighbours(index::CartesianIndex)
    indices = map(i -> index + i, Directions)
    filter(i -> i[1]>0 && i[1]<=MapSize[] && i[2]>0 && i[2]<=MapSize[], indices)
end

function getneighbours(indices::Vector{CartesianIndex{2}})
    collect(Iterators.flatten(map(i -> getneighbours(i), indices)))
end

function flash!(energymap, flashed = CartesianIndex{2}[])
    indices = CartesianIndices(energymap)
    flashers = filter(i -> energymap[i] >= FlashEnergy::Int, setdiff(indices, flashed))
    if isempty(flashers)
        energymap[flashed] .= 0
        return flashed
    else
        neighbours = filter(i -> energymap[i] < FlashEnergy::Int, getneighbours(flashers))
        map(i -> energymap[i] += 1, flashers)
        map(i -> energymap[i] += 1, neighbours)
        flashed = unique(push!(flashed, flashers...))
        flash!(energymap, flashed)
    end
end

function timestep!(energymap)    
    energymap .+= 1
    flash!(energymap)
end

function solve1!(timesteps, energymap)
    reduce((flashes, _) -> flashes + length(timestep!(energymap)) , 1:timesteps, init=0)
end

function solve2!(energymap)
    for i in 1:typemax(Int)
        timestep!(energymap)
        sum(energymap .!= 0) == 0 && return i
    end    
end

puzzles = [    
    Puzzle(11, "test 1", "input-test1.txt", input -> solve1!(10, input), 204),
    Puzzle(11, "test 1", "input-test1.txt", input -> solve1!(100, input), 1656),
    Puzzle(11, "deel 1", input -> solve1!(100, input), 1675),
    Puzzle(11, "test 2", "input-test1.txt", solve2!, 195),
    Puzzle(11, "deel 2", solve2!, 515)
]

printresults(puzzles)

end