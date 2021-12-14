using OffsetArrays

NUMDAYS = 256

ages = OffsetVector(zeros(Int, 10), -1:8)
open("input.txt") do file
    fish = parse.(Int8, split(read(file, String), ","))
    for i in 0:8
        ages[i] = length(fish[fish .== i])
    end
end
println(ages)

for i in 1:NUMDAYS
    # Decrement fish
    for i in -1:7
        ages[i] = ages[i+1]
    end
    ages[8] = 0

    # Birth new fish
    ages[6] += ages[-1]
    ages[8] += ages[-1]
    ages[-1] = 0
end

println(sum(ages))