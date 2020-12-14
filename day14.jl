function get_chunks_from_file(filename)
    data = read(filename, String)
    split(data, "mask = ", keepempty = false)
end

function parse_chunk(chunk)
    parts = split(chunk, "\n", keepempty=false)
    # mask = parts |> first |> Iterators.flatten |> collect |> reverse
    mask = parts |> first |> Iterators.flatten |> collect

    raw_numbers = [
        parse.(Int, [m.match for m in eachmatch(r"(\d+)", assignment)])
        for assignment in parts[2:end]
    ]
    assignments = [(address=first(p), value=last(p)) for p in raw_numbers]

    (mask=mask, assignments=assignments)
end

function mask_vals(chunk)
    function inner_func(assignment)
        # Create the binary char array version of the value
        bin_val = digits(assignment.value, base=2, pad=36) |>
            join              |>
            Iterators.flatten |>
            collect           |>
            reverse

        # Replace values with mask values wherever the mask is not X
        not_x_idx = chunk.mask .!= 'X'
        bin_val[not_x_idx] = chunk.mask[not_x_idx]
        (assignment.address => parse(Int, join(bin_val), base=2))
    end
    inner_func.(chunk.assignments)
end

function mask_addresses(chunk)
    function inner_func(assignment)
        # Create the binary char array version of the address
        bin_addr = digits(assignment.address, base=2, pad=36) |>
            join              |>
            Iterators.flatten |>
            collect           |>
            reverse

        # Apply the mask, and keep track of where the Xs are
        x_idx = Int[]
        for (idx, item) in enumerate(chunk.mask)
            if item == '1'
                bin_addr[idx] = '1'
            elseif item == 'X'
                bin_addr[idx] = 'X'
                push!(x_idx, idx)
            end
        end

        # For each X, replace with permutations, and create pair
        mem_pairs = Pair[]
        for p in Iterators.product(Iterators.repeated(['0','1'], length(x_idx))...)
            bin_addr[x_idx] .= p
            dec_addr = parse(Int, join(bin_addr), base=2)
            push!(mem_pairs, Pair(dec_addr, assignment.value))
        end
        mem_pairs
    end
    inner_func.(chunk.assignments) |> Iterators.flatten |> collect
end

function main()
    filename = "inputs/day14.txt"
    chunks = parse_chunk.(get_chunks_from_file(filename))

    part1_solution = chunks .|> mask_vals |> Iterators.flatten |> Dict |> values |> sum

    part2_solution = chunks .|> mask_addresses |> Iterators.flatten |> Dict |> values |> sum

    (part1_solution, part2_solution)
end

@time part1_solution, part2_solution = main()
@show part1_solution
@show part2_solution
