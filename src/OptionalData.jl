module OptionalData

export OptData, show, push!, isavailable, get, @get

import Base: push!, get, show

mutable struct OptData{T}
    data::Nullable{T}
    OptData{T}() where T = new{T}(nothing)
end
OptData(::Type{T}) where T = OptData{T}()

function show(io::IO, opt::OptData{T}) where T
    val = isavailable(opt) ? get(opt) : ""
    print(io, "OptData{$T}($val)")
end

function push!(opt::OptData{T}, data) where T
    opt.data = Nullable{T}(data)
    opt
end

function push!(opt::OptData{T}, args...) where T
    push!(opt, T(args...))
    opt
end

function get(opt::OptData, var::AbstractString="")
    name = !isempty(var) ? var : "Optional data"
    !isavailable(opt) && error(name, " is not available.")
    get(opt.data)
end

macro get(sym)
    var = string(sym)
    :(get($(esc(sym)), $var))
end

isavailable(opt::OptData) = !isnull(opt.data)

end # module
