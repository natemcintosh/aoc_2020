abstract type Rule end

struct Literal <: Rule
    c::Char
end

struct Standard <: Rule
    rules::Vector{Int}
end

function parse_rule_part(text)::Standard
    Standard([parse(Int, x) for x in split(text)])
end

function parse_input(filename)
    input = read(filename, String)
    rules_and_messages = split(input, "\n\n")
    rules = split(first(rules_and_messages), "\n")
    messages = split(last(rules_and_messages), "\n")
    parse_rules(rules), messages
end

function parse_rules(rules)
    Dict(parse(Int, first(x)) => parse_rule(last(x)) for x in split.(rules, ": "))
end

function parse_rule(text)::Vector{Rule}
    if contains(text, "\"")
        return [replace(strip(text), "\"" => "") |> only |> Literal]
    elseif contains(text, "|")
        return [parse_rule_part(t) for t in split(text, " | ")]
    else
        return [parse_rule_part(text)]
    end
end

function rule_matches(c::Literal, rules, phrase, with)
    if c.c == first(phrase)
        # character matched with next rule literal, call matches with one less character and rest of with.
        next_with = copy(with)
        matches(rules, phrase[2:end], next_with)
    else
        # character didn't match with the expanded rule
        return false
    end
end

function rule_matches(expanded::Standard, rules, phrase, with)
    if length(expanded.rules) == length(phrase)
        # if the total expanded rule size is bigger than phrase size, it can't possibly match.
        # there are no empty rules, each rule will match at least one character
        return false
    else
        next_with = vcat(expanded.rules, with)
        matches(rules, phrase, next_with)
    end
end

function matches(rules, phrase, with)::Bool
    phrase_len = length(phrase)
    with_len = length(with)
    if (phrase_len == 0) && (with_len == 0)
        # matches is true only if phrase and with is empty
        return true
    elseif with_len == 0
        # it can't match if phrase is empty and with is not, likewise for the reverse
        return false
    elseif phrase_len == 0
        return false
    end

    rule_to_expand = popfirst!(with)
    possibilities = rules[rule_to_expand]

    for rule in possibilities
        result = rule_matches(rule, rules, phrase, with)
        if result
            return true
        end
    end

    return false
end

function part1(rules, messages)
    start = [0]
    count(m -> matches(rules, m, copy(start)), messages)
end

function part2(rules, messages)
    new_rules = ["8: 42 | 42 8", "11: 42 31 | 42 11 31"]
    parsed_new_rules = merge(rules, parse_rules(new_rules))
    start = [0]
    count(m -> matches(parsed_new_rules, m, copy(start)), messages)
end

function main()
    filename = "inputs/day19.txt"
    rules, messages = parse_input(filename)
    
    part1_solution = part1(rules, messages)
    
    part2_solution = part2(rules, messages)
    
    part1_solution, part2_solution
end

@time part1_solution, part2_solution = main()
@show part1_solution
@show part2_solution

