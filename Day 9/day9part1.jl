using Images

function islow(hm::AbstractArray{<:Integer}, i::CartesianIndex)
    edges = [
        hm[i + CartesianIndex(1,0)],
        hm[i + CartesianIndex(0,1)],
        hm[i + CartesianIndex(-1,0)],
        hm[i + CartesianIndex(0,-1)]
    ]
    return sum(edges .> hm[i]) == 4
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

total = 0
for i in CartesianIndices(heightmap[1:end-1,1:end-1])
    if islow(heightmap, i)
        global total += heightmap[i] + 1
    end
end

println(total)