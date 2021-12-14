using Statistics

function input2bin(input::String)
    return split(input, "") .== "1"
end

function bin2dec(input::AbstractArray{Bool})
    str = join(map(string, map(Int64, input)))
    return parse(Int64, str, base=2)
end

function processBitCriteria(input::BitMatrix; invert=false)
    data = copy(input)
    digit = 1
    while size(data, 2) > 1
        value = mean(data[digit,:]) >= 0.5
        if invert
            value = !value
        end
        data = data[:, data[digit,:] .== value]
        digit += 1
    end
    return bin2dec(data)
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
    
    o2 = processBitCriteria(data)
    co2 = processBitCriteria(data, invert=true)

    println(o2 * co2)
end