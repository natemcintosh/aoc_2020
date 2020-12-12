using Combinatorics

function test_data_1()
    [1721, 979, 366, 299, 675, 1456]
end

read_input(filename) = filename |> readlines .|> x -> parse(Int, x)

function part1(input_numbers)
    only(x*y for (x, y) in combinations(input_numbers, 2) if x+y == 2020)
end

function part2(input_numbers)
    only(x*y*z for (x, y, z) in combinations(input_numbers, 3) if x+y+z == 2020)
end

function main()
    filename = "inputs/day01.txt"
    input_numbers = read_input(filename)

    part1_solution = part1(input_numbers)

    part2_solution = part2(input_numbers)

    (part1_solution, part2_solution)
end

@time (part1_solution, part2_solution) = main()
@show part1_solution
@show part2_solution