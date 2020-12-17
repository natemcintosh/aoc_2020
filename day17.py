import operator
import itertools


def my_add(a, b):
    """
    Elementwise addition of two equal length iterables
    """
    return tuple(map(operator.add, a, b))


def parse_input(filename: str, n_dims: int) -> set:
    """
    read the input into a set of tuples, where the tuples represent the dimensions
    """
    with open(filename) as fio:
        lines = fio.readlines()

    pts = set(
        (row_idx + 1, col_idx + 1)
        for row_idx, l in enumerate(lines)
        for col_idx, item in enumerate(l)
        if item == "#"
    )

    zs = [0] * (n_dims - 2)
    return set((*s, *zs) for s in pts)


def count_active_neighbors(point: tuple, active_pts: set, dirs):
    """
    how many neighbors in the directions `dirs` are active?
    """
    return len(active_pts.intersection(my_add(point, d) for d in dirs))


def gen_directions(n_dims):
    """
    Create a collection of unit directions in n dimensions
    """
    return set(itertools.product(*itertools.repeat(range(-1, 2), n_dims))).difference(
        [tuple([0] * n_dims)]
    )


def iterate(active_points: set, dirs) -> set:
    """
    Iterate one step
    """
    # Get the active spots that turn inactive
    counted_neighbors_of_active = [
        count_active_neighbors(p, active_points, dirs) for p in active_points
    ]
    active_to_inactive = [
        p
        for (p, cnt) in zip(active_points, counted_neighbors_of_active)
        if (cnt != 2) and (cnt != 3)
    ]

    # Get the inactive neighbors
    bubble_out = set(my_add(p, d) for p in active_points for d in dirs)
    inactive_neighbors_of_active = bubble_out.difference(active_points)
    inactive_to_active = [
        p
        for p in inactive_neighbors_of_active
        if count_active_neighbors(p, active_points, dirs) == 3
    ]

    # Do set operations to remove active->inactive points, and add new inactive->active points
    return active_points.difference(active_to_inactive).union(inactive_to_active)


def solve(active_pts: set, dirs, n_steps: int) -> int:
    """
    Iterate for n_step and return number of active cells
    """
    pts = active_pts.copy()
    for _ in range(n_steps):
        pts = iterate(pts, dirs)
    return len(pts)


if __name__ == "__main__":
    from time import time

    start_time = time()

    filename = "inputs/day17.txt"

    pts_3d = parse_input(filename, 3)
    dirs_3d = gen_directions(3)
    part1_solution = solve(pts_3d, dirs_3d, 6)
    print(f"Part 1 solution = {part1_solution}")

    pts_4d = parse_input(filename, 4)
    dirs_4d = gen_directions(4)
    part2_solution = solve(pts_4d, dirs_4d, 6)
    print(f"Part 2 solution = {part2_solution}")

    run_time = time() - start_time
    print(f"day17 -- {run_time:0.3f}s")

