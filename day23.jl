function iterate(n, pos, max_val)
    if pos % 100 == 0
        @show pos
    end
    wrapped_pos = mod(pos, length(n))
    wrapped_pos = wrapped_pos == 0 ? length(n) : wrapped_pos
    cur_cup = n[wrapped_pos]
    inds = replace(mod.(pos + 1 : pos + 3, length(n)), 0=>length(n))
    to_move = n[inds]
    remaining = setdiff(n, to_move)
    destination_cup, dest_idx = find_dest(remaining, cur_cup, max_val)
    n2 = vcat(remaining[1:dest_idx], to_move, remaining[dest_idx+1:end])
    # Carry out a circle shift to get cur_cup into pos
    idx_diff = pos - findfirst(isequal(cur_cup), n2)
    circshift(n2, idx_diff)
end

function find_dest(v, val, max_val)
    len_v = length(v)
    for dest_val in (mod(val-idx, max_val) for idx in 1:max_val)
        if dest_val == 0
            dest_val = max_val
        end
        idx = findfirst(isequal(dest_val), v)
        if idx !== nothing
            return v[idx], idx
        end
    end
    error("did not find a proper destination with $v and $val")
end

function solve(numbers, n_moves)
    n = copy(numbers)
    max_val = maximum(n)
    for pos in 1:n_moves
        # @show n, pos
        n = iterate(n, pos, max_val)        
    end
    n
end

function part1(numbers, n_moves)
    n = solve(numbers, n_moves)
    idx_1 = findfirst(isequal(1), n)
    len_n = length(n)
    inds_after_1 = [mod(idx_1 + idx, len_n) for idx in 1:len_n-1]
    replace!(inds_after_1, 0=>len_n)
    join(n[inds_after_1])
end

function part2(numbers, n_moves)
    # n = solve(numbers, n_moves)
    # idx_1 = findfirst(isequal(1), n)
    # len_n = length(n)
    # inds_after_1 = [mod(idx_1 + idx, len_n) for idx in 1:2]
    # replace!(inds_after_1, 0=>len_n)
    # prod(inds_after_1)
end

function create_successor_vec(numbers)
    vs = zeros(Int, length(numbers))
    for (v, v_next) in pairwise(numbers)
        vs[v] = v_next
    end
    vs[numbers[end]] = first(numbers)
    vs
end

function pairwise(xs)
    zip(xs, Iterators.drop(xs, 1))
end

# filename = "inputs/day23.txt"
filename = "example_day23.txt"
numbers = [parse(Int, x) for x in readline(filename)]
part1_solution = part1(numbers, 100)

part2_nums = vcat(numbers, (maximum(numbers)+1):1_000_000)
part2_solution = part2(part2_nums, 10_000_000)
