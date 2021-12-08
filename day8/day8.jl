module Day8

include("./../aoc.jl")

using .AOC

const digits = Dict(
    0 => "abcefg",
    1 => "cf",
    2 => "acdeg",
    3 => "acdfg",
    4 => "bcdf",
    5 => "abdfg",
    6 => "abdefg",
    7 => "acf",
    8 => "abcdefg",
    9 => "abcdfg"
)

const uniques  = Dict(
    1 => "cf",
    4 => "bcdf",
    7 => "acf",
    8 => "abcdefg",
)

function AOC.processinput(data)
    data = split(data, '\n')
    data = map(l -> s = split(l, '|'), data)
    data = map(e -> (signals = collect.(split(e[1])), output = split(e[2])), data)
end

function solve1(data)
    uniquelengths = length.(values(uniques))
    length(filter(x -> length(x) in uniquelengths, collect(Iterators.flatten(map(x -> x.output, data)))))
end

function getoutput(output, mapping)
    parse(Int, join(map(x -> mapping[x], join.(sort.(collect.(output))))))
end
 
function getmapping(signals)
    mapping = []

    # difference between 7 and 1 gives signal for segment a
    d1 = filter(s -> length(s) == 2, signals)[1]
    d7 = filter(s -> length(s) == 3, signals)[1]
    sa = setdiff(d7, d1)[1]
    push!(mapping, 'a' => sa)

    # difference between 0,6,9 and 4 (and sa) with length 1 gives signal for segment g
    d4 = filter(s -> length(s) == 4, signals)[1]
    d069 = filter(s -> length(s) == 6, signals)
    differences = map(a -> setdiff(a, d4, sa), d069)
    sg = filter(x -> length(x) == 1, differences)[1][1]
    push!(mapping, 'g' => sg)

    # difference between 0,6,9 and 4 (and sa) with length 2 (minus sg) gives signal for segment e
    se = setdiff(filter(x -> length(x) == 2, differences)[1], sg)[1]
    push!(mapping, 'e' => se)

    # difference between 2,3,5 and 1 (and sa, se, sg) with length 1 gives signal for segment d
    d235 = filter(s -> length(s) == 5, signals)
    differences = map(a -> setdiff(a, d1, sa, se, sg), d235)
    sd = filter(x -> length(x) == 1, differences)[1][1]
    push!(mapping, 'd' => sd)

    # difference between 8 and 1 (and sa, sd, se, sg) gives signal for segment b
    d8 = filter(s -> length(s) == 7, signals)[1]
    sb = setdiff(d8, d1, sa, sd, se, sg)[1]
    push!(mapping, 'b' => sb)

    # difference between 0,6,9 and 4 (and sa, sb, sd, se, sg) with length 1 gives signal for segment f
    differences = map(a -> setdiff(a, sa, sb, sd, se, sg), d069)
    sf = filter(x -> length(x) == 1, differences)[1][1]
    push!(mapping, 'f' => sf)

    # difference between all possible signals and the 6 known signals gives signal for segment c
    sc = setdiff(['a':'g'...], sa, sb, sd, se, sf, sg)[1]
    push!(mapping, 'c' => sc)

    Dict([join(sort(map(x -> Dict(mapping)[x], collect(digits[i])))) => i for i in 0:9])
end

function solve2(data)
    mappings = map(i -> getmapping(data[i].signals), 1:length(data))
    sum(map(i -> getoutput(data[i].output, mappings[i]), 1:length(data)))
end

puzzles = [
    Puzzle(8, "test 1", "input-test2.txt", solve1, 26),
    Puzzle(8, "deel 1", solve1, 409),
    Puzzle(8, "test 2a", "input-test1.txt", solve2, 5353),
    Puzzle(8, "test 2b", "input-test2.txt", solve2, 61229),
    Puzzle(8, "deel 2", solve2, 1024649)
]

printresults(puzzles)

end