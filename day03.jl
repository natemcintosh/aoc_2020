function create_bool_array(filename)
    nested = filename |> readlines .|> Iterators.flatten .|> collect

    char_array = vcat([reshape(slice, :, length(slice)) for slice in nested]...)

    char_array .== '#'
end

function find_locations_visited(arr, start_position, stride_size)
    (nrows, ncols) = size(arr)

    # Build up vector of x-positions
    x_positions_all_the_way = start_position.x .+ collect(0:(nrows-1)) .* stride_size.x
    # Take the mod so we can use the same array
    x_positions = mod.(x_positions_all_the_way, ncols)
    # Julia doesn't do indexing at 0, replace zeros with the farthest right location
    replace!(x_positions, 0=>ncols)

    # Create the y-positions
    y_positions = start_position.y:stride_size.y:nrows

    # Create the final set of indices
    # NB that the order of y-position, then x-position
    CartesianIndex.(zip(y_positions, x_positions))
end

function main()
    filename = "inputs/day03.txt"
    arr = create_bool_array(filename)

    # Part 1 solution
    start_position = (x=1, y=1)
    stride_size = (x=3, y=1)
    visited_indices = find_locations_visited(arr, start_position, stride_size)
    part1_solution = sum(arr[visited_indices])

    # Part 2 solution
    stride_sizes = [
        (x=1, y=1),
        (x=3, y=1),
        (x=5, y=1),
        (x=7, y=1),
        (x=1, y=2),
    ]

    part2_solution = prod(
        stride_i -> sum(arr[find_locations_visited(arr, start_position, stride_i)]),
        stride_sizes
        )

    (part1_solution, part2_solution)
end

@time (part1_solution, part2_solution) = main()
@show part1_solution
@show part2_solution
