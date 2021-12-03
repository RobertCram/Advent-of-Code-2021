module Day3

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    data = split(data, '\n')
    data = [parse(Int, data[i][j]) for i in 1:length(data), j in 1:length(data[1])]
end

function todecimal(binaryvector)
    b = reverse([2^n for n in 0:length(binaryvector)-1])
    (binaryvector * b)[1]
end

function mostcommon(binarymatrix)
    sum(binarymatrix, dims=1) .>= size(binarymatrix, 1) / 2
end

function leastcommon(binarymatrix)
    .! mostcommon(binarymatrix)
end

function getrating(report, bitcriteria)
    currentbit = 1
    while size(report, 1) > 1
        c = bitcriteria(report)
        report = report[report[:, currentbit] .== c[currentbit], :]
        currentbit += 1        
    end
    todecimal(report)
end

function solve1(report)
    gammavector = mostcommon(report)
    epsilonvector = .! gammavector
    gamma = todecimal(gammavector)
    epsilon = todecimal(epsilonvector)
    gamma * epsilon
end

function solve2(report)
    oxygenrating = getrating(report, mostcommon)
    co2scrubberrating = getrating(report, leastcommon)
    oxygenrating * co2scrubberrating
end

puzzles = [
    Puzzle(3, "test 1", "input-test1.txt", solve1, 198),
    Puzzle(3, "deel 1", solve1, 2648450),
    Puzzle(3, "test 2", "input-test1.txt", solve2, 230),
    Puzzle(3, "deel 2", solve2, 2845944)
]

printresults(puzzles)

end