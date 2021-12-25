module Day25

include("./../aoc.jl")

using .AOC


function AOC.processinput(data)
    data = split(data, '\n')
    [data[i][j] for i in 1:length(data), j in 1:length(data[1])]
end

function neighbour(state, index, herd)
    rows, cols = size(state)
    herd == '>' ? index = CartesianIndex(index[1], index[2] == cols ? 1 : index[2] + 1) : index = CartesianIndex(index[1] == rows ? 1 : index[1] + 1, index[2])
end

function canmove(state::Matrix{Char}, index::CartesianIndex, herd::Char)
    return state[neighbour(state, index, herd)] == '.'    
end

function canmove(state::Matrix{Char}, herd::Char)
    filter(i -> state[i] == herd && canmove(state, i, herd), CartesianIndices(state))
end

function step!(state, herd)    
    movers = canmove(state, herd)
    neighbours = map(index -> neighbour(state, index, herd), movers)
    state[movers] .= '.'
    state[neighbours] .= herd
    state
end

function solve1(state)
    steps = 0
    oldstate = []
    while state != oldstate
        oldstate = copy(state)
        state = step!(state, '>')
        state = step!(state, 'v')
        steps += 1
    end
    steps
end

function solve2(input)
    "nog te bepalen"
end

puzzles = [
    Puzzle(25, "test 1", "input-test1.txt", solve1, 58),
    Puzzle(25, "deel 1", solve1, 417),
    # Puzzle(25, "test 2", "input-test1.txt", solve2, nothing),
    # Puzzle(25, "deel 2", solve2, nothing)
]

printresults(puzzles)

end