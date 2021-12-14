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
        return 0
    end
    return sum(bb.values[.!bb.marked])
end

open("input.txt") do file
    el = eachline(file)

    # Get number order
    order = iterate(el)[1]
    order = parseline(order, ",")

    # Get bingo boards
    boards = []
    for line in el
        if isempty(line)
            push!(boards, BingoBoard())
            continue
        end
        addline!(boards[end], parseline(line, " "))
    end

    # Play bingo
    winningscore = 0
    for num in order
        # Mark off the number
        map((x) -> match!(x, num), boards)

        # Check if any of them won
        scores = map(score, boards)
        filter!((x) -> x > 0, scores)
        if !isempty(scores)
            winningscore = scores[1] * num
            break
        end
    end

    println(winningscore)
end