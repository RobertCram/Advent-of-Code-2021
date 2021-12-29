module Day19

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    data = split.(split(data, "\n\n"), '\n')
    data = map(r -> map(x -> parse.(Int, x), split.(r[2:end], ',')), data)
end

function rotx(Θ)
    Int.(round.([1 0 0; 0 cos(Θ) -sin(Θ); 0 sin(Θ) cos(Θ)]))
end

function roty(Θ)
    Int.(round.([cos(Θ) 0 sin(Θ); 0 1 0 ;-sin(Θ) 0 cos(Θ)]))
end

function rotz(Θ)
    Int.(round.([cos(Θ) -sin(Θ) 0; sin(Θ) cos(Θ) 0; 0 0 1]))
end

function allrotations()
    r = (0:3)pi/2
    unique([rotx(Θ1) * roty(Θ2) * rotz(Θ3) for Θ1 in r for Θ2 in r for Θ3 in r])
end

const AllRotations = allrotations()

function findscannerdistance(scanner1, scanner2)
    for rotation in 1:length(AllRotations)
        counts = Dict()
        distances = map(a -> map(v -> a - v, map(v -> AllRotations[rotation] * v, scanner2)), scanner1)
        foreach(v -> foreach(d -> counts[d] = get(counts, d, 0) + 1, v), distances)
        distance = filter(p -> p[2] >= 12, counts)
        !isempty(distance) &&  return collect(keys(distance))[1], rotation
        rotation += 1
    end
    nothing, nothing
end

function solve(scanners)
    distances = []
    translatedscanners = [pop!(scanners)]
    while !isempty(scanners)
        for scanner in scanners
            translated = []
            for translatedscanner in translatedscanners
                distance, rotation = findscannerdistance(translatedscanner, scanner)
                if !isnothing(distance)
                    push!(translated, map(v -> AllRotations[rotation] * v + distance, scanner))
                    scanners = filter(s -> s != scanner, scanners)
                    push!(distances, distance)
                end
            end
            push!(translatedscanners, translated...)
        end
    end
    (beacons = length(unique(Iterators.flatten(translatedscanners))), distances = distances)
end

function solve1(scanners)    
    solve(scanners).beacons
end

function solve2(scanners)
    distances = solve(scanners).distances
    maximum([sum(abs.(distances[i] - distances[j])) for i in 1:length(distances) for j in i+1:length(distances)])
end

puzzles = [
    Puzzle(19, "test 1", "input-test1.txt", solve1, 79),
    Puzzle(19, "deel 1", solve1, 381),
    Puzzle(19, "test 2", "input-test1.txt", solve2, 3621),
    Puzzle(19, "deel 2", solve2, 12201)
]

printresults(puzzles)

end