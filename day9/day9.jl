module Day9

include("./../aoc.jl")

using .AOC

struct Heightmap{T} <: AbstractMatrix{T}
    a::Array{T}
    v::T
end

Heightmap(a) = Heightmap(a, 9)

const NESW = [CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(-1, 0), CartesianIndex(0, -1)]

Base.getindex(hm::Heightmap, i, j) = i < 1 || i > size(hm.a)[1] || j < 1 || j > size(hm.a)[2] ? hm.v : getindex(hm.a, i, j)
Base.size(hm::Heightmap) = size(hm.a)

function AOC.processinput(data)
    data = split(data, '\n')    
    data = [parse.(Int, data[i][j]) for i in 1:length(data), j in 1:length(data[1])]        
end

function islowpoint(heightmap, index)
    indices = map(x -> index + x, NESW)
    heightmap[index] < minimum(map(x -> heightmap[x], indices))
end

function getlowpointsmask(heightmap)
    indices = CartesianIndices(heightmap)
    map(x -> islowpoint(heightmap, x), indices)
end

function gethigherpoints(heightmap, index::CartesianIndex{2})
    indices = map(x -> index + x, NESW)
    map(x-> x[1], filter(x -> x[2] < 9 && x[2] > heightmap[index], map(x -> (x, heightmap[x]), indices)))
end

function gethigherpoints(heightmap, indices::Vector{CartesianIndex{2}})
    unique(Iterators.flatten(map(x -> gethigherpoints(heightmap, x), indices)))
end

function getbasinsize(heightmap, index)
    p = [index]
    higherpoints = p
    while !isempty(p)
        p = gethigherpoints(heightmap, p)
        push!(higherpoints, p...)
    end
    length(unique(higherpoints))
end

function solve1(input)
    heightmap = Heightmap(input)
    lowpointsmask = getlowpointsmask(heightmap)
    sum((heightmap .+ 1)[lowpointsmask])
end

function solve2(input)
    heightmap = Heightmap(input)
    lowpoints = CartesianIndices(heightmap)[getlowpointsmask(heightmap)]
    sizes = map(x -> getbasinsize(heightmap, x), lowpoints)
    reduce(*, reverse(sort(sizes))[1:3])
end

puzzles = [
    Puzzle(9, "test 1", "input-test1.txt", solve1, 15),
    Puzzle(9, "deel 1", solve1, 514),
    Puzzle(9, "test 2", "input-test1.txt", solve2, 1134),
    Puzzle(9, "deel 2", solve2, 1103130)
]

printresults(puzzles)

end