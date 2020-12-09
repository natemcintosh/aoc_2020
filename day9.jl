using Combinatorics

function number_is_bad(window, number)
    !any(x+y == number for (x,y) in combinations(window, 2))
end

@views function part1(data, preample_length)
    window_start_idx = 1
    for idx in (window_start_idx + preample_length) : length(data)
        if number_is_bad(data[window_start_idx:(window_start_idx + preample_length)], data[idx])
            return data[idx]
        end
        window_start_idx += 1
    end
    0
end

@views function part2(data, number)
    for idx in 1:length(data)
        set_size = 2
        while true
            nums = data[idx : (idx + set_size)]
            sum_nums = sum(nums)
            if sum_nums == number
                return minimum(nums) + maximum(nums)
            elseif sum_nums > number
                break
            end
            set_size += 1
        end
    end
end

@time begin
    data = parse.(Int, readlines("inputs/day9.txt"))
    part1_solution = part1(data, 25)
    @show part1_solution

    part2_solution = part2(data, part1_solution)
    @show part2_solution    
end
