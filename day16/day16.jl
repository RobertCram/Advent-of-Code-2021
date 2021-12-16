module Day16

include("./../aoc.jl")

using .AOC

Hex2Bin = Dict(
    '0' => "0000",
    '1' => "0001",
    '2' => "0010",
    '3' => "0011",
    '4' => "0100",
    '5' => "0101",
    '6' => "0110",
    '7' => "0111",
    '8' => "1000",
    '9' => "1001",
    'A' => "1010",
    'B' => "1011",
    'C' => "1100",
    'D' => "1101",
    'E' => "1110",
    'F' => "1111"
)
struct Packet
    version::Int
    typeid
    value
    packets::Array{Packet}
end

function AOC.processinput(data)
    data
end

function hex2bin(hex)
    join(map(d -> Hex2Bin[d], collect(hex)))
end

function bin2dec(code::String)
    parse(Int, code, base=2)
end

function parseheader(code)
    version = bin2dec(code[1:3])
    typeid = bin2dec(code[4:6])
    version, typeid
end

function parseliteral(code)
    version, typeid = parseheader(code)
    binvalue = ""
    parts = 1
    code = code[7:end]
    while code[1] == '1'
        binvalue *= code[2:5]
        code = code[6:end]
        parts += 1
    end
    binvalue *= code[2:5]
    value = bin2dec(binvalue)
    Packet(version, typeid, value, Packet[]), code[6:end]
end

function parseoperator0(code)
    version, typeid = parseheader(code)
    subpacketslength = bin2dec(code[8:22])
    packets = Packet[]
    unparsed = code[23+subpacketslength:end]
    code = code[23:22+subpacketslength]
    while !isempty(code)
        packet, code = parsebinary(code)    
        push!(packets, packet)
    end
    Packet(version, typeid, 0, packets), unparsed
end

function parseoperator1(code)
    version, typeid = parseheader(code)
    subpacketsnumber = bin2dec(code[8:18])
    packets = Packet[]
    code = code[19:end]
    for i in 1:subpacketsnumber
        packet, code = parsebinary(code)    
        push!(packets, packet)
    end
    Packet(version, typeid, 0, packets), code
end

function parseoperator(code)
    lengthtypeid = code[7]
    lengthtypeid == '0' && return parseoperator0(code)
    return parseoperator1(code)
end

function parsebinary(code)    
    _, typeid = parseheader(code)
    typeid == 4 && return parseliteral(code)
    return parseoperator(code)
end

function getpacketversionsum(packet)::Int  
    packet.version + sum(getpacketversionsum.(packet.packets))
end

function getpacketvalue(packet)::Int
    packet.typeid == 0 && return reduce(+, getpacketvalue.(packet.packets))
    packet.typeid == 1 && return reduce(*, getpacketvalue.(packet.packets))
    packet.typeid == 2 && return reduce(min, getpacketvalue.(packet.packets))
    packet.typeid == 3 && return reduce(max, getpacketvalue.(packet.packets))
    packet.typeid == 4 && return packet.value
    packet.typeid == 5 && return getpacketvalue(packet.packets[1]) > getpacketvalue(packet.packets[2])
    packet.typeid == 6 && return getpacketvalue(packet.packets[1]) < getpacketvalue(packet.packets[2])
    packet.typeid == 7 && return getpacketvalue(packet.packets[1]) == getpacketvalue(packet.packets[2])
end

function solve(transmission)
    parsebinary(hex2bin(transmission))[1]    
end

function solve1(transmission)
    packet = solve(transmission)
    getpacketversionsum(packet)
end

function solve2(transmission)
    packet = solve(transmission)
    getpacketvalue(packet)
end

puzzles = [
    Puzzle(16, "test 1a", "input-test1.txt", solve1, 16),
    Puzzle(16, "test 1b", "input-test2.txt", solve1, 12),
    Puzzle(16, "test 1c", "input-test3.txt", solve1, 23),
    Puzzle(16, "test 1d", "input-test4.txt", solve1, 31),
    Puzzle(16, "deel 1", solve1, 957),
    Puzzle(16, "deel 2", solve2, 744953223228)
]

printresults(puzzles)

end
