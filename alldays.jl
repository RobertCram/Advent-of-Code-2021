function clearterminal()
    print("\033c")
end

function bold(str)
    "\033[1m$(str)\033[0m"
end

function gray(str)
    "\e[2m$(str)\e[0m"
end

function showday(i)
    filename = "day$(i)/day$(i).jl"
    !isfile(filename) && return false

    println()
    println("Day $(i)")
    include("day$(i)/day$(i).jl")
    return true
end

clearterminal()
println()
println(bold("Advent of Code 2021"))

for i in 1:25
    stats = @timed showday(i) || break
    println(gray("Elapsed time (in secs): $(stats.time)"))
end
