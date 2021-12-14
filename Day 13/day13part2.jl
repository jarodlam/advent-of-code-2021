using OffsetArrays

# Load data
dots = Tuple{Int, Int}[]
folds = Tuple{Char, Int}[]
open("input.txt") do file
    for line in eachline(file)
        if occursin(",", line)
            newdot = tuple(parse.(Int, split(line, ","))...)
            newdot = (newdot[2]+1, newdot[1]+1)
            push!(dots, newdot)
        elseif occursin("fold", line)
            newfold = (line[12], parse(Int, line[14:end])+1)
            push!(folds, newfold)
        end
    end
end

# Generate initial paper
sizex = maximum([x[2] for x = dots])
sizey = maximum([x[1] for x = dots])
# i give up
sizex = 1311    
sizey = 895
paper = falses(sizey, sizex)
for i in dots
    paper[i...] = true
end

# Fold
for fold in folds
    if fold[1] == 'y'
        mid = fold[2]
        half1 = paper[1:mid-1,:]
        half2 = paper[mid+1:end,:]
        global paper = half1 .| reverse(half2, dims=1)
    else
        mid = fold[2]
        half1 = paper[:,1:mid-1]
        half2 = paper[:,mid+1:end]
        global paper = half1 .| reverse(half2, dims=2)
    end
end

display(paper)
paperdisp = fill(' ', size(paper)...)
paperdisp[paper] .= 'O'
println()
display(paperdisp)