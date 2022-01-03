# Algorithm:
# - Compute distances from every beacon to every other beacon in each scanner
# - Find overlapping beacons by matching distances
# - ????

filename = "inputex.txt"

Beacon = Tuple{Int, Int, Int}
Scanner = Vector{Beacon}

function parseinput(fn::String)
    s = Scanner[]
    i = 0
    for line in eachline(fn)
        if isempty(line)
            continue
        end
        if line[1:3] == "---"
            i += 1
            push!(s, Beacon[])
            continue
        end
        m = eachmatch(r"-?\d+", line)
        x = tuple(parse.(Int, getproperty.(m, :match))...)
        push!(s[i], x)
    end
    return s
end

function dist(a::Beacon, b::Beacon)
    if a == b
        return (0, 0, 0)
    end
    return abs.(map(-, a, b))
end

function distmat(x::Scanner)
    n = length(x)
    dm = repeat([(0,0,0)], n, n)
    for i in 1:n
        for j in 1:n
            dm[i,j] = dist(x[i], x[j])
        end
    end
    return dm
end

function correlatebeacons(a::Matrix, b::Matrix)
    m = size(a, 1)
    n = size(b, 1)
    correlations = Dict{Int, Int}()
    for i in 1:m
        for j in 1:n
            x = sum(in.(a[i,:], Ref(b[j,:])))
            if x >= 12
                correlations[i] = j
                break
            end
        end
    end
    println(length(correlations))
    if length(correlations) >= 12
        return correlations
    end
    return nothing
end

function correlatescanners(dms::Vector)
    n = length(dms)
    corrscanners = zeros(Int, n)
    corrbeacons = repeat([Dict{Int,Int}()], n, n)
    for i in 1:n
        for j in 1:n
            if i == j
                continue
            end
            cb = correlatebeacons(dms[i], dms[j])
            if isnothing(cb)
                continue
            end
            corrscanners[i] = j
            corrbeacons[i,j] = cb
        end
    end
    return corrscanners, corrbeacons
end

function part1(x::Vector{Scanner})
    # Distance matrices
    dms = []
    for s in x
        push!(dms, distmat(s))
    end

    # Match scanners
    

end

display(part1(parseinput(filename)))