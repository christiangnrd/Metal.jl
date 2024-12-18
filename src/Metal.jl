module Metal

using GPUArrays
using Adapt
using GPUCompiler
using LLVM
using LLVM.Interop
import LLVMDowngrader_jll
using Preferences: @load_preference, load_preference
using Python_jll
using ObjectFile
using ExprTools: splitdef, combinedef
using Artifacts
using ObjectiveC, .CoreFoundation, .Foundation, .Dispatch, .OS
import KernelAbstractions

include("version.jl")

# core library
include("../lib/mtl/MTL.jl")
using .MTL
export MTL

# essential stuff
include("state.jl")
include("initialization.jl")

# device functionality
include("device/utils.jl")
include("device/pointer.jl")
include("device/array.jl")
include("device/runtime.jl")
include("device/intrinsics/arguments.jl")
include("device/intrinsics/math.jl")
include("device/intrinsics/synchronization.jl")
include("device/intrinsics/memory.jl")
include("device/intrinsics/simd.jl")
include("device/intrinsics/version.jl")
include("device/intrinsics/atomics.jl")
include("device/quirks.jl")

# array essentials
include("pool.jl")
include("memory.jl")
include("array.jl")

# compiler implementation
include("compiler/library.jl")
include("compiler/compilation.jl")
include("compiler/execution.jl")
include("compiler/reflection.jl")

# libraries
include("../lib/mps/MPS.jl")
export MPS
include("../lib/mpsgraphs/MPSGraphs.jl")
export MPSGraphs

# LinearAlgebra
include("linalg.jl")

# array implementation
include("utilities.jl")
include("broadcast.jl")
include("mapreduce.jl")
include("accumulate.jl")
include("indexing.jl")
include("random.jl")
include("gpuarrays.jl")

# KernelAbstractions
include("MetalKernels.jl")
import .MetalKernels: MetalBackend
export MetalBackend

include("deprecated.jl")

#=
using Metal, GPUArrays
using LinearAlgebra: wrap
function metalpeakflops(
                    n::Integer=4096,
                    dtype::DataType=Float32,
                    ntrials::Integer=3)
    t = Base.zeros(Float64, ntrials)
    for i=1:ntrials
        c = mtl(zeros(dtype,n,n))
        a = mtl(ones(dtype,n,n))
        b = mtl(ones(dtype,n,n))
        t[i] = @elapsed Metal.@sync GPUArrays.generic_matmatmul!(c,wrap(a,'N'),wrap(b,'N'),1,0)
        @assert all(c .== n)
    end

    return 2*Float64(n)^3 / minimum(t)
end
function mpspeakflops(
        n::Integer=4096,
        dtype::DataType=Float32,
        ntrials::Integer=3)
    t = Base.zeros(Float64, ntrials)
    for i=1:ntrials
        c = mtl(zeros(dtype,n,n))
        a = mtl(ones(dtype,n,n))
        b = mtl(ones(dtype,n,n))
        t[i] = @elapsed Metal.@sync MPS.matmul!(c,a,b)
        @assert all(c .== n)
    end

    return 2*Float64(n)^3 / minimum(t)
end
function graphpeakflops(
        n::Integer=4096,
        dtype::DataType=Float32,
        ntrials::Integer=3)
    t = Base.zeros(Float64, ntrials)
    for i=1:ntrials
        c = mtl(zeros(dtype,n,n))
        a = mtl(ones(dtype,n,n))
        b = mtl(ones(dtype,n,n))
        t[i] = @elapsed Metal.@sync MPSGraphs.graph_matmul!(c,a,b)
        @assert all(c .== n)
    end

    return 2*Float64(n)^3 / minimum(t)
end


function mpsmain(T=Float32, N=10000)
    a = Metal.rand(T, N, N)
    b = Metal.rand(T, N, N)
    synchronize()

    for i in 1:20
        # @autoreleasepool begin
        begin
            d = Metal.zeros(T, size(a))
            @time "Iteration $i" Metal.@sync MPS.matmul!(d, a, b, #=alpha=#true, #=beta=#false,
                        #=transpose_a=#false, #=transpose_b=#false)
            if any(isnan.(Array(d)))
                @info "NaN in iteration $i"
            end
        end
    end
end

function graphmain(T=Float32, N=10000)
    a = Metal.rand(T, N, N)
    b = Metal.rand(T, N, N)
    synchronize()

    for i in 1:20
        # @autoreleasepool begin
        begin
            d = Metal.zeros(T, size(a))
            @time "Iteration $i" Metal.@sync MPSGraphs.graph_matmul!(d, a, b, #=alpha=#true, #=beta=#false,
                        #=transpose_a=#false, #=transpose_b=#false)
            if any(isnan.(Array(d)))
                @info "NaN in iteration $i"
            end
        end
    end
end

=#
include("precompile.jl")

end # module
