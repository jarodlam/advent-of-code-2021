NUMDAYS = 80

fish = []
open("input.txt") do file
    global fish = parse.(Int8, split(read(file, String), ","))
end
println(fish)

for i in 1:NUMDAYS
    # Decrement fish
    fish .-= 1

    # Birth new fish
    zerofish = view(fish, fish .== -1)
    numzerofish = length(zerofish)
    zerofish .= 6
    global fish = vcat(fish, repeat([8], numzerofish))

    #println(fish)
end

println(length(fish))