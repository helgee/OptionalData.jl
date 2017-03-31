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

"""
    push!{T}(opt::OptData{T}, data::T)

Push `data` of type `T` to `opt`.
"""
function push!{T}(opt::OptData{T}, data::T)
    opt.data = Nullable{T}(data)
    opt
end

"""
    push!{T}(opt::OptData, ::Type{T}, args...)

Construct an object of type `T` from `args` and push it to `opt`.
"""
function push!{T}(opt::OptData, ::Type{T}, args...)
    push!(opt, T(args...))
    opt
end
push!{T}(opt::OptData{T}, args...) = push!(opt, T, args...)

"""
    get(opt::OptData)

Get data from `opt`. Throw an exception if no data has been pushed to `opt` before.
"""
function get(opt::OptData)
    !isavailable(opt) && error(opt.name, " is not available. ", opt.msg)
    get(opt.data)
end

"""
    @OptionalData name type msg=""

Initialise a constant `name` with type `OptData{type}`.
An exception with the custom error message `msg` is thrown when `name` is
accessed before data has been pushed to it.

# Example

```julia
@OptionalData OPT_FLOAT Float64
```
"""
macro OptionalData(name, typ, msg="")
   :(const $(esc(name)) = OptData($(esc(typ)), $(string(name)), $msg))
end

"""
    isavailable(opt::OptData)

Check whether data has been pushed to `opt`.
"""
isavailable(opt::OptData) = !isnull(opt.data)

end # module
