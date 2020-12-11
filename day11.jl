using Underscores

function create_bool_array(filename)
    nested = filename |> readlines .|> Iterators.flatten .|> collect
    vcat([reshape(slice, :, length(slice)) for slice in nested]...)
end

const directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]

function count_adjacent_occupied(arr::AbstractArray, idx)
    sum(
        arr[idx[1]+row, idx[2]+col] == '#'
        for (row, col) in directions
        if checkbounds(Bool, arr, idx[1]+row, idx[2]+col)
    )
end

function iterate(arr, adjacent_fn, tolerance)
    # At empty spots, check for 0 occupied adjacent seats
    all_empty_adjacents = [
        x for x in findall(x -> x == 'L', arr) if adjacent_fn(arr, x) == 0
    ]

    # At occupied spots, check for four or more occupied adjacent spots
    four_or_more = [
        x for x in findall(x -> x == '#', arr) if adjacent_fn(arr, x) >= tolerance
    ]

    # At the end, carry out the swaps
    new_arr = copy(arr)
    new_arr[all_empty_adjacents] .=  '#'
    new_arr[four_or_more] .= 'L'

    # Count the number of changes
    n_changes = sum(new_arr .!= arr)
    (new_arr, n_changes)
end

function can_see_occupied_seat(arr, idx, direction)
    # Start from idx, and move in direction until we either
    #   - go over edge of array -> false
    #   - hit empty seat        -> false
    #   - hit occupied seat     -> true
    row = idx[1] + direction[1]
    col = idx[2] + direction[2]
    while checkbounds(Bool, arr, row, col)
        if arr[row, col] == 'L'
            return false
        elseif arr[row, col] == '#'
            return true
        end
        row += direction[1]
        col += direction[2]
    end
    false
end

function count_sight_occupied(arr, idx)
    @_ count(can_see_occupied_seat(arr, idx, _), directions)
end

function solve(arr, adjacent_fn, tolerance)
    n_changes = 1
    while n_changes > 0
        (arr, n_changes) = iterate(arr, adjacent_fn, tolerance)
    end
    @_  count(_ == '#', arr)
end

@time begin
    filename = "inputs/day11.txt"
    input_arr = create_bool_array(filename)

    part1_solution = solve(copy(input_arr), count_adjacent_occupied, 4)
    @show part1_solution

    part2_solution = solve(copy(input_arr), count_sight_occupied, 5)
    @show part2_solution
end
