function parse_foods(filename)
    foods = readlines(filename)

    pattern = r"\(contains (.+)\)$"
    allergens = match.(pattern, foods) .|> x -> x.captures[1] .|> x -> split(x, ",") .|> strip

    ingredients = split.(foods, "(") .|> first .|> strip .|> split .|> Set
    [(ingredients=ingrdts, allergens=alrgns) for (ingrdts, alrgns) in zip(ingredients, allergens)]
end

function create_possible_allergen_ingredient_pairs(foods)
    allergens = Set(a for food in foods for a in food.allergens)
    Dict(
        allergen => reduce(intersect, (x.ingredients for x in foods if allergen in x.allergens))
        for allergen in allergens
    )
end

function count_not_allergens(foods, allergen_ingredient_pairs)
    poss_allergens = union(values(allergen_ingredient_pairs)...)
    def_not_allergens = union((setdiff(f.ingredients, poss_allergens) for f in foods)...)
    counter = Dict(a => 0 for a in def_not_allergens)
    for f in foods
        for a in keys(counter)
            if a in f.ingredients
                counter[a] += 1
            end
        end
    end
    counter
end

function part2(possible_allergen_ingredient_pairs)
    poss = copy(possible_allergen_ingredient_pairs)
    result = Dict()
    while length(result) != length(possible_allergen_ingredient_pairs)
        # Get pairs with only one option
        good_pairs = Dict(k => only(v) for (k, v) in poss if length(v) == 1)
        # Add this to result
        merge!(result, good_pairs)
        # Remove allergens from poss
        for k in keys(good_pairs)
            delete!(poss, k)
        end
        # Remove ingredients from the others
        for k in keys(poss)
            for i in values(good_pairs)
                setdiff!(poss[k], [i])
            end
        end
    end

    # Return a sorted (by allergen) list of ingredients, comma separated (no spaces)
    sorted_allergens = result |> keys |> collect |> sort
    join([result[k] for k in sorted_allergens], ",")
end

function main()
    filename = "inputs/day21.txt"
    foods = parse_foods(filename)

    possible_allergen_ingredient_pairs = create_possible_allergen_ingredient_pairs(foods)

    part1_solution = count_not_allergens(foods, possible_allergen_ingredient_pairs) |> values |> sum

    part2_solution = part2(possible_allergen_ingredient_pairs)

    part1_solution, part2_solution
end


@time part1_solution, part2_solution = main()
@show part1_solution
@show part2_solution
