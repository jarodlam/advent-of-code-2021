function countNumIncreases(file::IOStream)
    prevVal = missing
    count = 0
    for line in eachline(file)
        currVal = parse(Int64, line)
        if ismissing(prevVal)
            prevVal = currVal
            continue
        end
        if currVal > prevVal
            count += 1
        end
        prevVal = currVal
    end
    return count
end

open("input.txt") do file
    count = countNumIncreases(file)
    println(count)
end