# OptionalData

*Work with global data that might not be available.*

[![Build Status](https://github.com/helgee/OptionalData.jl/workflows/CI/badge.svg?branch=master)](https://github.com/helgee/OptionalData.jl/actions)
[![Coverage](https://codecov.io/gh/helgee/OptionalData.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/helgee/OptionalData.jl)

This package provides the `@OptionalData` macro and the corresponding `OptData`
type which is a thin wrapper around a nullable value (of type `Union{T, Nothing} where T`).
It allows you to load and access globally available data at runtime in a type-stable way.

## Installation

The package can be installed through Julia's package manager:

```julia
Pkg.add("OptionalData")
```

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

