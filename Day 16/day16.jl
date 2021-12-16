filename = "input.txt"

abstract type Packet end
abstract type OperatorPacket <: Packet end

struct LiteralPacket <: Packet
    version::Int
    literalvalue::Int
end

struct SumPacket <: OperatorPacket
    version::Int
    subpackets::Vector{Packet}
end

struct ProductPacket <: OperatorPacket
    version::Int
    subpackets::Vector{Packet}
end

struct MinimumPacket <: OperatorPacket
    version::Int
    subpackets::Vector{Packet}
end

struct MaximumPacket <: OperatorPacket
    version::Int
    subpackets::Vector{Packet}
end

struct GreaterThanPacket <: OperatorPacket
    version::Int
    subpackets::Vector{Packet}
end

struct LessThanPacket <: OperatorPacket
    version::Int
    subpackets::Vector{Packet}
end

struct EqualToPacket <: OperatorPacket
    version::Int
    subpackets::Vector{Packet}
end

function OperatorPacket(version::Int, typeid::Int, subpackets::Vector{Packet})
    if typeid == 0 return SumPacket(version, subpackets)
    elseif typeid == 1 return ProductPacket(version, subpackets)
    elseif typeid == 2 return MinimumPacket(version, subpackets)
    elseif typeid == 3 return MaximumPacket(version, subpackets)
    elseif typeid == 5 return GreaterThanPacket(version, subpackets)
    elseif typeid == 6 return LessThanPacket(version, subpackets)
    elseif typeid == 7 return EqualToPacket(version, subpackets)
    else error("Invalid type ID $typeid")
    end
end

function bin2dec(a::BitVector)
    return parse(Int, string(Int.(a)...), base=2)
end

function parseinput(fn::String)
    out = BitVector()
    open(fn) do file
        for c in read(file, String)
            bits = reverse(BitVector(digits(parse(Int, c, base=16), base=2, pad=4)))
            out = vcat(out, bits)
        end
    end
    return out
end

function parsepacket(b::BitVector)
    typeid = b[4:6]
    if bin2dec(typeid) == 4
        # Literal packet
        return parsepacket(b, LiteralPacket)
    else
        # Operator packet
        lengthid = b[7]
        return parsepacket(b, OperatorPacket, lengthid)
    end
end

function parsepacket(b::BitVector, type::Type{LiteralPacket})
    valbytes = BitVector()    
    i = 7
    while true
        valbytes = vcat(valbytes, b[i+1:i+4])
        if b[i] == 0
            i += 5
            break
        end
        i += 5
    end
    packet = LiteralPacket(
        bin2dec(b[1:3]),
        bin2dec(valbytes)
    )
    remainder = b[i:end]
    return packet, remainder
end

function parsepacket(b::BitVector, type::Type{OperatorPacket}, lengthid::Bool)
    remainder = BitVector()
    subpackets = Packet[]

    if lengthid == 0
        len = bin2dec(b[8:22])
        bsub = b[23:23+len-1]
        if length(b) > 23+len-1
            remainder = b[23+len:end]
        end
        while true
            newpacket, bsub = parsepacket(bsub)
            push!(subpackets, newpacket)
            if sum(bsub) == 0
                break
            end
        end
    
    else
        num = bin2dec(b[8:18])
        bsub = b[19:end]
        for i = 1:num
            newpacket, bsub = parsepacket(bsub)
            push!(subpackets, newpacket)
        end
        remainder = bsub
    end

    packet = OperatorPacket(
        bin2dec(b[1:3]),
        bin2dec(b[4:6]),
        subpackets
    )
    return packet, remainder
end

versionsum(p::LiteralPacket)  = p.version
versionsum(p::OperatorPacket) = sum(versionsum.(p.subpackets)) + p.version

packetop(p::SumPacket)         = sum(packetop.(p.subpackets))
packetop(p::ProductPacket)     = prod(packetop.(p.subpackets))
packetop(p::MinimumPacket)     = minimum(packetop.(p.subpackets))
packetop(p::MaximumPacket)     = maximum(packetop.(p.subpackets))
packetop(p::LiteralPacket)     = p.literalvalue
packetop(p::GreaterThanPacket) = Int(packetop(p.subpackets[1]) > packetop(p.subpackets[2]))
packetop(p::LessThanPacket)    = Int(packetop(p.subpackets[1]) < packetop(p.subpackets[2]))
packetop(p::EqualToPacket)     = Int(packetop(p.subpackets[1]) == packetop(p.subpackets[2]))

function part1(b::BitVector)
    packets, remainder = parsepacket(b)
    sum = versionsum(packets)
    return sum
end

function part2(b::BitVector)
    packets, remainder = parsepacket(b)
    value = packetop(packets)
    return value
end

println(part1(parseinput(filename)))
println(part2(parseinput(filename)))