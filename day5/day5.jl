module Day5

include("./../aoc.jl")

using .AOC

struct Point
    x::Int
    y::Int
end

function Point(coords::AbstractString) 
    x, y = parse.(Int, split(coords, ","))
    Point(x, y)
end

struct Line
    p1::Point
    p2::Point
end

function Line(points::AbstractString)    
    p1, p2 = map(Point, split(points, " -> "))
    Line(p1, p2)
end

function AOC.processinput(data)
    Line.(split(data, '\n'))
end

function getincrement(line)
    x = line.p2.x - line.p1.x
    y = line.p2.y - line.p1.y
    sign(x), sign(y)     
end

function ishorizontalorvertical(line::Line)
    incx, incy = getincrement(line)
    incx == 0 || incy == 0
end

function countmap(points)
    reduce((result, point) -> (haskey(result, point) ? result[point] += 1 : result[point] = 1; result), points, init=Dict([]))
end

function getpoints!(points::AbstractArray, line::Line)
    incx, incy = getincrement(line)
    push!(points, line.p1)
    while points[end] !== line.p2
        point = Point(points[end].x + incx, points[end].y + incy)
        push!(points, point)
    end
    points
end

function getnumberofoverlaps(lines)
    points = reduce(getpoints!, lines, init=[])
    count(>(1), values(countmap(points)))
end

function solve1(lines)
    lines = filter(ishorizontalorvertical, lines)
    getnumberofoverlaps(lines)
end

function solve2(lines)
    getnumberofoverlaps(lines)
end

puzzles = [
    Puzzle(5, "test 1", "input-test1.txt", solve1, 5),
    Puzzle(5, "deel 1", solve1, 7473),
    Puzzle(5, "test 2", "input-test1.txt", solve2, 12),
    Puzzle(5, "deel 2", solve2, 24164)
]

printresults(puzzles)

end