using Statistics

function isopenbrace(c::Char)
    return c in ['(', '[', '{', '<']
end

function matchingbrace(c::Char)
    lut = Dict{Char, Char}(
        '(' => ')',
        ')' => '(',
        '[' => ']',
        ']' => '[',
        '{' => '}',
        '}' => '{',
        '<' => '>',
        '>' => '<'
    )
    return lut[c]
end

function bracescore(c::Char)
    lut = Dict{Char, Int}(
        ')' => 1,
        ']' => 2,
        '}' => 3,
        '>' => 4
    )
    return lut[c]
end

function linescore(line::String)
    stack = Char[]
    for c in line
        if isopenbrace(c)
            push!(stack, c)
        else
            x = pop!(stack)
            y = matchingbrace(x)
            if c != y
                # Discard corrupted line
                return
            end
        end
    end

    # Complete line
    score = 0
    while length(stack) > 0
        c = pop!(stack)
        score = score * 5 + bracescore(matchingbrace(c))
    end
    return score
end

open("input.txt") do file
    scores = Int[]
    for line in eachline(file)
        score = linescore(line)
        if !isnothing(score)
            push!(scores, score)
        end
    end
    println(scores)
    println(Int(median(scores)))
end