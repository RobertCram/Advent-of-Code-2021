module Day15

include("./../aoc.jl")

using .AOC

NESW = [
    CartesianIndex(0,1),
    CartesianIndex(1,0),
    CartesianIndex(0,-1),
    CartesianIndex(-1, 0)
]

struct Path
    index::CartesianIndex{2}
    value::Int
end

struct BigMap
    smallmap::Array{Int}
end

function Base.getindex(bm::BigMap, index::CartesianIndex)    
    rb, cb = index[1], index[2]
    r = mod(rb - 1, size(bm.smallmap)[1]) + 1
    c = mod(cb - 1, size(bm.smallmap)[2]) + 1
    addition = (rb - 1) ÷ size(bm.smallmap)[1] + (cb - 1) ÷ size(bm.smallmap)[2] 
    mod(bm.smallmap[r, c] + addition - 1, 9) + 1
end

function Base.size(r::BigMap)    
    (size(r.smallmap)[1]*5, size(r.smallmap)[2]*5)
end

function Base.CartesianIndices(r::BigMap)    
    CartesianIndices(size(r))
end

function AOC.processinput(data)
    data = map(a -> parse.(Int, a), collect.(split(data, '\n')))
    [data[i][j] for i in 1:length(data), j in 1:length(data[1])]
end

function getneighbours(riskmap, index::CartesianIndex{2})
    filter(v -> v[1]>0 && v[1]<=size(riskmap)[1] && v[2]>0 && v[2]<=size(riskmap)[1], map(v -> v + index, NESW))
end

function getpaths(riskmap, path::Path)
    map(n -> Path(n, path.value + riskmap[n]) , getneighbours(riskmap, path.index))
end

function updateminimumvalues!(riskmap, minimumvalues, paths)
    foreach(p -> minimumvalues[p.index] = min(p.value, minimumvalues[p.index]), paths)
end

function getunfinishedpaths(riskmap, minimumvalues, paths)
    rows, cols = size(riskmap)        
    filter(p -> p.value < minimumvalues[p.index] && p != CartesianIndex(rows, cols), paths)
end

function getminimumpaths(paths)
    paths = reduce((d, p) -> (d[p.index] = min(get(d, p.index, typemax(Int)), p.value); d), paths, init = Dict())
    map(i -> Path(i, paths[i]), collect(keys(paths)))    
end

function getpathstoextend(riskmap, minimumvalues, paths)
    paths = getunfinishedpaths(riskmap, minimumvalues, paths)
    paths = getminimumpaths(paths)
end

function getpaths(riskmap, paths::Vector{Path}, minimumvalues)
    pathstoextend = getpathstoextend(riskmap, minimumvalues, paths)
    updateminimumvalues!(riskmap, minimumvalues, paths)
    if isempty(pathstoextend)        
        return paths
    else
        newpaths = collect(Path, Iterators.flatten(map(p -> getpaths(riskmap, p), pathstoextend)))
        paths = getpaths(riskmap, newpaths, minimumvalues)
    end
end

function solve(riskmap)
    minimumvalues = [typemax(Int) for i in CartesianIndices(riskmap)]
    getpaths(riskmap, [Path(CartesianIndex(1,1), riskmap[CartesianIndex(1,1)])], minimumvalues)
    minimumvalues[end, end] - riskmap[CartesianIndex(1,1)]
end

function solve1(riskmap)
    solve(riskmap)
end

function solve2(riskmap)
    solve1(BigMap(riskmap))
end

puzzles = [
    Puzzle(15, "test 1", "input-test1.txt", solve1, 40),
    Puzzle(15, "deel 1", solve1, 498),
    Puzzle(15, "test 2", "input-test1.txt", solve2, 315),
    Puzzle(15, "deel 2", solve2, 2901)
]

printresults(puzzles)

end