module Day24

include("./../aoc.jl")

using .AOC

function processline(line)
    splitline = split(line)
    command = Symbol(splitline[1])
    var1 = occursin(splitline[2],  "wxyz") ? Symbol(splitline[2]) : parse(Int, splitline[2])
    var2 = length(splitline) == 3 ? (occursin(splitline[3], "wxyz") ? Symbol(splitline[3]) : parse(Int, splitline[3])) : nothing
    (command = command, var1 = var1, var2 = var2)
end

function AOC.processinput(data)
    data = processline.(split(data, '\n'))
end

function value(register, var)
    typeof(var) <: Symbol && return register[var]
    var
end

const Instructions = Dict(
    :inp => (register, input, var1, var2) -> register[var1] = pop!(input),
    :add => (register, input, var1, var2) -> register[var1] = register[var1] + value(register, var2),
    :mul => (register, input, var1, var2) -> register[var1] = register[var1] * value(register, var2),
    :div => (register, input, var1, var2) -> register[var1] = register[var1] ÷ value(register, var2),
    :mod => (register, input, var1, var2) -> register[var1] = mod(register[var1], value(register, var2)),
    :eql => (register, input, var1, var2) -> register[var1] = Int(register[var1] == value(register, var2))
)

function run(program, input)
    input = reverse(input)
    registers = Dict{Symbol, Int}(reg => 0 for reg in [:w, :x, :y, :z])
    foreach(i -> Instructions[i.command](registers, input, i.var1, i.var2), program)
    registers
end

function monad(input)
    registers = Dict{Symbol, Int}(reg => 0 for reg in [:w, :x, :y, :z])
    # step 1
    registers[:w] = input[1]
    registers[:x] = 1
    registers[:y] = input[1] + 14
    registers[:z] = input[1] + 14

    # step 2
    registers[:w] = input[2]
    registers[:x] = 1
    registers[:y] = input[2] + 8
    registers[:z] = 26 * (input[1] + 14) + input[2] + 8

    # step 3
    registers[:w] = input[3]
    registers[:x] = 1
    registers[:y] = input[3] + 5
    registers[:z] = 26 * (26 * (input[1] + 14) + input[2] + 8) + input[3] + 5

    # step 4
    registers[:w] = input[4]
    registers[:x] = input[4] == input[3] + 5 ? 0 : 1
    registers[:y] = input[4] == input[3] + 5 ? 0 : input[4] + 4
    registers[:z] = input[4] == input[3] + 5 ? 26 * (input[1] + 14) + input[2] + 8 : 26 * (26 * (input[1] + 14) + input[2] + 8) + input[4] + 4
    
    # step 5
    registers[:w] = input[5]
    registers[:x] = 1
    registers[:y] = input[5] + 10
    registers[:z] = 26 * registers[:z] + input[5] + 10

    # step 6
    registers[:w] = input[6]
    registers[:x] = input[6] == input[5] - 3 ? 0 : 1
    registers[:y] = input[6] == input[5] - 3 ? 0 : input[6] + 13
    registers[:z] = input[6] == input[5] - 3 ? registers[:z] ÷ 26  : 26 * (registers[:z] ÷ 26) + input[6] + 13

    # step 7
    registers[:w] = input[7]
    registers[:x] = 1
    registers[:y] = input[7] + 16
    registers[:z] = 26 * registers[:z] + input[7] + 16

    # step 8
    registers[:w] = input[8]
    registers[:x] = input[8] == input[7] + 7 ? 0 : 1
    registers[:y] = input[8] == input[7] + 7 ? 0 : input[8] + 5
    registers[:z] = input[8] == input[7] + 7 ? registers[:z] ÷ 26 : 26 * (registers[:z] ÷ 26) + input[8] + 5

    # step 9
    registers[:w] = input[9]
    registers[:x] = 1
    registers[:y] = input[9] + 6
    registers[:z] = 26 *(registers[:z]) + input[9] + 6

    # step 10
    registers[:w] = input[10]
    registers[:x] = 1
    registers[:y] = input[10] + 13
    registers[:z] = 26 *(registers[:z]) + input[10] + 13

    # step 11
    registers[:w] = input[11]
    registers[:x] = input[11] == input[10] - 1 ? 0 : 1
    registers[:y] = input[11] == input[10] - 1 ? 0 : input[11] + 6
    registers[:z] = input[11] == input[10] - 1 ? registers[:z] ÷ 26 : 26 * (registers[:z] ÷ 26) + input[11] + 6

    # step 12
    registers[:w] = input[12]
    registers[:x] = input[12] == mod(registers[:z], 26) - 3 ? 0 : 1
    registers[:y] = input[12] == mod(registers[:z], 26) - 3 ? 0 : input[12] + 7
    registers[:z] = input[12] == mod(registers[:z], 26) - 3 ? registers[:z] ÷ 26 : 26 * (registers[:z] ÷ 26) + input[12] + 7

    # step 13
    registers[:w] = input[13]
    registers[:x] = input[13] == mod(registers[:z], 26) - 2 ? 0 : 1
    registers[:y] = input[13] == mod(registers[:z], 26) - 2 ? 0 : input[13] + 13
    registers[:z] = input[13] == mod(registers[:z], 26) - 2 ? registers[:z] ÷ 26 : 26 * (registers[:z] ÷ 26) + input[13] + 13

    # step 14
    registers[:w] = input[14]
    registers[:x] = input[14] == mod(registers[:z], 26) - 14 ? 0 : 1
    registers[:y] = input[14] == mod(registers[:z], 26) - 14 ? 0 : input[14] + 3
    registers[:z] = input[14] == mod(registers[:z], 26) - 14 ? registers[:z] ÷ 26 : 26 * (registers[:z] ÷ 26) + input[14] + 3

    registers
end


function generatecases1()
    testcases = []
    for i1 in 9:-1:9
        for i2 in 3:-1:3
            for i3 in 4:-1:1
                for i4 in i3+5:i3+5
                    for i5 in 9:-1:4
                        for i6 in i5-3:i5-3
                            for i7 in 2:-1:1
                                for i8 in i7+7:i7+7
                                    for i9 in 6:-1:6
                                        for i10 in 9:-1:2
                                            for i11 in i10-1:i10-1
                                                for i12 in 9:-1:1
                                                    for i13 in 9:-1:1
                                                        for i14 in 9:-1:1
                                                            push!(testcases, [i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14])
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    testcases
end

function generatecases2()
    testcases = []
    for i1 in 1:1
        for i2 in 1:1
            for i3 in 1:4
                for i4 in i3+5:i3+5
                    for i5 in 4:9
                        for i6 in i5-3:i5-3
                            for i7 in 1:2
                                for i8 in i7+7:i7+7
                                    for i9 in 1:1
                                        for i10 in 2:9
                                            for i11 in i10-1:i10-1
                                                for i12 in 1:9
                                                    for i13 in 1:9
                                                        for i14 in 1:9
                                                            push!(testcases, [i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14])
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    testcases
end

function solve1(program) 
    cases = generatecases1()
    reverse(sort(map(d -> parse(Int, join(d[1])), filter(d -> d[2][:z]==0, collect(zip(cases, monad.(cases)))))))[1]
end

function solve2(program)
    cases = generatecases2()
    sort(map(d -> parse(Int, join(d[1])), filter(d -> d[2][:z]==0, collect(zip(cases, monad.(cases))))))[1]
end

puzzles = [
    Puzzle(24, "deel 1", solve1, 93499629698999),
    Puzzle(24, "deel 2", solve2, 11164118121471)
]

printresults(puzzles)

end