function parse_answers(filename)
    read(filename, String) |> x -> split(x, "\n\n")
end

@time begin
    # Script
    filename = "inputs/day6.txt"
    answers = parse_answers(filename)

    # Part 1
    part1_answers = replace.(answers, "\n"=>"")
    part1_solution = sum(x -> length(unique(x)), part1_answers)
    @show part1_solution

    # Part 2
    part2_answers = split.(answers, "\n")
    part2_solution = sum(x -> length(intersect(x...)), part2_answers)
    @show part2_solution
end