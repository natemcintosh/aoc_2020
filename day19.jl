function parse_input(filename)
    input = read(filename, String)
    rules_and_messages = split(input, "\n\n")
    rules = split(first(rules_and_messages), "\n")
    messages = split(last(rules_and_messages), "\n")

end

function parse_rule(rule)
    key_and_val = split(rule, ":")
    key = parse(Int, first(key_and_val))
    val = split(last(key_and_val), "|") .|> split .|> x -> replace.(x, "\""=>"")
end

function is_final(rule)
    first(rule)
end

filename = "example_day19.txt"