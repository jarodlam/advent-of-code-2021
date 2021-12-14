using Images: padarray, Fill

function edgeindices(i::CartesianIndex)
    return (
        i + CartesianIndex(1,0),
        i + CartesianIndex(0,1),
        i + CartesianIndex(-1,0),
        i + CartesianIndex(0,-1)
    )
end

function islow(hm::AbstractArray{<:Integer}, i::CartesianIndex)
    edges = getindex.(Ref(hm), edgeindices(i))
    return sum(edges .> hm[i]) == 4
end

function basinsize(hm::AbstractArray{<:Integer}, i::CartesianIndex)
    e = []     # Explored node count
    f = [i]    # Frontier nodes, begin at start node
    b = 0      # Basin count

    while length(f) > 0
        node = pop!(f)

        if hm[node] < 9
            b += 1

            # Add neighbours to frontier
            newf = filter(x -> !(x in e) && !(x in f), edgeindices(node))
            push!.(Ref(f), newf)
        end

        # Add to explored list
        push!(e, node)
    end

    return b
end

heightmap = []

open("input.txt") do file
    global heightmap = []

    for line in eachline(file)
        newrow = transpose(parse.(Int8, split(line, "")))
        if isempty(heightmap)
            heightmap = newrow
        else
            heightmap = [heightmap; newrow]
        end
    end
end

# Pad outer edge of array with big numbers
heightmap = padarray(heightmap, Fill(127, (1,1)))

sizes = []

for i in CartesianIndices(heightmap[1:end-1,1:end-1])
    if islow(heightmap, i)
        push!(sizes, basinsize(heightmap, i))
    end
end

sort!(sizes)
println(prod(sizes[end-2:end]))
