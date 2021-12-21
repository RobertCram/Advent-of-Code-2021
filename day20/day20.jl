module Day20

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    data = split(data, "\n\n")
    algorithm = map(c -> c == '#' ? 1 : 0, collect(data[1]))
    image = split(data[2], '\n')
    image = [image[i][j] == '#' ? 1 : 0 for i in 1:length(image), j in 1:length(image[1])]
    (algorithm = algorithm, image = image)
end

function enlarge(image, s)
    rows, cols = size(image)
    [i <= s || j <= s || i > rows+s || j > cols+s ? 0 : image[i-s, j-s]  for i in 1:rows+2*s, j in 1:cols+2*s]
end

function getindex(imagewindow)
    parse(Int, join(imagewindow'), base=2)
end

function enhance(algorithm, image)
    rows, cols = size(image)
    indices = Int.(zeros(rows-2, cols-2))
    for row in 2:rows-1
        for col in 2:cols-1
            indices[row-1, col-1] = getindex(image[row-1:row+1, col-1:col+1])
        end
    end
    map(i -> algorithm[i+1], indices)
end

function solve(input, n)
    algorithm, image = input
    image = enlarge(image,  3*n)
    for i in 1:n
        image = enhance(algorithm, image)
    end
    image = image[begin+n:end-n, begin+n:end-n]
    sum(image)
end


function solve1(input)
    solve(input, 2)
end

function solve2(input)
    solve(input, 50)
end

puzzles = [
    Puzzle(20, "test 1", "input-test1.txt", solve1, 35),
    Puzzle(20, "deel 1", solve1, 4917),
    Puzzle(20, "test 2", "input-test1.txt", solve2, 3351),
    Puzzle(20, "deel 2", solve2, 16389)
]

printresults(puzzles)

end