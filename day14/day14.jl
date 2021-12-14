module Day14

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    template, rules = split(data, "\n\n")
    rules = split(rules, "\n")
    rules = Dict(s[1] => s[2] for s in split.(rules, " -> "))
    (template = template, rules = rules)
end

function getcount(list)
    count = Dict(string(e) => 0 for e in unique(list))
    reduce((count, e) -> (count[e] += 1; count), list, init = count)
end

function getelementcount(template)
    elements = string.(collect(template))
    getcount(elements)
end

function getpaircount(template)
    pairs = map(i -> template[i:i+1], 1:length(template)-1)
    getcount(pairs)
end

function insertionstep(rules, pairs::Dict, elementcount::Dict)
    newpairs = Dict()
    for (k, v) in pairs
        k1 = k[1] * rules[k]
        k2 = rules[k] * k[2]
        haskey(newpairs, k1) ? newpairs[k1] += v : newpairs[k1] = v
        haskey(newpairs, k2) ? newpairs[k2] += v : newpairs[k2] = v
        haskey(elementcount, rules[k]) ? elementcount[rules[k]] += v : elementcount[rules[k]] = v
    end
    (pairs = newpairs, elementcount = elementcount)
end

function solve(input, steps)
    rules = input.rules
    elementcount = getelementcount(input.template)
    pairs = getpaircount(input.template)
    for _ in 1:steps
        pairs, elementcount = insertionstep(rules, pairs, elementcount)
    end
    minkey = reduce((x, y) -> elementcount[x] ≤ elementcount[y] ? x : y, keys(elementcount))
    maxkey = reduce((x, y) -> elementcount[x] > elementcount[y] ? x : y, keys(elementcount))
    elementcount[maxkey] - elementcount[minkey]
end

function solve1(input)
    solve(input, 10)
end

function solve2(input)
    solve(input, 40)
end

puzzles = [
    Puzzle(14, "test 1", "input-test1.txt", solve1, 1588),
    Puzzle(14, "deel 1", solve1, 2967),
    Puzzle(14, "test 2", "input-test1.txt", solve2, 2188189693529),
    Puzzle(14, "deel 2", solve2, 3692219987038)
]

printresults(puzzles)

end