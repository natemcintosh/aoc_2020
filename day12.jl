import Base.*

function parse_line(line)
    (instruction=first(line), argument=parse(Int, line[2:end]))
end

function interpret_part1(ship_pos, instruction, argument, ship_bearing)
    if instruction == 'F'
        new_ship_pos = (
            x = ship_pos.x + (argument * sind(ship_bearing)),
            y = ship_pos.y + (argument * cosd(ship_bearing)),
        )
        return (new_ship_pos, ship_bearing)
    elseif instruction == 'R'
        new_ship_bearing = mod(ship_bearing + argument, 360)
        return (ship_pos, new_ship_bearing)
    elseif instruction == 'L'
        new_ship_bearing = mod(ship_bearing - argument, 360)
        return (ship_pos, new_ship_bearing)
    elseif instruction == 'N'
        new_ship_pos = (x = ship_pos.x, y = ship_pos.y + argument)
        return (new_ship_pos, ship_bearing)
    elseif instruction == 'S'
        new_ship_pos = (x = ship_pos.x, y = ship_pos.y - argument)
        return (new_ship_pos, ship_bearing)
    elseif instruction == 'E'
        new_ship_pos = (x = ship_pos.x + argument, y = ship_pos.y)
        return (new_ship_pos, ship_bearing)
    elseif instruction == 'W'
        new_ship_pos = (x = ship_pos.x - argument, y = ship_pos.y)
        return (new_ship_pos, ship_bearing)
    else
        error("Could not interpret instruction $instruction with arg $argument")
    end
end

function part1(code)
    ship_pos = (x=0.0, y=0.0)
    ship_bearing = 90.0
    for c in code
        (ship_pos, ship_bearing) = interpret_part1(
            ship_pos, c.instruction, c.argument, ship_bearing
        )
    end
    abs(ship_pos.x) + abs(ship_pos.y)
end

function *(M::AbstractArray, p::NamedTuple{(:x, :y)})
    p2 = M * [p.x; p.y]
    (x=p2[1], y=p2[2])
end

R(θ) = [cosd(θ) -sind(θ); sind(θ) cosd(θ)]

function interpret_part2(ship_pos, waypoint_pos, instruction, argument)
    if instruction == 'F'
        new_ship_pos = (
            x = ship_pos.x + argument*waypoint_pos.x,
            y = ship_pos.y + argument*waypoint_pos.y,
        )
        return (new_ship_pos, waypoint_pos)
    elseif instruction == 'R'
        new_waypoint_pos = R(-argument) * waypoint_pos
        return (ship_pos, new_waypoint_pos)
    elseif instruction == 'L'
        new_waypoint_pos = R(argument) * waypoint_pos
        return (ship_pos, new_waypoint_pos)
    elseif instruction == 'N'
        new_waypoint_pos = (x = waypoint_pos.x, y = waypoint_pos.y + argument)
        return (ship_pos, new_waypoint_pos)
    elseif instruction == 'S'
        new_waypoint_pos = (x = waypoint_pos.x, y = waypoint_pos.y - argument)
        return (ship_pos, new_waypoint_pos)
    elseif instruction == 'E'
        new_waypoint_pos = (x = waypoint_pos.x + argument, y = waypoint_pos.y)
        return (ship_pos, new_waypoint_pos)
    elseif instruction == 'W'
        new_waypoint_pos = (x = waypoint_pos.x - argument, y = waypoint_pos.y)
        return (ship_pos, new_waypoint_pos)
    else
        error("Could not interpret instruction $instruction with arg $argument")
    end
end

function part2(code)
    ship_pos = (x=0.0, y=0.0)
    waypoint_pos = (x=10.0, y=1.0)
    for c in code
        (ship_pos, waypoint_pos) = interpret_part2(
            ship_pos, waypoint_pos, c.instruction, c.argument
        )
    end
    abs(ship_pos.x) + abs(ship_pos.y)
end

function main()
    filename = "inputs/day12.txt"
    code = filename |> readlines .|> parse_line
    part1_solution = part1(code)

    part2_solution = part2(code)
    (part1_solution, part2_solution)
end

@time (part1_solution, part2_solution) = main()
@show part1_solution
@show part2_solution
