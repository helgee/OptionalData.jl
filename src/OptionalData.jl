module OptionalData

export OptData, push!, isavailable, get

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

function get(opt::OptData)
    !isavailable(opt) && error("Optional data is not available.")
    get(opt.data)
end

isavailable(opt::OptData) = !isnull(opt.data)

end # module
