module Day2

include("./../aoc.jl")

using .AOC

struct Position
    x
    depth
    aim    
end

struct Command
    direction::Symbol
    units
end

const actiontable1 = Dict(
    :forward => (position, units) -> Position(position.x + units, position.depth),
    :down => (position, units) -> Position(position.x, position.depth + units),
    :up => (position, units) -> Position(position.x, position.depth - units)
)

const actiontable2 = Dict(
    :forward => (position, units) -> Position(position.x + units, position.depth + position.aim * units, position.aim),
    :down => (position, units) -> Position(position.x, position.depth, position.aim + units),
    :up => (position, units) -> Position(position.x, position.depth, position.aim - units) 
)
 
Position() = Position(0, 0, 0)
Position(x, depth) = Position(x, depth, 0)

function AOC.processinput(data)
    data = split(data, '\n')
    data = map(c -> (s = split(c, ' ' ); Command(Symbol(s[1]), parse(Int, s[2]))), data)
end

function solve(commands, actiontable)
    update = (position, command) -> actiontable[command.direction](position, command.units)
    position = reduce(update, commands, init = Position())
    position.x * position.depth
end

function solve1(input)
    solve(input, actiontable1)
end

function solve2(input)
    solve(input, actiontable2)
end

puzzles = [
    Puzzle(2, "test 1", "input-test1.txt", solve1, 150),
    Puzzle(2, "deel 1", solve1, 1815044),
    Puzzle(2, "test 2", "input-test1.txt", solve2, 900),
    Puzzle(2, "deel 2", solve2, 1739283308)
]

printresults(puzzles)

end