using Match

function updatePosition(currPos::Vector{Int64}, instruction::String)
    dirString, distString = split(instruction)
    dir = @match dirString begin
        "forward" => [1, 0]
        "down"    => [0, 1]
        "up"      => [0, -1]
    end
    dist = parse(Int64, distString)
    return currPos + (dir * dist)
end

open("input.txt") do file
    pos = [0, 0]
    for line in eachline(file)
        pos = updatePosition(pos, line)
    end
    println(pos)
    println(prod(pos))
end