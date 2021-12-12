module Day12

include("./../aoc.jl")

using .AOC


function AOC.processinput(data)
    data = split(data, '\n')
    m1 = map(x -> (s = split(x, '-'); s[1] => s[2]), data)
    m2 = map(x -> (s = split(x, '-'); s[2] => s[1]), data)
    push!(m1, m2...)
end

function getcavemap(connectionslist)
    cavemap = Dict(c => [] for c in map(c -> c[1], connectionslist))
    foreach(c -> push!(cavemap[c[1]], c[2]), connectionslist)
    return cavemap
end

function issmallcave(cave)
    sum(map(isuppercase, collect(cave))) == 0
end

function isendcave(cave)
    cave === "end"
end

function doublevisitdone(path)    
    smallcaves = filter(c -> issmallcave(c), path)
    length(unique(smallcaves)) != length(smallcaves)
end

function strategy1(cavemap, path)
    setdiff(cavemap[path[end]], filter(c -> issmallcave(c), path))
end

function strategy2(cavemap, path)
    ("end" in path) && return []
    possiblecaves = setdiff(cavemap[path[end]], ["start"])
    doublevisitdone(path) ? setdiff(possiblecaves, filter(c -> issmallcave(c), path)) : possiblecaves    
end

function getpathsfrompath(cavemap, path, strategy)
    haskey(cavemap, path[end]) || return path
    possiblecaves = strategy(cavemap, path)
    map(c -> [path..., c], possiblecaves)
end

function getpaths(cavemap, paths, strategy)
    collect(Iterators.flatten(map(path -> getpathsfrompath(cavemap, path, strategy), paths)))
end

function recurse(cavemap, paths, strategy)
    pathstoextend = filter(p -> !isendcave(p[end]), paths)
    if isempty(pathstoextend)
        paths
    else
        push!(paths, recurse(cavemap, getpaths(cavemap, pathstoextend, strategy), strategy)...)
    end
end

function solve(input, strategy)
    cavemap = getcavemap(input)
    paths = [["start"]]
    paths = recurse(cavemap, paths, strategy)
    pathsmask = map(p -> p[end] == "end" in p, paths)
    length(paths[pathsmask])
end

function solve1(input)
    solve(input, strategy1)
end

function solve2(input)
    solve(input, strategy2)
end

puzzles = [
    Puzzle(12, "test 1a", "input-test1.txt", solve1, 10),
    Puzzle(12, "test 1b", "input-test2.txt", solve1, 19),
    Puzzle(12, "test 1c", "input-test3.txt", solve1, 226),
    Puzzle(12, "deel 1", solve1, 5252),
    Puzzle(12, "test 2a", "input-test1.txt", solve2, 36),
    Puzzle(12, "test 2b", "input-test2.txt", solve2, 103),
    Puzzle(12, "test 2c", "input-test3.txt", solve2, 3509),
    Puzzle(12, "deel 2", solve2, 147784)
]

printresults(puzzles)

end