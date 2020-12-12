function main()
    # Script
    answers = read("inputs/day06.txt", String) |> x -> split(x, "\n\n")

    # Part 1
    part1_answers = replace.(answers, "\n"=>"")
    part1_solution = sum(x -> length(unique(x)), part1_answers)

    # Part 2
    part2_answers = split.(answers, "\n")
    part2_solution = sum(x -> length(intersect(x...)), part2_answers)

    (part1_solution, part2_solution)
end

@time (part1_solution, part2_solution) = main()
@show part1_solution
@show part2_solution
