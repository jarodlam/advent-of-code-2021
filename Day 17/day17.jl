struct Trajectory
    ux::Integer
    uy::Integer
    x::Vector{<:Integer}
    y::Vector{<:Integer}
    ymax::Integer
end

const filename = "input.txt"
const uxrange = 1:100
const uyrange = -300:300
const trange = 1:1000

function parseinput(fn::String)
    str = ""
    open(fn) do file
        str = read(file, String)
    end

    xmin = parse(Int, match(r"x=\K\d*", str).match)
    xmax = parse(Int, match(r"x=\d*\.\.\K\d*", str).match)
    ymin = parse(Int, match(r"y=\K-?\d*", str).match)
    ymax = parse(Int, match(r"y=-?\d*\.\.\K-?\d*", str).match)

    return (xmin:xmax, ymin:ymax)
end

calctraj(u::Integer, t::UnitRange{<:Integer}) = (-t.^2 .+ (2 * u + 1) .* t) .÷ 2
calctrajmax(u::Integer) = (u^2 + u) .÷ 2
calctrajmax(u::Integer, n::Integer) = repeat([calctrajmax(u)], n)

function calctrajectory_x(u::Integer, t::UnitRange{<:Integer})
    if u >= t[end]
        return calctraj(u, t)
    else
        return vcat(calctraj(u, t[1:u]), calctrajmax(u, length(t)-u))
    end
end

calctrajectory_y(u::Integer, t::UnitRange{<:Integer}) = calctraj(u, t)

intersectsrange(x::Vector, r::AbstractRange) = in.(x, Ref(r))

function solve(xrange::UnitRange{<:Integer}, yrange::UnitRange{<:Integer})
    # Sweep u values
    trajectories = Trajectory[]
    for (ux, uy) in Iterators.product(uxrange, uyrange)
        traj = Trajectory(
            ux,
            uy,
            calctrajectory_x(ux, trange),
            calctrajectory_y(uy, trange),
            calctrajmax(uy)
        )
        push!(trajectories, traj)
    end

    # Filter out trajectories that don't fall in range
    filter!(x -> any(intersectsrange(x.x, xrange) .& intersectsrange(x.y, yrange)), trajectories)

    # Find max height trajectory
    maxtraj = maximum(x -> x.ymax, trajectories)
    
    return maxtraj, length(trajectories)
end

println(solve(parseinput(filename)...))