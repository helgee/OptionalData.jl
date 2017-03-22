module OptionalData

__precompile__()

export @OptionalData, OptData, show, push!, isavailable, get

import Base: push!, get, show

mutable struct OptData{T}
    data::Nullable{T}
    name::String
    msg::String
end
OptData(::Type{T}, name, msg="") where T = OptData{T}(nothing, name, msg)

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

function get(opt::OptData)
    !isavailable(opt) && error(opt.name, " is not available. ", opt.msg)
    get(opt.data)
end

macro OptionalData(name, typ, msg="")
   :(const $(esc(name)) = OptData($(esc(typ)), $(string(name)), $msg))
end

isavailable(opt::OptData) = !isnull(opt.data)

end # module
