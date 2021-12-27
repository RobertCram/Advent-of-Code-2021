module Day23

include("./../aoc.jl")

using .AOC


function AOC.processinput(data)
    data = split(data, '\n')
    r1 = [data[4][4], data[3][4]]
    r2 = [data[4][6], data[3][6]]
    r3 = [data[4][8], data[3][8]]
    r4 = [data[4][10], data[3][10]]
    hallway = [' ' for _ in 1:11]
    (r1 = r1, r2 = r2, r3 = r3, r4 = r4, hallway = hallway)
end

const Roomsize = Ref(2)

const MaxInt = typemax(Int)

const Costs = Dict(
    'A' => 1,
    'B' => 10,
    'C' => 100,
    'D' => 1000 
)

function roomnumber(amphipod)
    amphipod == 'A' && return 1
    amphipod == 'B' && return 2
    amphipod == 'C' && return 3
    amphipod == 'D' && return 4
end

function getroom(state, amphipod::Char)
    amphipod == 'A' && return state.r1
    amphipod == 'B' && return state.r2
    amphipod == 'C' && return state.r3
    amphipod == 'D' && return state.r4
end

function getroom(state, roomnumber::Int)
    roomnumber == 1 && return state.r1
    roomnumber == 2 && return state.r2
    roomnumber == 3 && return state.r3
    roomnumber == 4 && return state.r4
end


function hallwayposition(fromroom)
    1 + 2 * fromroom
end

function openhallwaypositions(hallway, fromroom)::Vector{Int}
    entrance = hallwayposition(fromroom)
    left = findlast(c -> c != ' ', hallway[begin:entrance])
    right = findfirst(c -> c != ' ', hallway[entrance:end])
    left === nothing && (left = 0)
    right === nothing && (right = 12 - entrance + 1)
    right += entrance-1
    setdiff([left+1:entrance-1..., entrance+1:right-1...], [3, 5, 7, 9])
end

function hallwayclear(hallway, position)
    amphipod = hallway[position]
    entrance = hallwayposition(roomnumber(amphipod))
    position < entrance ? length(filter(a -> a != ' ', hallway[position+1:entrance-1])) == 0 : length(filter(a -> a != ' ', hallway[entrance+1:position-1])) == 0    
end

function nointruders(state, amphipod)
    amphipodroom = getroom(state, amphipod)
    r = collect(repeat(' ', Roomsize[]))
    amphipodroom == r && return true
    for i in 1:Roomsize[]
        r[i] = amphipod
        amphipodroom == r && return true
    end     
    return false
end

function cangohome(state, hallwayposition)
    !hallwayclear(state.hallway, hallwayposition) && return false
    amphipod = state.hallway[hallwayposition]
    nointruders(state, amphipod) && return true
    return false
end

function possibleactions(state)
    actions = []
    # room to hallway
    for amphipod in ['A', 'B', 'C', 'D']
        i = roomnumber(amphipod)
        !nointruders(state, amphipod) && push!(actions, map(p -> (from = i, to = 0, pos = p), openhallwaypositions(state.hallway, i))...)
    end

    # hallway to room    
    indices = filter(i -> state.hallway[i] != ' ', 1:length(state.hallway))
    push!(actions, map(p -> (from = 0, to = roomnumber(state.hallway[p]), pos = p), filter(i -> cangohome(state, i), indices))...)
    
    actions
end

function isendstate(state)
    state.state == (
        r1 = collect(repeat('A', Roomsize[])), 
        r2 = collect(repeat('B', Roomsize[])),
        r3 = collect(repeat('C', Roomsize[])),
        r4 = collect(repeat('D', Roomsize[])),
        hallway = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
    )
end

function copystate(state)
    r1 = copy(state.r1)
    r2 = copy(state.r2)
    r3 = copy(state.r3)
    r4 = copy(state.r4)
    hallway = copy(state.hallway)
    (r1 = r1, r2 = r2, r3 = r3, r4 = r4, hallway = hallway)
end

function nextstate(state, action)
    state = copystate(state)
    if action.from == 0        
        toroom = getroom(state, action.to)      
        index = findfirst(c -> c == ' ', toroom)  
        toroom[index] = state.hallway[action.pos]
        cost = (abs(action.pos - hallwayposition(action.to)) + (Roomsize[]-index+1)) * Costs[state.hallway[action.pos]] 
        state.hallway[action.pos] = ' '
    else
        fromroom = getroom(state, action.from)
        index = findlast(c -> c != ' ', fromroom)  
        state.hallway[action.pos] = fromroom[index]
        cost = (abs(action.pos - hallwayposition(action.from)) + (Roomsize[]-index+1)) * Costs[fromroom[index]] 
        fromroom[index] = ' '
    end
    state, cost
end

function cleanup(states, mincosts)
    d = Dict()
    for state in states
        d[state.state] = min(state.costs, get(d, state.state, MaxInt))
    end
    filter(s -> s.costs < mincosts , [(state = k, costs = v) for (k,v) in d])
end

function solve(state)
    mincosts = MaxInt
    states = [(state = state, costs = 0)]
    while !isempty(states)
        newstates = []
        for state in states            
            actions = possibleactions(state.state)
            for action in actions            
                newstate, cost = nextstate(state.state, action)
                push!(newstates, (state = newstate, costs = state.costs + cost))            
            end
        end    
        endstates = newstates[isendstate.(newstates)]
        !isempty(endstates) && (mincosts = min(mincosts, minimum(map(s -> s.costs, endstates))))
        states = cleanup(newstates, mincosts)
        # @show length(states), mincosts
    end
    mincosts
end

function solve1(state)
    solve(state)
end

function solve2(state)
    Roomsize[] = 4
    insert!(state.r1, 2, 'D')
    insert!(state.r1, 3, 'D')
    insert!(state.r2, 2, 'B')
    insert!(state.r2, 3, 'C')
    insert!(state.r3, 2, 'A')
    insert!(state.r3, 3, 'B')
    insert!(state.r4, 2, 'C')
    insert!(state.r4, 3, 'A')
    solve(state)
end


puzzles = [
    Puzzle(23, "test 1", "input-test1.txt", solve1, 12521),
    Puzzle(23, "deel 1", solve1, 15385),
    Puzzle(23, "test 2", "input-test1.txt", solve2, 44169),
    Puzzle(23, "deel 2", solve2, 49803)
]

printresults(puzzles)

end