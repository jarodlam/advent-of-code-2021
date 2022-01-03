filename = "input.txt"

SfNum = Pair{Any, Any}

function parseelement(str::String)
    local a
    x = str[2]
    if x == '['
        a, str = parsepair(str[2:end])
    else
        a = parse(Int, x)
        str = str[3:end]
    end
    return a, str
end

function parsepair(str::String)
    a, str = parseelement(str)
    b, str = parseelement(str)
    str = str[2:end]

    if isempty(str)
        return a => b
    else
        return a => b, str
    end
end

function parseinput(fn::String)
    out = SfNum[]
    open(fn) do file
        for line in eachline(file)
            push!(out, parsepair(line))
        end
    end
    return out
end

function addleft(x, num)
    if isnothing(num)
        return x
    elseif length(x) == 1
        return x + num
    else
        return addleft(x[1], num) => x[2]
    end
end

function addright(x, num)
    if isnothing(num)
        return x
    elseif length(x) == 1
        return x + num
    else
        return x[1] => addright(x[2], num)
    end
end

function explode(x, level=0)
    if length(x) == 1
        return x, false, nothing, nothing
    end
    if level == 4
        return 0, true, x[1], x[2]
    end
    a, b = x
    a, exploded, left, right = explode(a, level + 1)
    if exploded
        return a => addleft(b, right), true, left, nothing
    end
    b, exploded, left, right = explode(b, level + 1)
    if exploded
        return addright(a, left) => b, true, nothing, right
    end
    return x, false, nothing, nothing
end

function split(x)
    if length(x) == 1
        if x >= 10
            return x ÷ 2 => (x ÷ 2) + (x % 2), true
        else
            return x, false
        end
    end
    left, splitted = split(x[1])
    if splitted
        return left => x[2], true
    end
    right, splitted = split(x[2])
    return x[1] => right, splitted
end

function magnitude(x)
    if length(x) == 1
        return x
    end
    a, b = magnitude(x[1]), magnitude(x[2])
    return (a * 3) + (b * 2)
end

function sfadd(a, b)
    x = a => b
    while true
        x, exploded, _, _ = explode(x)
        if !exploded
            x, splitted = split(x)
            if !splitted
                break
            end
        end
    end
    return x
end

function part1(numbers::Vector)
    x = numbers[1]
    for i in 2:length(numbers)
        println("  $x")
        println("+ $(numbers[i])")
        x = sfadd(x, numbers[i])
        println("= $x\n")
    end
    return magnitude(x)
end

function part2(numbers::Vector)
    
end

display(part1(parseinput(filename)))