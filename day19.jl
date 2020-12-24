import Base.replace

function parse_input(filename)
    input = replace(read(filename, String), "\"" => "")
    rules_and_messages = split(input, "\n\n")
    rules = split(first(rules_and_messages), "\n")
    messages = split(last(rules_and_messages), "\n")
    Dict(parse_rule.(rules)), messages
end

function parse_rule(rule_str)
    key_and_val = split(rule_str, ":")
    # key = parse(Int, first(key_and_val))
    key = first(key_and_val)
    val = key_and_val |> last |> strip
    if length(val) == 1 && isletter(only(val))
        return (key => val)
    else
        # val = split(last(key_and_val), "|") .|> split #.|> x -> parse.(Int, x)
        # if length(val) == 1
        #     val = only(val)
        # end
        return (key => val)
    end
end

isfinal(rule_val::AbstractString) = all(isletter, replace(rule_val, " " => ""))
isfinal(rule_val::Tuple) = all(all(isletter, replace(s, " " => "")) for s in rule_val)

my_length(x::AbstractString) = 1
my_length(x::Any) = length(x)

isflat(items) = all(x -> my_length(x) == 1, items)

function replace()
    
end

# function expand_rule_0(rules)

#     function inner_func(rules::AbstractDict, result_so_far::AbstractString, val)
#         # Check for stopping condition
#         if isfinal(val)
#             return result_so_far * val
#         end

#         # For each item, if it's a number: call inner_func, else add it to result_so_far
#         for c in val
#             if isdigit(c)
#                 result_so_far *= inner_func(rules, result_so_far, rules[string(c)])
#             else
#                 result_so_far *= c
#             end
#         end
#     end
#     inner_func(rules, "", rules["0"])
# end

function build_upward(rules)
    rs = copy(rules)
    # While our collection of rules is larger than length==1
    while length(rs) > 1
        # Find pairs that are final (letters only)
        final_pairs = Dict(k => v for (k, v) in rs if isfinal(v))

        # If any individual value is nested (fails `isflat`), replace it with the product
        for (k, v) in rs
            if !isflat(v)
                rs[k] = vec(collect(Iterators.product(v...)))
            end
        end

        # Replace all spots that have final keys with their values
        new_rs = Dict()
        for (k, v) in rs
            if k in keys(final_pairs)
                continue
            end

            # For each final_pair, replace any final key with its value
            new_val = v
            for kv in final_pairs
                # Need to handle the case where kv is something like
                # "3" => ("a b ", " b a")
                # Which get's converted to "(\"a b \", \" b a\")"
                # Two new methods for `replace()`, one with (str, k=>(v1, v2)), and one with ((str1, str2), k=>(v1, v2))
                new_val = replace(new_val, kv)
            end
            if (new_val != v) && occursin("|", new_val)
                new_val = tuple(split(new_val, "|")...)
            end
            new_rs[k] = new_val


        end
        rs = new_rs

        #   If it's an '|' case, collect the Iterators.product of them
        # Remove all final pairs from `rs`
    end
    rs
end

filename = "example_day19.txt"
rules, messages = parse_input(filename)
build_upward(rules)
