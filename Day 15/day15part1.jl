using Plots

const filename = "inputex.txt"

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
    filter!(x -> !ismissing(map[x]), edgesi)
    return edgesi
end

function cost(a::CartesianIndex, b::CartesianIndex)
    d = (a - b).I
    return sqrt(d[1] ^ 2 + d[2] ^ 2)
end

function insertsorted!(v::Vector, x, costs::Matrix)
    # https://stackoverflow.com/a/25688266
    splice!(v, searchsorted(v, x, by=x->costs[x]), [x])
    return v
end

function astar(m::Matrix{<:Number}, start::CartesianIndex, goal::CartesianIndex)
    parent = Dict{CartesianIndex, CartesianIndex}()    # node => parentnode
    frontier = CartesianIndex[]
    explored = CartesianIndex[]
    g = zeros(Float64, size(m))
    h = zeros(Float64, size(m))
    
    # Initialise start node
    g[start] = 0
    h[start] = cost(start, goal)
    push!(frontier, start)
    #g = Vector{CartesianIndex, Int}(start => 0)
    #h = Dict{CartesianIndex, Int}(start => cost(start, goal))

    while !isempty(frontier)
        node = pop!(frontier)

        println("Expanding node at $(node.I)")

        # Are we there yet?
        if node == goal
            break
        end

        # Check each neighbour
        neighbours = getedges(m, node)
        for nb in neighbours

            # Not in frontier and not explored, so add to frontier
            if !(nb in frontier) && !(nb in explored)
                g[nb] = g[node] + m[nb]
                h[nb] = cost(nb, goal)
                insertsorted!(frontier, nb, g .+ h)
                parent[nb] = node
                println("    Adding node $(nb.I) to frontier. g=$(g[nb]), h=$(h[nb])")
            
            # In frontier, so check if this is a shorter path
            elseif nb in frontier
                gnew = g[node] + m[nb]
                if gnew < g[node]
                    # Reparent node
                    g[node] = gnew
                    parent[nb] = node
                    println("    Reparenting node $(nb.I). g=$(g[nb]), h=$(h[nb])")
                end
            end
        end

        # Node is now explored
        push!(explored, node)
    end

    display(heatmap(g))
    
    # Reconstruct path
    path = CartesianIndex[]
    risk = m[goal]
    n = goal
    while true
        pushfirst!(path, n)
        if n == start
            break
        end
        n = parent[n]
        #println("$risk: $(n.I)")
        risk += m[n]
    end
    return (path, risk)
end

function dijkstra(m::Matrix{<:Number}, start::CartesianIndex, goal::CartesianIndex)
    explored = zeros(size(m))
    
end

function part1(map::Matrix{<:Number})
    start = CartesianIndex(1, 1)
    goal = CartesianIndex(size(map))
    return astar(map, start, goal)
end

println(part1(parseinput(filename)))