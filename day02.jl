function parse_input_line(line)
    pattern = r"^(\d+)\-(\d+)\s(\w):\s(\w+)"
    m = match(pattern, line)
    if m === nothing
        error("Was not able to correctly parse the password")
    end

    # Get the first and last numbers
    first_num = parse(Int, m.captures[1])
    last_num = parse(Int, m.captures[2])

    # Get the letter in question
    letter = m.captures[3]

    # Get the password
    pswd = m.captures[4]

    return (first_num, last_num, letter, pswd)
end


function pswd_is_valid_part_1(input_data)
    min_num, max_num, letter, pswd = parse_input_line(input_data)

    # Count the number of instances of said letter
    num_instances = count(letter, pswd)

    # Is it within the bounds?
    (min_num <= num_instances) & (num_instances <= max_num)
end


function pswd_is_valid_part_2(input_data)
    first_num, last_num, letter, pswd = parse_input_line(input_data)

    # Convert the letter from a string to a character
    character = only(letter)

    # Check for matches
    at_first_index = pswd[first_num] == character
    at_last_index = pswd[last_num] == character

    # Make sure only one matches
    at_first_index + at_last_index == 1
end


# Script
@time begin
    filename = "inputs/day02.txt"
    input_data = readlines(filename)

    part1_solution = count(pswd_is_valid_part_1, input_data)
    @show part1_solution

    part2_solution = count(pswd_is_valid_part_2, input_data)
    @show part2_solution
end