# 2: 1
# 3: 7
# 4: 4
# 5: 2 3 5
# 6: 0 6 9
# 7: 8

CIPHER = Dict(
    "abcefg"  => '0',
    "cf"      => '1',
    "acdeg"   => '2',
    "acdfg"   => '3',
    "bcdf"    => '4',
    "abdfg"   => '5',
    "abdefg"  => '6',
    "acf"     => '7',
    "abcdefg" => '8',
    "abcdfg"  => '9'
)

function clen(combos::Vector{<:AbstractString}, len::Int)
    return String.(combos[length.(combos) .== len])
end

function maskchars(combo::AbstractString, chars::Vector{Char})
    return [c in chars for c = combo]
end

function findpair(combos::Vector{<:AbstractString}, digits::Int, exclude::Vector{Char})
    c = clen(combos, digits)[1]
    idx = findall(.!maskchars(c, exclude))
    return [c[i] for i = idx]
end

"""Return non-present candidate first"""
function notpresent(tosearch::Vector{<:AbstractString}, candidates::Vector{Char})
    for c in tosearch
        if !(candidates[1] in c)
            return candidates[1], candidates[2]
        elseif !(candidates[2] in c)
            return candidates[2], candidates[1]
        end
    end
    error("Both candidates present")
end

function decode(digits::Vector{<:AbstractString}, mapping::Dict{Char, Char})
    numstr = ""
    for d in digits
        original = join(sort([mapping[c] for c = d]))
        numstr *= CIPHER[original]
    end
    return parse(Int, numstr)
end

open("input.txt") do file
    total = 0
    for line in eachline(file)
        # Extract data
        c, o = split(line, " | ")
        c, o = split(c, " "), split(o, " ")

        mapping = Dict{Char, Char}()
        
        # Find pairs and a from unique combos
        cf = first.(split(clen(c, 2)[1], ""))
        mapping['a'] = findpair(c, 3, cf)[1]
        bd = findpair(c, 4, vcat(cf, mapping['a']))
        eg = findpair(c, 7, vcat(cf, mapping['a'], bd))

        # cf: c is not present in one of the 6segs
        # bd: d is not present in one of the 6segs
        # eg: e is not present in two of the 5segs
        mapping['c'], mapping['f'] = notpresent(clen(c, 6), cf)
        mapping['d'], mapping['b'] = notpresent(clen(c, 6), bd)
        mapping['e'], mapping['g'] = notpresent(clen(c, 5), eg)

        # Reverse the mapping to scrambled => original
        mapping = Dict(values(mapping) .=> keys(mapping))
        
        # Decode and add to total
        num = decode(o, mapping)
        total += num
    end
    println(total)
end