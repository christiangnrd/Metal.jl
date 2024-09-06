"""
# MPSGraph

`MPSGraph` is where the Metal Performance Shaders Graph API wrappers are defined.

Not all functionality is currently implemented or documented. For further details,
refer to the [official Apple documentation](https://developer.apple.com/documentation/metalperformanceshadersgraph).
"""
module MPSGraph

using ..Metal
using .MTL
using .MPS: MPSDataType, MPSMatrix, MPSVector, MPSShape

using CEnum
using ObjectiveC, .Foundation

include("libmpsgraph.jl")

include("core.jl")
include("tensor.jl")

end
