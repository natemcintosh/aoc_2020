function build_instructions(filename)
    boot_code = readlines(filename) .|> split
    instructions = first.(boot_code)
    arguments = @. parse(Int, last(boot_code))
    [Pair(instr, arg) for (instr, arg) in zip(instructions, arguments)]
end


function interpret_instruction(instruction, argument, accumulator, curr_idx)
    if instruction == "acc"
        accumulator += argument
        new_idx = curr_idx + 1
    elseif instruction == "jmp"
        new_idx = curr_idx + argument
    elseif instruction == "nop"
        new_idx = curr_idx + 1
    end
    (accumulator, new_idx)
end


function main_loop(code)
    n_ops = length(code)
    curr_idx = 1
    accumulator = 0
    seen_idx = Set()
    state = :unfinished
    while true
        # See if we've reached final instruction (one outside of bounds)
        if curr_idx > n_ops
            state = :valid
            break
        end

        # If we have seen this index before, break the loop
        if curr_idx in seen_idx
            state = :infinite
            break
        else
            push!(seen_idx, curr_idx)
        end

        # If we have not, execute the instruction and add it's index to those already
        # seen
        (accumulator, curr_idx) = interpret_instruction(
            first(code[curr_idx]),
            last(code[curr_idx]),
            accumulator,
            curr_idx
        )
    end
    (accumulator, state)
end


function change_instructions_till_valid(code)
    # Get the indices of jumps and no-ops.
    jmps_and_nops_idx = findall(code .|> first .|> x -> (x == "nop") || (x == "jmp"))
    
    # For each location, flip the instruction, test the main loop. 
    # Break if state is valid
    accumulator = NaN
    for idx in jmps_and_nops_idx
        flipped_code = flip_code(code, idx)
        (accumulator, state) = main_loop(flipped_code)
        if state == :valid
            break
        end
    end
    accumulator
end


function flip_code(code, idx)
    op = code[idx]
    instruction = first(op)
    arg = last(op)
    new_code = copy(code)
    if instruction == "jmp"
        new_code[idx] = Pair("nop", arg)
    else
        new_code[idx] = Pair("jmp", arg)
    end
    new_code
end

@time begin
    # Script
    filename = "inputs/day8.txt"
    code = build_instructions(filename)

    # Part 1
    (final_value, state) = main_loop(code)
    part1_solution = final_value
    @show part1_solution

    # Part 2
    part2_solution = change_instructions_till_valid(code)
    @show part2_solution
end
