module Day4

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    data = split(data, "\n\n")
    numbers = reverse(map(n -> parse(Int, n), split(data[1], ',')))
    boards = map(b -> split(b, '\n'), data[2:end])
    boards = map.(r -> parse.(Int, split(r)), boards)
    boards = map(b -> [b[i][j] for i in 1:5, j in 1:5], boards)
    (numbers = numbers, boards = boards)
end

function iswinner(board)
    winningcolumn = sum(sum(board, dims=1) .== 0) > 0
    winningrow =  + sum(sum(board, dims=2) .== 0) > 0
    winningcolumn || winningrow
end

function drawnumber!(boards, number)
    for board in boards 
        i = findfirst(x -> x == number, board)
        (i !== nothing) && (board[i] = 0)
    end
    filter(b -> iswinner(b), boards)
end

function getanswer(input, stopfunction)
    number = 0
    winners = nothing
    while !stopfunction(input)
        number = pop!(input.numbers)
        winners = drawnumber!(input.boards, number)
        setdiff!(input.boards, winners)
    end
    sum(winners[1]) * number
end

function solve1(input)
    initiallength = length(input.boards)
    getanswer(input, input -> length(input.boards) < initiallength)
end

function solve2(input)
    getanswer(input, input -> isempty(input.boards))
end

puzzles = [
    Puzzle(4, "test 1", "input-test1.txt", solve1, 4512),
    Puzzle(4, "deel 1", solve1, 82440),
    Puzzle(4, "test 2", "input-test1.txt", solve2, 1924),
    Puzzle(4, "deel 2", solve2, 20774)
]

printresults(puzzles)

end