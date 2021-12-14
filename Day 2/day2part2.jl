using Match

function updatePosition(currPos::Vector{Int64}, instruction::String)
    dirString, distString = split(instruction)
    dist = parse(Int64, distString)
    delta = @match dirString begin
        "forward" => [dist, dist * currPos[3], 0]
        "down"    => [0, 0, dist]
        "up"      => [0, 0, -dist]
    end
    return currPos + delta
end

open("input.txt") do file
    pos = [0, 0, 0]    # horizontal pos, depth, aim
    for line in eachline(file)
        pos = updatePosition(pos, line)
    end
    println(pos)
    println(pos[1] * pos[2])
end