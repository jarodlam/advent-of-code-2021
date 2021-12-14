using Statistics

function input2bin(input::String)
    return split(input, "") .== "1"
end

function bin2dec(input::AbstractArray{Bool})
    str = join(map(string, map(Int64, input)))
    return parse(Int64, str, base=2)
end

open("input.txt") do file
    data = missing
    for line in eachline(file)
        if ismissing(data)
            data = input2bin(line)
        else
            data = [data input2bin(line)]
        end
    end
    avg = mean(data, dims=2)
    gamma = bin2dec(avg .> 0.5)
    epsilon = bin2dec(avg .< 0.5)
    println(gamma)
    println(epsilon)
    println(gamma * epsilon)
end