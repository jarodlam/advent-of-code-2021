using DataStructures

const filename = "input.txt"

function parseinput(fn::String)
    map = Int[]
    open(fn) do file
        for line in eachline(file)
            newrow = parse.(Int, split(line, ""))
            if isempty(map)
                map = transpose(newrow)
            else
                map = vcat(map, transpose(newrow))
            end
        end
    end
    return map
end

function getedges(map, i::CartesianIndex)
    edgesi = [
        i + CartesianIndex(1, 0)
        i + CartesianIndex(-1, 0)
        i + CartesianIndex(0, 1)
        i + CartesianIndex(0, -1)
    ]
    filter!(x -> checkbounds(Bool, map, x.I...), edgesi)
    return edgesi
end

function cost(a::CartesianIndex, b::CartesianIndex)
    d = (a - b).I
    #return sqrt(d[1] ^ 2 + d[2] ^ 2)
    return sum(d)
end

function astar(m::Matrix{<:Number}, start::CartesianIndex, goal::CartesianIndex)
    parent = Dict{CartesianIndex, CartesianIndex}()    # node => parentnode
    frontier = PriorityQueue{CartesianIndex, Float64}()
    explored = Set{CartesianIndex}()
    g = Dict{CartesianIndex, Float64}()
    h = Dict{CartesianIndex, Float64}()
    
    # Initialise start node
    g[start] = 0
    h[start] = cost(start, goal)
    enqueue!(frontier, start, g[start] + h[start])

    while !isempty(frontier)
        node = dequeue!(frontier)

        #println("Expanding node at $(node.I). risk=$(m[node])")

        # Are we there yet?
        if node == goal
            break
        end

        # Check each neighbour
        neighbours = getedges(m, node)
        for nb in neighbours

            # Not in frontier and not explored, so add to frontier
            if !(nb in keys(frontier)) && !(nb in explored)
                g[nb] = g[node] + m[nb]
                h[nb] = cost(nb, goal)
                enqueue!(frontier, nb, g[nb] + h[nb])
                parent[nb] = node
                #println("    Adding node $(nb.I) to frontier. g=$(g[nb]), h=$(h[nb])")
            
            # In frontier, so check if this is a shorter path
            elseif nb in keys(frontier)
                gnew = g[node] + m[nb]
                if gnew < g[node]
                    # Reparent node
                    g[node] = gnew
                    parent[nb] = node
                    frontier[nb] = g[nb] + h[nb]
                    #println("    Reparenting node $(nb.I). g=$(g[nb]), h=$(h[nb])")
                end
            end
        end

        # Node is now explored
        push!(explored, node)

        # Progress bar
        progress = round(length(explored) / length(m) * 100, digits=1)
        print("$progress%\r")
    end
    println()
    
    return Int(g[goal])
end

function part1(map::Matrix{<:Number})
    start = CartesianIndex(1, 1)
    goal = CartesianIndex(size(map))
    return astar(map, start, goal)
end

function part2(map::Matrix{<:Number})
    map2 = repeat(map, 5, 5)
    offset = [
        0 1 2 3 4;
        1 2 3 4 5;
        2 3 4 5 6;
        3 4 5 6 7;
        4 5 6 7 8
    ]
    map2 += repeat(offset, inner=size(map))
    map2 .%= 9
    map2[map2 .== 0] .= 9

    start = CartesianIndex(1, 1)
    goal = CartesianIndex(size(map2))
    return astar(map2, start, goal)
    #return solve(map2)
end

println(part1(parseinput(filename)))
println(part2(parseinput(filename)))