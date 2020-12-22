function parse_input(filename)
    data = split(read(filename, String), "\n\n")
    parse_player_cards.(data)
end

function parse_player_cards(player)
    lines = split(player, "\n")
    cards = parse.(Int, lines[2:end])
end

function comabat(player1, player2)
    p1 = copy(player1)
    p2 = copy(player2)
    while !isempty(p1) && !isempty(p2)
        p1_card = popfirst!(p1)
        p2_card = popfirst!(p2)
        if p1_card > p2_card
            push!(p1, p1_card)
            push!(p1, p2_card)
        elseif p2_card > p1_card
            push!(p2, p2_card)
            push!(p2, p1_card)
        else
            error("Found tie; not sure what to do")
        end
    end
    winner = isempty(p1) ? p2 : p1
    sum(idx * item for (idx, item) in enumerate(reverse(winner)))
end

function recursive_combat(player1, player2)
    p1 = copy(player1)
    p2 = copy(player2)
    prev_game_states = Set()
    winner = :neither_yet
    while !isempty(p1) && !isempty(p2)
        # Complete if we've seen this game state before
        this_game_state = (tuple(p1...),tuple(p2...))
        if this_game_state in prev_game_states
            winner = :p1
            break
        else
            push!(prev_game_states, this_game_state)
        end

        # Continue with normal game
        p1_card = popfirst!(p1)
        p2_card = popfirst!(p2)

        # Check if both players have at least as many cards remaining in their deck as
        # the value of the card they just drew
        if (length(p1) >= p1_card) && (length(p2) >= p2_card)
            # If so, recurse
            _, _, recurse_winner = recursive_combat(p1[1:p1_card], p2[1:p2_card])
            if recurse_winner == :p1
                push!(p1, p1_card)
                push!(p1, p2_card)
            elseif recurse_winner == :p2
                push!(p2, p2_card)
                push!(p2, p1_card)
            else
                error("calling recursive_combat returned $recurse_winner instead of p1 or p2")
            end
        else
            # else, determine winner normally
            if p1_card > p2_card
                push!(p1, p1_card)
                push!(p1, p2_card)
            elseif p2_card > p1_card
                push!(p2, p2_card)
                push!(p2, p1_card)
            else
                error("Found tie; not sure what to do")
            end
        end
    end

    if winner != :neither_yet
        winner = winner
    elseif isempty(p1)
        winner = :p2
    elseif isempty(p2)
        winner = :p1
    else
        error("Left the while loop without determing a winner: p1=$p1, p2=$p2")
    end
    p1, p2, winner
end

function part2(player1, player2)
    p1, p2, winner = recursive_combat(player1, player2)
    winning_cards =  winner == :p1 ? p1 : p2
    sum(idx * item for (idx, item) in enumerate(reverse(winning_cards)))
end

function main()
    filename = "inputs/day22.txt"
    p1, p2 = parse_input(filename)

    part1_solution = comabat(p1, p2)

    part2_solution = part2(p1, p2)

    part1_solution, part2_solution
end

@time part1_solution, part2_solution = main()
@show part1_solution
@show part2_solution
