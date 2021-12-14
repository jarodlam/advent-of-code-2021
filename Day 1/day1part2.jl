function countNumIncreases(file::IOStream)
    window = Vector{Union{Int,Missing}}(missing, 3)
    prevSum = missing
    count = 0

    for line in eachline(file)

        # Get value of this line
        currVal = parse(Int64, line)

        # Update the sliding window
        window[1] = window[2]
        window[2] = window[3]
        window[3] = currVal

        # Calculate the sum
        currSum = sum(window)
        if ismissing(currSum)
            continue
        end
        if ismissing(prevSum)
            prevSum = currSum
            continue
        end

        # Compare the sum
        if currSum > prevSum
            count += 1
        end
        prevSum = currSum
    end
    return count
end

open("input.txt") do file
    count = countNumIncreases(file)
    println(count)
end