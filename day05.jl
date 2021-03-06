using Statistics

function parse_ticket_location(str)
    front_back_text = str[1:7]
    front_back_location = recursive_reduce(front_back_text, 0:127, 'F', 'B')

    left_right_text = str[8:end]
    left_right_location = recursive_reduce(left_right_text, 0:7, 'L', 'R')

    (row=front_back_location, col=left_right_location)
end


function recursive_reduce(text, positions, forward_char, backward_char)
    (head, tail) = Iterators.peel(text)
    middle = positions |> median |> floor |> Int
    if head == forward_char
        new_position = first(positions):middle
    elseif head == backward_char
        new_position = middle+1:last(positions)
    else
        error("Didn't get a $forward_char or $backward_char in $text")
    end
    if length(new_position) == 1
        return only(new_position)
    end
    recursive_reduce(tail, new_position, forward_char, backward_char)
end


function seat_ID(seat)
    seat_loc = parse_ticket_location(seat)
    seat_loc.row * 8 + seat_loc.col
end


function main()
    # Script
    filename = "inputs/day05.txt"
    input = readlines(filename)

    # Part 1
    all_seat_ids = seat_ID.(input) |> sort
    part1_solution = maximum(all_seat_ids)

    # Part 2
    seat_before_me_idx = findall(x -> x > 1, diff(all_seat_ids))
    part2_solution = only(all_seat_ids[seat_before_me_idx]) + 1

    (part1_solution, part2_solution)
end

@time (part1_solution, part2_solution) = main()
@show part1_solution
@show part2_solution
