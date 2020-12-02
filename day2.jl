
function pswd_is_valid_part_1(input_data)
    pattern = r"^(\d+)\-(\d+)\s(\w):\s(\w+)"
    m = match(pattern, input_data)
    if m === nothing
        error("Was not able to correctly parse the password")
    end

    # Get the maximum and minimum numbers, and create functions that compare numbers to
    # those numbers
    min_num = parse(Int, m.captures[1])
    max_num = parse(Int, m.captures[2])

    # Get the letter in question
    letter = m.captures[3]

    # Get the password
    pswd = m.captures[4]

    # Count the number of instances of said letter
    num_instances = count(letter, pswd)

    # Is it within the bounds?
    (min_num <= num_instances) & (num_instances <= max_num)
end


function pswd_is_valid_part_2(input_data)
    pattern = r"^(\d+)\-(\d+)\s(\w):\s(\w+)"
    m = match(pattern, input_data)
    if m === nothing
        error("Was not able to correctly parse the password")
    end

    # Get the first and last indices to check (it uses 1 based indexing)
    first_num = parse(Int, m.captures[1])
    last_num = parse(Int, m.captures[2])

    # Get the character in question
    character = only(m.captures[3])

    # Get the password
    pswd = m.captures[4]

    # Check for matches
    at_first_index = pswd[first_num] == character
    at_last_index = pswd[last_num] == character

    # Make sure only one matches
    at_first_index + at_last_index == 1
end


# Script
filename = "inputs/day2.txt"
input_data = readlines(filename)

part1_solution = count(pswd_is_valid_part_1, input_data)
@show part1_solution

part2_solution = count(pswd_is_valid_part_2, input_data)
@show part2_solution