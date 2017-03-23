module OptionalData

__precompile__()

export @OptionalData, OptData, show, push!, isavailable, get

import Base: push!, get, show

type OptData{T}
    data::Nullable{T}
    name::String
    msg::String
end
OptData{T}(::Type{T}, name, msg="") = OptData{T}(nothing, name, msg)

function show{T}(io::IO, opt::OptData{T})
    val = isavailable(opt) ? get(opt) : ""
    print(io, "OptData{$T}($val)")
end

function push!{T}(opt::OptData{T}, data::T)
    opt.data = Nullable{T}(data)
    opt
end

function push!{T}(opt::OptData{T}, args...)
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
