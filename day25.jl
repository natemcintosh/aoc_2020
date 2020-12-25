loop_step(val, subj_num) = (val * subj_num) % 20201227

function detect_loop_size(subj_num, public_key)
    val = subj_num
    loop_cntr = 1
    while true
        loop_cntr += 1
        val = loop_step(val, subj_num)
        if val == public_key
            return loop_cntr
        end
        if loop_cntr == 100_000_000
            error("100_000_000 iterations")
        end
    end
    error("Should not have left the loop this way")
end

function create_encryption_key(subj_num, loop_size)
    val = subj_num
    for _ in 1:loop_size-1
        val = loop_step(val, subj_num)
    end
    val
end

function part1(key1, key2)
    key1_loop_size = detect_loop_size(7, key1)
    key2_loop_size = detect_loop_size(7, key2)

    encryption_key1 = create_encryption_key(key1, key2_loop_size)
    encryption_key2 = create_encryption_key(key2, key1_loop_size)
    encryption_key1 == encryption_key2 || error("encryption keys do not match")
    encryption_key1
end

function main()
    filename = "inputs/day25.txt"
    public_keys = parse.(Int, readlines(filename))
    part1_solution = part1(public_keys...)
    
    part1_solution
end

@time part1_solution = main()
@show part1_solution
# @show part2_solution

