module Day21

include("./../aoc.jl")

using .AOC

mutable struct DeterministicDie
    lastresult
end

DeterministicDie() = DeterministicDie(0)
struct Player
    position
    score
    rolls
end

Player(position) = Player(position, 0, 0)

function AOC.processinput(data)
    data = split(data, '\n')
    parse.(Int, map(x -> x[29:end], data))
end

function roll(die::DeterministicDie, times = 1)
    result = 0
    for _ in 1:times    
        die.lastresult = mod(die.lastresult, 100) + 1
        result += die.lastresult
    end
    result
end

function move(position, places)
    mod((position - 1) + places, 10) + 1
end

function playround(player::Player, distance)
    position = move(player.position, distance)
    score = player.score + position
    Player(position, score, player.rolls + 3)
end

function playround(player::Player, distances::AbstractVector)
    map(d -> playround(player, d), distances)
end

function playround(players::Vector{Player}, distances::AbstractVector, firstturn)
    firstturn ? map(p -> [p, players[2]], playround(players[1], distances)) : map(p -> [players[1], p], playround(players[2], distances))
end

function playround(games::Dict{Vector{Player}, Int}, distances::AbstractVector, firstturn)
    newgames = []
    for game in keys(games)
        push!(newgames, map(x -> x => games[game], playround(game, distances, firstturn))...)        
    end
    d0 = Dict(game => 0 for game in unique(getindex.(newgames, 1)))
    reduce((_, game) -> (d0[game[1]] += game[2]; d0), newgames, init = d0)
end

function checkresults(games)
    player1wins = sum(map(game -> game[1].score >= 21 ? games[game] : 0, collect(keys(games))))
    player2wins = sum(map(game -> game[2].score >= 21 ? games[game] : 0, collect(keys(games))))
    filter(game -> game[1][1].score < 21 && game[1][2].score < 21, games), player1wins, player2wins
end

function solve1(input)
    die = DeterministicDie()
    player1, player2 = Player.(input)
    firstturn = true
    player = player1
    while player.score < 1000
        places = roll(die, 3)
        player = firstturn ? player1 = playround(player1, places) : player2 = playround(player2, places)
        firstturn = !firstturn
    end
    min(player1.score, player2.score) * (player1.rolls + player2.rolls)
end

function solve2(input)    
    player1, player2 = Player.(input)
    games = Dict([player1, player2] => 1)
    wins1, wins2 = 0, 0
    firstturn = true
    while !isempty(games)
        games = playround(games, [i+j+k for i in 1:3 for j in 1:3 for k in 1:3], firstturn)
        firstturn = !firstturn
        games, w1, w2 = checkresults(games)
        wins1 += w1
        wins2 += w2
    end    
    max(wins1, wins2)
end

puzzles = [
    Puzzle(21, "test 1", "input-test1.txt", solve1, 739785),
    Puzzle(21, "deel 1", solve1, 605070),
    Puzzle(21, "test 2", "input-test1.txt", solve2, 444356092776315),
    Puzzle(21, "deel 2", solve2, 218433063958910)
]

printresults(puzzles)

end

