using Statistics

function cost(n::Int)
    return Int(abs(n) * (abs(n) + 1) / 2)
end

pos = []
# open("input.txt") do file
#     global pos = parse.(Int, split(read(file, String), ","))
# end

sort!(pos)
fuel = minimum([sum(cost.(pos .- mid)) for mid = pos])
println(fuel)