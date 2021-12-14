using Plots

function parsecoords(input::String)
    p1, p2 = split(input, " -> ")
    x1, y1 = parse.(Int, split(p1, ","))
    x2, y2 = parse.(Int, split(p2, ","))
    return x1, y1, x2, y2
end

function addline!(field::Array{Int}, x1, y1, x2, y2)
    # Generate ranges
    xrange = min(x1, x2):max(x1, x2)
    yrange = min(y1, y2):max(y1, y2)
    if x1 > x2
        xrange = reverse(xrange)
    end
    if y1 > y2
        yrange = reverse(yrange)
    end

    # Vertical line
    if x1 == x2
        field[yrange,x1] .+= 1
    
    # Horizontal line
    elseif y1 == y2
        field[y1,xrange] .+= 1
    
    # Diagonal line
    else
        for (x, y) in zip(xrange, yrange)
            field[y,x] += 1
        end
    end
end

field = zeros(Int, 1000, 1000)
open("input.txt") do file
    for line in eachline(file)
        x1, y1, x2, y2 = parsecoords(line)
        addline!(field, x1, y1, x2, y2)
    end
end

num = length(field[field .> 1])
println(num)
heatmap(field)