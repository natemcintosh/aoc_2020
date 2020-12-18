function perf_op(op::Char, left::Int, right::Int)::Int
    if op == '+'
        left + right
    elseif op == '*'
        left * right
    else
        error("Found an operator ($op) that is not + or *")
    end
end

isop(c) = (c == '+') || (c == '*')

function infix_2_postfix(expr::String; with_precedence = false)
    e = replace(expr, " " => "")
    post = []
    op_stack = Char[]
    for c in e
        if isdigit(c)
            push!(post, parse(Int, c))
        elseif isop(c)
            while !isempty(op_stack) && op_stack[end] != '('
                if with_precedence && (c == '+') && (op_stack[end] == '*')
                    break
                end
                push!(post, pop!(op_stack))
            end
            push!(op_stack, c)
        elseif c == '('
            push!(op_stack, c)
        elseif c == ')'
            op = pop!(op_stack)
            while !isempty(op_stack) & (op != '(')
                push!(post, op)
                op = pop!(op_stack)
            end
        else
            error("Unexpected character $c")
        end
    end

    while !isempty(op_stack)
        push!(post, pop!(op_stack))
    end
    post
end

function eval_postfix(postfix)
    eval_stack = []
    for c in postfix
        if c isa Int
            push!(eval_stack, c)
        elseif isop(c)
            push!(eval_stack, perf_op(c, pop!(eval_stack), pop!(eval_stack)))
        else
            error("Error in parsing postfix. Found unexpected $c")
        end
    end
    length(eval_stack) == 1 || error("Did not reduce postfix: $eval_stack")
    first(eval_stack)
end

function main()
    filename = "inputs/day18.txt"
    part1_solution = filename |> readlines .|> infix_2_postfix .|> eval_postfix |> sum

    part2_infixes = filename |> readlines .|> x -> infix_2_postfix(x; with_precedence=true)
    part2_solution = sum(eval_postfix, part2_infixes)

    part1_solution, part2_solution
end

@time part1_solution, part2_solution = main()
@show part1_solution
@show part2_solution
