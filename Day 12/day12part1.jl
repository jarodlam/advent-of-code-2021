function path(currnode::String, seen::Set{String}, neighbours)
    if currnode == "end"
        return 1
    end
    if all(islowercase, currnode) && currnode in seen
        return 0
    end
    s = copy(seen)
    push!(s, currnode)
    out = 0
    for node in neighbours[currnode]
        out += path(node, s, neighbours)
    end
    return out
end

neighbours = Dict{String, Set{String}}()
open("input.txt") do file
    global neighbours = Dict{String, Set{String}}()
    for line in eachline(file)
        a, b = split(line, "-")
        for x in (a, b)
            if !haskey(neighbours, x)
                neighbours[x] = Set{String}()
            end
        end
        push!(neighbours[a], b)
        push!(neighbours[b], a)
    end
end

println(path("start", Set{String}(), neighbours))