function getneighbours(octos::AbstractArray{<:Number}, i::CartesianIndex)
    neighbouridx = [
        i + CartesianIndex(1, 0),
        i + CartesianIndex(1, 1),
        i + CartesianIndex(0, 1),
        i + CartesianIndex(-1, 1),
        i + CartesianIndex(-1, 0),
        i + CartesianIndex(-1, -1),
        i + CartesianIndex(0, -1),
        i + CartesianIndex(1, -1),
    ]
    filter!(x -> checkbounds(Bool, octos, x), neighbouridx)
    return neighbouridx
end

function flash(octos::AbstractArray{<:Number}, i::CartesianIndex)
    octos[getneighbours(octos, i)] .+= 1
end

octos = zeros(Int8, 0, 10)
open("input.txt") do file
    # Parse into matrix
    for line in eachline(file)
        global octos = vcat(octos, transpose(parse.(Int8, split(line, ""))))
    end
end
display(octos)
println()

steps = 0
while true
    # Stage 1
    global steps += 1
    octos .+= 1

    # Stage 2
    hasflashed = falses(size(octos))
    while sum(octos .> 9) > 0
        for i = CartesianIndices(octos)
            if octos[i] > 9 && !hasflashed[i]
                flash(octos, i)
                hasflashed[i] = true
            end
        end

        # Stage 3
        octos[hasflashed] .= 0
    end

    println("\n\nAfter step $steps:")
    display(octos)

    # Check if synchronised
    if sum(hasflashed) == length(hasflashed)
        break
    end
end

println("\n\n")
println(steps)