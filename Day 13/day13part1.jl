using OffsetArrays

# Load data
dots = Tuple{Int, Int}[]
folds = Tuple{Char, Int}[]
open("input.txt") do file
    for line in eachline(file)
        if occursin(",", line)
            newdot = tuple(parse.(Int, split(line, ","))...)
            newdot = (newdot[2], newdot[1])
            push!(dots, newdot)
        elseif occursin("fold", line)
            newfold = (line[12], parse(Int, line[14:end]))
            push!(folds, newfold)
        end
    end
end

# Generate initial paper
sizex = maximum([x[2] for x = dots])
sizey = maximum([x[1] for x = dots])
sizex = 1310
paper = OffsetArray(falses(sizey+1, sizex+1), 0:sizey, 0:sizex)
for i in dots
    paper[i...] = true
end
println(size(paper))

# Fold
fold = folds[1]
if fold[1] == 'y'
    mid = fold[2]
    half1 = paper[0:mid-1,:]
    half2 = paper[mid+1:end,:]
    paper = half1 .| reverse(half2, dims=1)
else
    mid = fold[2]
    half1 = paper[:,0:mid-1]
    half2 = paper[:,mid+1:end]
    paper = half1 .| reverse(half2, dims=2)
end

println(sum(paper))