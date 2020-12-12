function parse_bag_rule_part1(bag_rule)
    bigger_and_smaller = split(bag_rule, " bags contain ")
    bigger = first(bigger_and_smaller)

    smaller_bags = split(last(bigger_and_smaller), ",")
    small_bag_pattern = r"(\d) (\w+ \w+) bags?"
    ms = match.(small_bag_pattern, smaller_bags)

    Dict(last(m.captures) => Set([bigger]) for m in ms if m !== nothing)
end


function build_inverted_map(all_bags_separate)
    all_bags = Dict(
        i_bag => Set() for i_bag in Iterators.flatten(keys.(all_bags_separate))
    )
    for b_dict in all_bags_separate
        for (b, contained_in) in pairs(b_dict)
            union!(all_bags[b], contained_in)
        end
    end
    all_bags
end


function count_bags(bag, all_bags)
    t = Set(bag)
    for b in bag
        if b in keys(all_bags)
            union!(t, count_bags(all_bags[b], all_bags))
        end
    end
    t
end


function parse_bag_rule_part2(bag_rule)
    bigger_and_smaller = split(bag_rule, " bags contain ")
    bigger = first(bigger_and_smaller)

    smaller_bags = split(last(bigger_and_smaller), ",")
    small_bag_pattern = r"(\d) (\w+ \w+) bags?"
    ms = match.(small_bag_pattern, smaller_bags)

    bigger => [(parse(Int, first(m.captures)), last(m.captures)) for m in ms if m !== nothing]
end


function count_inner_bags(bag_key, bags)
    bag_count = 0
    for (n_bags, bag) in bags[bag_key]
        if isempty(bags[bag])
            new_bags = n_bags
        else
            new_bags = n_bags + n_bags * count_inner_bags(bag, bags)
        end
        bag_count += new_bags
    end
    bag_count
end


function main()
    # Script
    filename = "inputs/day07.txt"
    bag_rules_str = readlines(filename)

    # Part 1
    all_bags_separate = parse_bag_rule_part1.(bag_rules_str)
    all_bags = build_inverted_map(all_bags_separate)
    part1_solution = length(count_bags(all_bags["shiny gold"], all_bags))

    # Part 2
    all_bags_forward = Dict(parse_bag_rule_part2.(bag_rules_str))
    part2_solution = count_inner_bags("shiny gold", all_bags_forward)

    (part1_solution, part2_solution)
end

@time (part1_solution, part2_solution) = main()
@show part1_solution
@show part2_solution
