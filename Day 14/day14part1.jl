const input = "input.txt"

function parseinput(fn::String)
    template = String("")
    rules = Tuple{String, Char}[]
    
    open(fn) do file
        template = readline(file)
        readline(file)

        for line in eachline(file)
            a, b = split(line, " -> ")
            push!(rules, (a, b[1]))
        end
    end

    return (template, rules)
end

function step(polymer::String, rules)
    j = 1
    while j < length(polymer)
        for rule in rules
            if polymer[j:j+1] == rule[1]
                polymer = polymer[1:j] * rule[2] * polymer[j+1:end]
                j += 1
                break
            end
        end
        j += 1
    end
    return polymer
end

function leastmostcommon(polymer::String)
    data = Dict{Char, Int}()
    for c in polymer
        if haskey(data, c)
            data[c] += 1
        else
            data[c] = 1
        end
    end
    return (findmin(data)[1], findmax(data)[1])
end

function part1(template::String, rules)
    polymer = template
    
    for i = 1:10
        polymer = step(polymer, rules)
    end
    
    lc, mc = leastmostcommon(polymer)
    return mc - lc
end

function part2(template::String, rules)
    polymer = template
    
    for i = 1:40
        println("Step $i...")
        polymer = step(polymer, rules)
    end
    
    lc, mc = leastmostcommon(polymer)
    return mc - lc
end

println(part1(parseinput(input)...))
println(part2(parseinput(input)...))