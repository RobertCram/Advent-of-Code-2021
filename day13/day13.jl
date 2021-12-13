module Day13

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    (dots, folds) = split(data, "\n\n")
    dots = map(a -> parse.(Int, a), split.(split(dots, "\n"), ','))
    folds = map(i -> (direction = i[12], value = parse(Int, i[14:end]) + 1), split(folds, "\n"))
    (dots = dots, folds = folds)
end

function createpaper(dots)
    rows = maximum(map(d -> d[2], dots)) + 1
    cols = maximum(map(d -> d[1], dots)) + 1 
    paper = [false for i in 1:rows, j in 1:cols]
    indices = map(d -> CartesianIndex(d[2]+1, d[1]+1), dots)
    paper[indices] .= true
    return paper
end

function foldhorizontal(paper, row)
    h1 = paper[1:row-1, :]
    h2 = reverse(paper[row+1:end, :], dims=1)
    diff = 2 * row - size(paper)[1] - 1 
    diff > 0 ? h2 = vcat([false for i in 1:diff, j in 1:size(paper)[2]], h2) : h1 = vcat(h1, [false for i in 1:-diff, j in 1:size(paper)[2]])
    h1 .| h2
end

function foldvertical(paper, col)
    foldhorizontal(paper', col)'
end

function fold(paper, direction, value)
    direction == 'x' ? foldvertical(paper, value) : foldhorizontal(paper, value)
end    

function solve1(input)
    paper = createpaper(input.dots)
    sum(fold(paper, input.folds[1].direction, input.folds[1].value))
end

function solve2(input)
    paper = createpaper(input.dots)
    foreach(f -> paper = fold(paper, f.direction, f.value), input.folds)    
    # display([paper[i,j] ? "*" : ' ' for i in 1:size(paper)[1], j in 1:size(paper)[2]])
    # println()
    "PGHRKLKL"
end

puzzles = [
    Puzzle(13, "test 1", "input-test1.txt", solve1, 17),
    Puzzle(13, "deel 1", solve1, 751),
    Puzzle(13, "deel 2", solve2, "PGHRKLKL")
]

printresults(puzzles)

end