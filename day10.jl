function part1(adapters)
    adapters    |>
        sort    |>
        diff    |>
        counter |>
        values  |>
        prod
end

function counter(data::AbstractArray{T}) where T
    c = Dict()
    for d in data
        if haskey(c, d)
            c[d] += 1
        else
            c[d] = 1
        end
    end
    c
end

"""
part2 works by knowing that the number of paths we can take to get to any individual
adapter is the sum of the possible ways that that adapter can be reached by those within
3 steps before it
"""
function part2(adapters)
    # adapters = vcat([0, maximum(adapters) + 3], adapters) |> sort
    n = length(adapters)
    different_paths = zeros(Int, n)
    different_paths[1] = 1
    for i=1:n
        for j=1:3
            # If we're over the end, skip
            if i+j > n
                continue
            end

            # How big is the gap from item i to item i+j?
            item_diff = adapters[i+j]-adapters[i]

            # If it's > 3, not reachable.
            # If it's <= 3, we can reach the item at i+j. Add the number of ways to get
            # to item i to the number at ij
            if item_diff <= 3
                different_paths[i+j] += different_paths[i]
            end
        end
    end
    return last(different_paths)
    # This is really just a big accumulation?
    # How can we potentially replace this with some simpler functions?
end


@time begin
    adapters = "inputs/day10.txt" |> 
        readlines |> 
        x -> parse.(Int, x) |> 
        x -> vcat([0, maximum(x) + 3], x) |> 
        sort
    part1_solution = part1(adapters)
    @show part1_solution

    part2_solution = part2(adapters)
    @show part2_solution
end
