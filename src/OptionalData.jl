"""
# OptionalData

This package provides the `@OptionalData` macro and the corresponding `OptData`
type which is a thin wrapper around a nullable value (of type `Union{T, Nothing} where T`).
It allows you to load and access globally available data at runtime in a type-stable way.

## Usage

*OptionalData* has the following use cases:

1. Parts of your package depend on data from the internet while other parts do not.
   In the case of a network outage the package should offer a degraded experience but
   the independent parts should still function.
2. Your package requires manual initialisation steps, e.g. loading data from a
   user-supplied file, and you do not want to repeat yourself writing code that
   checks for the availability of the data.

You declare optional global data with the `@OptionalData` macro:

```julia
using OptionalData

# @OptionalData name type [error_msg]
@OptionalData OPT_FLOAT Float64 "Forgot to load it?"

# this expands to
const OPT_FLOAT = OptData{Float64}(string(:OPT_FLOAT), "Forgot to load it?")
```

You access its value with `get` and check whether it is available with `isavailable`:

```julia
# This will throw a `NoDataError` because OPT_FLOAT does not contain a value, yet.
get(OPT_FLOAT)
# ERROR: OPT_FLOAT is not available. Forgot to load it?
isavailable(OPT_FLOAT) == false
```

Use `push!` to load the data:

```julia
push!(OPT_FLOAT, 3.0)
isavailable(OPT_FLOAT) == true
get(OPT_FLOAT) == 3.0
```
"""
module OptionalData

export @OptionalData, OptData, NoDataError, show, push!, isavailable, get

import Base: push!, get, show

mutable struct OptData{T}
    data::Union{T, Nothing}
    name::String
    msg::String
end
OptData{T}(name, msg="") where {T} = OptData{T}(nothing, name, msg)

"""
    NoDataError(opt::OptData)

`opt` does not contain data.
"""
struct NoDataError <: Exception
    opt::OptData
end

function Base.showerror(io::IO, err::NoDataError)
    print(io, err.opt.name, " is not available. ", err.opt.msg)
end

function show(io::IO, opt::OptData{T}) where T
    val = isavailable(opt) ? get(opt) : ""
    print(io, "OptData{$T}($val)")
end

"""
    push!(opt::OptData{T}, data::T) where T

Push `data` of type `T` to `opt`.
"""
function push!(opt::OptData{T}, data::T) where T
    opt.data = data
    opt
end

"""
    push!(opt::OptData, ::Type{T}, args...) where T

Construct an object of type `T` from `args` and push it to `opt`.
"""
function push!(opt::OptData, ::Type{T}, args...) where {T}
    push!(opt, T(args...))
    opt
end
push!(opt::OptData{T}, args...) where {T} = push!(opt, T, args...)

"""
    get(opt::OptData)

Get data from `opt`. Throw an exception if no data has been pushed to `opt` before.
"""
function get(opt::OptData{T}) where T
    !isavailable(opt) && throw(NoDataError(opt))
    opt.data::T
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
    :(const $(esc(name)) = OptData{$(esc(typ))}($(string(name)), $msg))
end

"""
    isavailable(opt::OptData)

Check whether data has been pushed to `opt`.
"""
isavailable(opt::OptData) = opt.data !== nothing

end # module
