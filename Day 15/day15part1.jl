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

function distancetransform(map::Matrix{<:Int}, target::CartesianIndex)
    dtrans = Array{Union{Int, Missing}}(undef, size(map))
    fill!(dtrans, missing)
    dtrans[target] = map[target]
    display(dtrans)
    
    while true
        for i in CartesianIndices(dtrans)
            edgesi = getedges(dtrans, i)
            if isempty(edgesi)
                continue
            end

            dtrans[i] = minimum(dtrans[edgesi] .+ map[i])

        end
        display(dtrans)
        println()
    end
end

function part1(map::Matrix{<:Number})
    target = CartesianIndex(size(map)) # bottom-right
    return distancetransform(map, target)
end

println(part1(parseinput(filename)))