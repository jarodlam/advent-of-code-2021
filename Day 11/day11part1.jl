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

flashes = 0
for i = 1:100
    # Stage 1
    octos .+= 1

    # Stage 2
    hasflashed = falses(size(octos))
    while sum(octos .> 9) > 0
        for i = CartesianIndices(octos)
            if octos[i] > 9 && !hasflashed[i]
                flash(octos, i)
                global flashes += 1
                hasflashed[i] = true
            end
        end

        # Stage 3
        octos[hasflashed] .= 0
    end


    println("\n\nAfter step $i:")
    display(octos)
end

println("\n\n")
println(flashes)