function parse_passports(filename)
    passport_strings = read(filename, String) |>
        x -> split(x, "\n\n") .|>
        x -> replace(x, "\n"=>" ")

    create_passport_dict.(passport_strings)
end

function create_passport_dict(passport_string)
    attributes = split(passport_string) .|> x -> split(x, ":")
    Dict(first(a)=>last(a) for a in attributes)
end

function passport_is_valid_part1(passport, necessary_keys)::Bool
    issubset(necessary_keys, keys(passport))
end

function passport_is_valid_part2(passport, necessary_keys, field_rules)::Bool
    issubset(necessary_keys, keys(passport)) &&
        mapreduce(rule -> rule(passport) , &, field_rules)
end

function byr(passport)::Bool
    year_str = passport["byr"]
    year = parse(Int, year_str)
    (1920 <= year <= 2002) && (length(year_str) == 4)
end

function iyr(passport)::Bool
    year_str = passport["iyr"]
    year = parse(Int, year_str)
    2010 <= year <= 2020 && (length(year_str) == 4)
end

function eyr(passport)::Bool
    year_str = passport["eyr"]
    year = parse(Int, year_str)
    2020 <= year <= 2030 && (length(year_str) == 4)
end

function hgt(passport)::Bool
    height_str = passport["hgt"]
    if contains(height_str, "cm")
        height = parse(Int, replace(height_str, "cm"=>""))
        150 <= height <= 193
    elseif contains(height_str, "in")
        height = parse(Int, replace(height_str, "in"=>""))
        59 <= height <= 76
    else
        false
    end
end

function hcl(passport)::Bool
    hair_color = passport["hcl"]
    (head, tail) = Iterators.peel(hair_color)
    tail = collect(tail)
    tail_items = tail |> Iterators.flatten |> Set
    desired_tail_items = Set(['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'])
    (head == '#') && (length(tail) == 6) && issubset(tail_items, desired_tail_items)
end

function ecl(passport)::Bool
    eyecolor = passport["ecl"]
    valid_colors = Set(["amb","blu","brn","gry","grn","hzl","oth"])
    eyecolor in valid_colors
end

function pid(passport)::Bool
    passport_id = passport["pid"]
    (length(passport_id) == 9) && all(isnumeric, passport_id)
end


function main()
    # Script
    filename = "inputs/day04.txt"
    passports = parse_passports(filename)

    # Part 1
    necessary_keys = Set(["byr","iyr","eyr","hgt","hcl","ecl","pid"])
    part1_solution = count(x -> passport_is_valid_part1(x, necessary_keys), passports)

    # Part 2
    field_rules = [byr, iyr, eyr, hgt, hcl, ecl, pid]
    part2_solution = count(x -> passport_is_valid_part2(x, necessary_keys, field_rules), passports)

    (part1_solution, part2_solution)
end

@time (part1_solution, part2_solution) = main()
@show part1_solution
@show part2_solution
