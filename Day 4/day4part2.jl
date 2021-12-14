mutable struct BingoBoard
    values::Array{Integer}
    marked::BitArray
end
BingoBoard() = BingoBoard([], [])

function addline!(bb::BingoBoard, line::Vector{Int})
    if isempty(bb.values)
        bb.values = transpose(line)
        bb.marked = falses(1, length(line))
    else
        bb.values = [bb.values; transpose(line)]
        bb.marked = [bb.marked; falses(1, length(line))]
    end
end

function parseline(line::String, delimiter::String)
    return map(x -> parse(Int64, x), split(line, delimiter, keepempty=false))
end

function match!(bb::BingoBoard, num::Integer)
    bb.marked[bb.values .== num] .= true
end

function score(bb::BingoBoard)
    if (maximum(sum(bb.marked, dims=1)) < size(bb.marked, 1)) & 
        (maximum(sum(bb.marked, dims=2)) < size(bb.marked, 2))
        return nothing
    end
    return sum(bb.values[.!bb.marked])
end

boards = []
order = []
open("input.txt") do file
    el = eachline(file)

    # Get number order
    orderstr = iterate(el)[1]
    global order = parseline(orderstr, ",")

    # Get bingo boards
    for line in el
        if isempty(line)
            push!(boards, BingoBoard())
            continue
        end
        addline!(boards[end], parseline(line, " "))
    end
end

# Play bingo
lastboard = 0
winningscore = 0
for num in order
    # Mark off the number
    map((x) -> match!(x, num), boards)

    # Check if only one left
    scores = map(score, boards)

    # Check if one board left
    losing = findall(isnothing, scores)
    #println(scores)
    if length(losing) == 1
        global lastboard = losing[1]
    end

    # Check if last board won
    if lastboard != 0
        if !isnothing(scores[lastboard])
            global winningscore = scores[lastboard] * num
            break
        end
    end
end

println(winningscore)