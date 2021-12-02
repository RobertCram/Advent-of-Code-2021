println("Advent of Code 2021")

for i in 1:25
    filename = "day$(i)/day$(i).jl"
    !isfile(filename) && break
    
    println("")
    println("Day $(i)")
    include("day$(i)/day$(i).jl")
end

