using DataStructures

function parse_input(filename)
    lines = readlines(filename)
    unparsed_rules = [
        line
        for line in Iterators.takewhile(l -> !startswith(l, "your ticket:"), lines)
        if !isempty(line)
    ]
    rules = parse_rule.(unparsed_rules)

    my_ticket_idx = findfirst(l -> startswith(l, "your ticket:"), lines) + 1
    my_ticket = read_ints_from_line(lines[my_ticket_idx])

    nearby_tickets_start = findfirst(l -> startswith(l, "nearby tickets:"), lines) + 1
    nearby_tickets = read_ints_from_line.(lines[nearby_tickets_start:end])

    rules, my_ticket, nearby_tickets
end

function parse_rule(line)
    pattern = r"^.*: (\d+-\d+) or (\d+-\d+)"
    range_parts = match(pattern, line).captures .|> x -> parse.(Int, split(x, "-"))
    ranges = create_range.(range_parts)
    name = first(split(line, ":"))
    (name=name, ranges=ranges)
end

read_ints_from_line(line) = parse.(Int, split(line, ","))

create_range(r) = r[1]:r[2]

function gather_invalid_fields(rules, ticket)
    [t for t in ticket if !any((t in r) for rule in rules for r in rule.ranges)]
end

function column_fits_rule_ranges(rule, col)
    all(any(f in range_i for range_i in rule.ranges) for f in col)
end

function part2(rules, my_ticket, valid_tickets)
    ticket_arr = vcat([reshape(slice, 1, :) for slice in valid_tickets]...)
    rule_col_array = [
        column_fits_rule_ranges(rule, col) for rule in rules, col in eachcol(ticket_arr)
    ]
    solutions = Dict()
    for _ in 1:size(rule_col_array, 1)
        s = sum(rule_col_array, dims=1)
        # Look in the column with sum of 1, and get the location of that one
        col_is_1_idx = s .== 1
        this_col = findfirst(col_is_1_idx[:])
        this_row = findfirst(rule_col_array[:, this_col])
        
        # Add this to the solutions dict
        solutions[rules[this_row].name] = this_col

        # Replace this_row and this_col with 0
        rule_col_array[this_row, :] .= false
        rule_col_array[:, this_col] .= false
    end
    prod(my_ticket[v] for (k, v) in solutions if startswith(k, "departure"))
end

function main()
    filename = "inputs/day16.txt"
    rules, my_ticket, nearby_tickets = parse_input(filename)
    part1_solution = sum(sum(gather_invalid_fields(rules, t)) for t in nearby_tickets)
    
    valid_tickets = [
        ticket
        for ticket in nearby_tickets
        if all(any(t in r for rule in rules for r in rule.ranges) for t in ticket)
    ]
    part2_solution = part2(rules, my_ticket, valid_tickets)
    
    part1_solution, part2_solution
end

@time part1_solution, part2_solution = main()
@show part1_solution
@show part2_solution

