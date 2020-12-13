function parse_input_part1(lines)
    my_time = parse(Int, lines[1])
    bus_times = [parse(Int, t) for t in split(lines[2], ",") if t != "x"]
    my_time, bus_times
end

function mins_after_I_arrive(my_time, bus_time)
    bus_time - rem(my_time, bus_time)
end

function part1(my_time, bus_times)
    wait_times = mins_after_I_arrive.(my_time, bus_times)
    smalles_idx = argmin(wait_times)
    bus_times[smalles_idx] * wait_times[smalles_idx]
end

function parse_input_part2(lines)
    [
        Pair(parse(Int, t), idx-1)
        for (idx, t) in enumerate(split(lines[2], ","))
        if t != "x"
    ]
end

function part2(bus_time_offsets)
    # Build up the final time starting from 0
    final_time = 0

    jump_size = first(bus_time_offsets[1])
    for (bus_time, offset) in bus_time_offsets[2:end]
        # While searching for the next correct time, increase final time by jump_size
        while (final_time + offset) % bus_time != 0
            final_time += jump_size
        end

        # New jump size is old one times this bus periodic
        jump_size *= bus_time
    end
    final_time
end

function main()
    lines = readlines("inputs/day13.txt")
    my_time, bus_times = parse_input_part1(lines)

    part1_solution = part1(my_time, bus_times)

    bus_time_offsets = parse_input_part2(lines)
    part2_solution = part2(bus_time_offsets)

    part1_solution, part2_solution
end

@time part1_solution, part2_solution = main()
@show part1_solution
@show part2_solution
