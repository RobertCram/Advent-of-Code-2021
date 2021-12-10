module Day10

include("./../aoc.jl")

using .AOC

function AOC.processinput(data)
    data = split(data, '\n')
end

const Openingbrackets = "([{<"
const Closingbrackets = ")]}>"

const ErrorScores = Dict(
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
)

const AutoCompleteScores = Dict(
    '(' => 1,
    '[' => 2,
    '{' => 3,
    '<' => 4
)

function getstack(line::AbstractString)    
    stack = []
    for c in line 
        if c in Openingbrackets
            push!(stack, c)
        elseif c in Closingbrackets
            pop!(stack) == Openingbrackets[findfirst(c, Closingbrackets)] || return (stack = stack, error = c)
        end
    end
    (stack = stack, error = nothing)
end

function getautocompletescore(stack)
    reduce((score, bracket) -> 5 * score + AutoCompleteScores[bracket], reverse(stack), init=0)
end

function solve1(lines)
    errors = filter(!isnothing, map(line -> getstack(line).error, lines))
    sum(map(e -> ErrorScores[e], errors))
end

function solve2(lines)
    linestocomplete = lines[map(line -> isnothing(getstack(line).error), lines)]
    scores = sort(map(line -> getautocompletescore(getstack(line).stack), linestocomplete))
    scores[(length(scores)+1) ÷ 2]
end

puzzles = [
    Puzzle(10, "test 1", "input-test1.txt", solve1, 26397),
    Puzzle(10, "deel 1", solve1, 319329),
    Puzzle(10, "test 2", "input-test1.txt", solve2, 288957),
    Puzzle(10, "deel 2", solve2, 3515583998)
]

printresults(puzzles)

end