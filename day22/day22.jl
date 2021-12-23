module Day22

include("./../aoc.jl")

using .AOC

struct Range
    v1
    v2
end

struct Cube
    x::Range
    y::Range
    z::Range
end

Cube(xl, xr, yl, yr, zl, zr) = Cube(Range(xl, xr), Range(yl, yr), Range(zl, zr))
Cube(r1, r2, r3) = Cube(Range(r1.v1, r1.v2), Range(r2.v1, r2.v2), Range(r3.v1, r3.v2))


Base.show(io::IO, c::Cube) = show(io, "(($(c.x.v1),$(c.x.v2)),($(c.y.v1),$(c.y.v2)),($(c.z.v1),$(c.z.v2)))")

Area = Tuple{Int, Cube}

struct Reactor
    areas::Vector{Area}
end


Reactor() = Reactor([])

function processline(line)
    data = split(line)
    command = data[1] == "on" ? 1 : 0
    ranges = map(x -> split.(x[3:end], "..")  , split(data[2], ","))
    ranges = map(x -> parse.(Int, x), ranges)
    ranges = map(x -> Range(x[1], x[2]), ranges)    
    (command = command, cube = Cube(ranges...))
end

function AOC.processinput(data)
    data = split(data, '\n')
    data = map(line -> processline(line), data)
end

function size(c::Cube)::Int
    x = c.x.v2 - c.x.v1 + 1
    y = c.y.v2 - c.y.v1 + 1
    z = c.z.v2 - c.z.v1 + 1
    x <=0 || y<0 || z <= 0 ? 0 : x * y * z
end

function size(a::Area)::Int
    a[1] * size(a[2])
end

function size(areas::AbstractVector{Area})
    sum(map(c -> size(c), areas))
end

function size(r::Reactor)
    size(r.areas)
end

function intersection(c1::Cube, c2::Cube)::Cube
    x1 = max(c2.x.v1, c1.x.v1)
    x2 = min(c2.x.v2, c1.x.v2)
    y1 = max(c2.y.v1, c1.y.v1)
    y2 = min(c2.y.v2, c1.y.v2)
    z1 = max(c2.z.v1, c1.z.v1)
    z2 = min(c2.z.v2, c1.z.v2)
    Cube(x1, x2, y1, y2, z1, z2)
end

function intersection(area::Area, cube::Cube)::Area
    return (-area[1], intersection(area[2], cube))
end

function intersection(areas::AbstractVector{Area}, cube::Cube)
    map(area -> intersection(area, cube), areas)
end

function cleanup!(cubes::AbstractVector{Area})
    filter!(c -> size(c[2]) > 0, cubes)
end

function cleanup!(reactor::Reactor, maximized = true)
    cleanup!(reactor.areas)
end

function initializationrange(input)
    map(i -> (command = i.command, ranges = [max(i.cube.x.v1+51, 1):min(i.cube.x.v2+51, 101), max(i.cube.y.v1+51, 1):min(i.cube.y.v2+51, 101),max(i.cube.z.v1+51, 1):min(i.cube.z.v2+51, 101)]), input)    
end

function solve1(input)
    reactor = zeros(Bool, (101, 101, 101))
    foreach(i -> reactor[i.ranges...] .= i.command, initializationrange(input))
    sum(reactor)
end

function solve2(input)
    reactor = Reactor()
    for i in 1:length(input)
        command, cube = input[i]
        areas = intersection(reactor.areas, cube)
        push!(reactor.areas, areas...)
        command == 1 && push!(reactor.areas, (1, cube))
        cleanup!(reactor)        
    end    
    size(reactor)
end

puzzles = [
    Puzzle(22, "test 1", "input-test1.txt", solve1, 590784),
    Puzzle(22, "deel 1", solve1, 596989),
    Puzzle(22, "test 2", "input-test2.txt", solve2, 2758514936282235),
    Puzzle(22, "deel 2", solve2, 1160011199157381)
]

printresults(puzzles)

end
