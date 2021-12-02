function clearterminal()
    print("\033c")
end

function bold(str)
    "\033[1m$(str)\033[0m"
end

clearterminal()
println()
println(bold("Advent of Code 2021"))

for i in 1:25
    filename = "day$(i)/day$(i).jl"
    !isfile(filename) && break

    println()
    println("Day $(i)")
    include("day$(i)/day$(i).jl")
end
