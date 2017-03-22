module OptionalData

export OptData, push!, isavailable, get, @get

import Base: push!, get

mutable struct OptData{T}
    data::Nullable{T}
    OptData(::Type{T}) where T = new{T}(nothing)
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
