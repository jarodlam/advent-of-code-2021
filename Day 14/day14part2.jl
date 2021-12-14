const input = "input.txt"

function parseinput(fn::String)
    template = String("")
    rules = Dict{String, Char}()
    
    open(fn) do file
        template = readline(file)
        readline(file)

        for line in eachline(file)
            a, b = split(line, " -> ")
            push!(rules, a => b[1])
        end
    end

    return (template, rules)
end

function addifhaskey(d, k, v)
    if haskey(d, k)
        d[k] += v
    else
        d[k] = v
    end
end

function part2(template::String, rules)
    pairs = Dict{String, Int64}()
    chars = Dict{Char, Int64}()

    for i = 1:length(template)-1
        addifhaskey(pairs, template[i:i+1], 1) 
    end
    for c in template
        addifhaskey(chars, c, 1)
    end
    
    for i = 1:40
        for (pair, n) in copy(pairs)
            if !haskey(rules, pair)
                continue
            end
            a = pair[1]
            b = pair[2]
            x = rules[pair]
            addifhaskey(pairs, a * b, -n)
            addifhaskey(pairs, a * x, n)
            addifhaskey(pairs, x * b, n)
            addifhaskey(chars, x, n)
        end
    end
    
    return findmax(chars)[1] - findmin(chars)[1]
end

println(part2(parseinput(input)...))