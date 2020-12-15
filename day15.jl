function solve(N, start_sequence)
    ret = zeros(Int, N)
    ret[1:length(start_sequence)] = start_sequence
    lastseen = Dict{Int, Int}()
    for i in 1:N-1
        if haskey(lastseen, ret[i])
            ret[i + 1] = i - lastseen[ret[i]]
        end
        lastseen[ret[i]] = i
    end
    last(ret)
end

function main()
    filename = "inputs/day15.txt"
    numbers = read(filename, String) |> strip |> x -> split(x, ",") |> x -> parse.(Int, x)
    part1_solution = solve(2020, numbers)

    part2_solution = solve(30000000, numbers)

    part1_solution, part2_solution
end

@time part1_solution, part2_solution = main()
@show part1_solution
@show part2_solution
