using Statistics

pos = []
open("input.txt") do file
    global pos = parse.(Int, split(read(file, String), ","))
end

sort!(pos)
mid = Int(median(pos))
fuel = sum(abs.(pos .- mid))
println(fuel)