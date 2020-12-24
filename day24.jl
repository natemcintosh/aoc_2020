import Base.+

function +(t1::Tuple{T,T}, t2::Tuple{T,T}) where T
    t1 .+ t2
end

function parse_input(filename)
    lines = readlines(filename)
    flipped_tiles = sum.(parse_directions.(lines))
end

function parse_directions(directions)
    used_last_letter = false
    dirs = Tuple{Int,Int}[]
    for (l1, l2) in pairwise(directions)
        dir = parse_direction(l1, l2, used_last_letter)
        used_last_letter = dir in ((2, 0), (-2, 0), (0, 0)) ? false : true
        push!(dirs, dir)
    end
    if !used_last_letter
        dir = parse_last_letter(directions[end])
        push!(dirs, dir)
    end
    dirs
end

function parse_direction(l1, l2, used_last_letter)
    if used_last_letter
        (0, 0)
    else
        if l1 == 'e'
            (2, 0)
        elseif l1 == 'w'
            (-2, 0)
        elseif (l1 == 's') && (l2 == 'e')
            (1, -1)
        elseif (l1 == 's') && (l2 == 'w')
            (-1, -1)
        elseif (l1 == 'n') && (l2 == 'e')
            (1, 1)
        elseif (l1 == 'n') && (l2 == 'w')
            (-1, 1)
        else
            @warn "didn't do anything with $l1, $l2. This probably breaks the code"
            (0, 0)
        end
    end
end

function parse_last_letter(l)
    if l == 'e'
        (2, 0)
    elseif l == 'w'
        (-2, 0)
    else
        error("Got unexpected direction: $l")
    end
end

function pairwise(xs)
    zip(xs, Iterators.drop(xs, 1))
end

function counter(data::AbstractArray{T}) where T
    c = Dict{T, Int}()
    for d in data
        if haskey(c, d)
            c[d] += 1
        else
            c[d] = 1
        end
    end
    c
end

function part1(flipped_tiles)
    c = counter(flipped_tiles)
    count(isodd, values(c))
end

const adjacent_dirs = ((2,0), (-2,0), (1,-1), (-1,-1), (1,1), (-1,1))

function count_adjacent_black_tiles(pos, black_tiles)
    neighbors = (pos + d for d in adjacent_dirs)
    length(intersect(black_tiles, neighbors))
end

function iterate(black_tiles)
    # Get the black tiles that turn white
    counted_neighbors_of_black_tiles = (count_adjacent_black_tiles(tile, black_tiles) for tile in black_tiles)
    black_to_white = (tile for (tile, cnt) in zip(black_tiles, counted_neighbors_of_black_tiles) if (cnt == 0) || (cnt > 2))

    # Get the white neighbors of black tiles
    bubble_out = (tile + d for tile in black_tiles for d in adjacent_dirs)
    white_neighbors_of_black_tiles = setdiff(bubble_out, black_tiles)
    # Which of those turn to black?
    white_to_black = [tile for tile in white_neighbors_of_black_tiles if count_adjacent_black_tiles(tile, black_tiles) == 2]

    # Do set operations to change black->white and white->black
    union(setdiff(black_tiles, black_to_white), white_to_black)
end

function part2(black_tiles, n_days)
    ts = copy(black_tiles)
    for _ in 1:n_days
        ts = iterate(ts)
    end
    length(ts)
end

function main()
    filename = "inputs/day24.txt"
    flipped_tiles = parse_input(filename)
    part1_solution = part1(flipped_tiles)
    
    black_tiles = Set(t for (t, c) in counter(flipped_tiles) if isodd(c))
    part2_solution = part2(black_tiles, 100)
    
    part1_solution, part2_solution
end

@time part1_solution, part2_solution = main()
@show part1_solution
@show part2_solution
