using Underscores

function create_bool_array(filename)
    nested = filename |> readlines .|> Iterators.flatten .|> collect
    vcat([reshape(slice, :, length(slice)) for slice in nested]...)
end

function count_adjacent_occupied(arr::AbstractArray, idx)
    row = idx[1]
    col = idx[2]
    sum(
        arr[row_i, col_i] == '#'
        for (row_i, col_i) in Iterators.product([row-1,row,row+1], [col-1,col,col+1])
        if checkbounds(Bool, arr, row_i, col_i) && !((row_i == row) && (col_i == col))
    )
end

function iterate_part1!(arr)
    # At empty spots, check for 0 occupied adjacent seats
    all_empty_adjacents = [
        x for x in findall(x -> x == 'L', arr) if count_adjacent_occupied(arr, x) == 0
    ]

    # At occupied spots, check for four or more occupied adjacent spots
    four_or_more = [
        x for x in findall(x -> x == '#', arr) if count_adjacent_occupied(arr, x) >= 4
    ]

    # At the end, carry out the swaps
    arr[all_empty_adjacents] .=  '#'
    arr[four_or_more] .= 'L'

    # Count the number of changes
    n_changes = sum(arr .!= arr)
    (arr, n_changes)
end

const directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]

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

function iterate_part2!(arr)
    # At empty spots, check for 0 occupied adjacent seats
    all_empty_adjacents = [
        x for x in findall(x -> x == 'L', arr) if count_sight_occupied(arr, x) == 0
    ]

    # At occupied spots, check for four or more occupied adjacent spots
    four_or_more = [
        x for x in findall(x -> x == '#', arr) if count_sight_occupied(arr, x) >= 5
    ]

    # At the end, carry out the swaps
    arr[all_empty_adjacents] .=  '#'
    arr[four_or_more] .= 'L'

    # Count the number of changes
    n_changes = sum(arr .!= arr)
    (arr, n_changes)
end

function solve(arr, iterate_fn)
    n_changes = 1
    while n_changes > 0
        (arr, n_changes) = iterate_fn(arr)
    end
    @_  count(_ == '#', arr)
end

@time begin
    filename = "inputs/day11.txt"
    input_arr = create_bool_array(filename)

    part1_solution = solve(copy(input_arr), iterate_part1)
    @show part1_solution

    part2_solution = solve(copy(input_arr), iterate_part2)
    @show part2_solution
end
