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
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137
    )
    return lut[c]
end

open("input.txt") do file
    score = 0
    for line in eachline(file)
        stack = Char[]
        for c in line
            if isopenbrace(c)
                push!(stack, c)
            else
                x = pop!(stack)
                y = matchingbrace(x)
                if c != y
                    # Corrupted line
                    print("`$line` - Expected `$y`, but found `$c` instead.\n")
                    score += bracescore(c)
                end
            end
        end
    end
    println(score)
end