import heapq

# Heuristic: Manhattan Distance
def manhattan(curr_state, goal_state):
    total = 0
    # loop for each tile except the blank (0)
    for tile in range(1, 9):
        # find tile position in current state
        for i in range(3):
            for j in range(3):
                if curr_state[i][j] == tile:
                    curr_x, curr_y = i, j
        # find tile position in goal state
        for i in range(3):
            for j in range(3):
                if goal_state[i][j] == tile:
                    goal_x, goal_y = i, j
        # add manhattan distance
        total += abs(curr_x - goal_x) + abs(curr_y - goal_y)
    return total

# get next possible states
def get_neighbors(state):
    neighbors = []
    # find blank space
    for i in range(3):
        for j in range(3):
            if state[i][j] == 0:
                blank_x, blank_y = i, j
    moves = [(-1,0),(1,0),(0,-1),(0,1)] # up, down, left, right
    for dx, dy in moves:
        new_x, new_y = blank_x + dx, blank_y + dy
        if 0 <= new_x < 3 and 0 <= new_y < 3:
            new_state = [row[:] for row in state]
            # swap blank with neighbor
            new_state[blank_x][blank_y], new_state[new_x][new_y] = new_state[new_x][new_y], new_state[blank_x][blank_y]
            neighbors.append(new_state)
    return neighbors

# reconstruct path from parents dictionary
def reconstruct_path(parents, state):
    path = []
    while state:
        path.append(state)
        state = parents.get(tuple(map(tuple, state)))
    path.reverse()
    return path

# A* algorithm
def astar(start, goal):
    pq = []
    g = 0
    h = manhattan(start, goal)
    heapq.heappush(pq, (g + h, g, start, None))
    
    visited = set()
    parents = {}
    
    while pq:
        f, g, state, parent = heapq.heappop(pq)
        state_tuple = tuple(map(tuple, state))
        
        if state_tuple in visited:
            continue
        visited.add(state_tuple)
        parents[state_tuple] = parent
        
        if state == goal:
            return reconstruct_path(parents, state)
        
        for neighbor in get_neighbors(state):
            n_tuple = tuple(map(tuple, neighbor))
            if n_tuple not in visited:
                g_new = g + 1
                h_new = manhattan(neighbor, goal)
                heapq.heappush(pq, (g_new + h_new, g_new, neighbor, state))

# Example run
start_state = [[1, 2, 3],
               [4, 0, 6],
               [7, 5, 8]]

goal_state = [[1, 2, 3],
              [4, 5, 6],
              [7, 8, 0]]

solution_path = astar(start_state, goal_state)

print("Solution steps:")
for step in solution_path:
    for row in step:
        print(row)
    print()
