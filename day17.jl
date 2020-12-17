import Base.+

const threed_directions = setdiff(vec(collect(Iterators.product(-1:1, -1:1, -1:1))), [(0,0,0)])

const fourd_directions = setdiff(vec(collect(Iterators.product(-1:1, -1:1, -1:1, -1:1))), [(0,0,0,0)])

function +(t1::Tuple{T,T,T}, t2::Tuple{T,T,T}) where T <: Number
    t1 .+ t2
end

function +(t1::Tuple{T,T,T,T}, t2::Tuple{T,T,T,T}) where T <: Number
    t1 .+ t2
end

function create_ind_set(filename, n_dims)
    nested = filename |> readlines .|> Iterators.flatten .|> collect

    char_array = vcat([reshape(slice, :, length(slice)) for slice in nested]...)

    zs = zeros(Int, n_dims-2)
    Set((char_array .== '#') |> findall .|> Tuple .|> x -> (first(x), last(x), zs...))
end

function count_active_neighbors(point, active_points, dirs)
    neighbors = (point + d for d in dirs)
    length(intersect(active_points, neighbors))
end

function iterate(active_points, dirs)
    # Get the active spots that turn inactive
    counted_neighbors_of_active = (count_active_neighbors(p, active_points, dirs) for p in active_points)
    active_to_inactive = (p for (p, cnt) in zip(active_points, counted_neighbors_of_active) if (cnt != 2) && (cnt != 3))

    # Get the inactive neighbors
    bubble_out = (p + d for p in active_points for d in dirs)
    inactive_neighbors_of_active = setdiff(bubble_out, active_points)
    inactive_to_active = [p for p in inactive_neighbors_of_active if count_active_neighbors(p, active_points, dirs) == 3]

    # Do set operations to remove active->inactive points, and add new inactive->active points
    union(setdiff(active_points, active_to_inactive), inactive_to_active)
end

function solve(active_points, dirs, n_steps)
    pts = copy(active_points)
    for _ in 1:n_steps
        pts = iterate(pts, dirs)
    end
    length(pts)
end

function main()
    filename = "inputs/day17.txt"
    inds_3d = create_ind_set(filename, 3)
    part1_solution = solve(inds_3d, threed_directions, 6)

    inds_4d = create_ind_set(filename, 4)
    part2_solution = solve(inds_4d, fourd_directions, 6)

    part1_solution, part2_solution
end

@time part1_solution, part2_solution = main()
@show part1_solution
@show part2_solution
