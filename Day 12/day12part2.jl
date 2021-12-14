function path(currnode::String, seen::Set{String}, neighbours, dup::Bool)
    if currnode == "end"
        return 1
    end
    if currnode == "start" && length(seen) > 0
        return 0
    end
    if all(islowercase, currnode) && currnode in seen
        if dup
            return 0
        end
        dup = true
    end
    s = copy(seen)
    push!(s, currnode)
    out = 0
    for node in neighbours[currnode]
        out += path(node, s, neighbours, dup)
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

println(path("start", Set{String}(), neighbours, false))