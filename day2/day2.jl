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

Position() = Position(0, 0, 0)
Position(x, depth) = Position(x, depth, 0)

function AOC.processinput(data)
    data = split(data, '\n')
    data = map(c -> (s = split(c, ' ' ); Command(Symbol(s[1]), parse(Int, s[2]))), data)
end

function update1(position::Position, command::Command)::Position
    if command.direction == :forward
        Position(position.x + command.units, position.depth)
    elseif command.direction == :down
        Position(position.x, position.depth + command.units)
    elseif command.direction == :up
        Position(position.x, position.depth - command.units)
    end
end

function update2(position::Position, command::Command)::Position
    if command.direction == :forward
        Position(position.x + command.units, position.depth + position.aim * command.units, position.aim)
    elseif command.direction == :down
        Position(position.x, position.depth, position.aim + command.units)
    elseif command.direction == :up
        Position(position.x, position.depth, position.aim - command.units)
    end
end

function solve(input, update)
    commands = input
    position = Position()
    for command in commands
        position = update(position, command)
    end
    position.x * position.depth
end

function solve1(input)
    solve(input, update1)
end

function solve2(input)
    solve(input, update2)
end

puzzles = [
    Puzzle(2, "test 1", "input-test1.txt", solve1, 150),
    Puzzle(2, "deel 1", solve1, 1815044),
    Puzzle(2, "test 2", "input-test1.txt", solve2, 900),
    Puzzle(2, "deel 2", solve2, 1739283308)
]

getresults(puzzles)