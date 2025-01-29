using LinearAlgebra

if MPS.is_supported(device())


@testset "test matrix vector multiplication of views" begin
    N = 20
    a = rand(Float32, N,N)
    b = rand(Float32, N)

    mtl_a = mtl(a)
    mtl_b = mtl(b)

    view_a = @view a[:,10:end]
    view_b = @view b[10:end]

    mtl_view_a = @view mtl_a[:,10:end]
    mtl_view_b = @view mtl_b[10:end]

    mtl_c = mtl_view_a * mtl_view_b
    c = view_a * view_b

    @test Array(mtl_c) == c
end

using Metal: storagemode
@testset "decompositions" begin
    A = MtlMatrix(rand(Float32, 1024, 1024))
    lua = lu(A)
    @test lua.L * lua.U ≈ MtlMatrix(lua.P) * A

    A = MtlMatrix(rand(Float32, 1024, 512))
    lua = lu(A)
    @test lua.L * lua.U ≈ MtlMatrix(lua.P) * A

    A = MtlMatrix(rand(Float32, 512, 1024))
    lua = lu(A)
    @test lua.L * lua.U ≈ MtlMatrix(lua.P) * A

    a = rand(Float32, 1024, 1024)
    A = MtlMatrix(a)
    B = MtlMatrix(a)
    lua = lu!(A)
    @test lua.L * lua.U ≈ MtlMatrix(lua.P) * B

    A = MtlMatrix{Float32}([1 2; 0 0])
    @test_throws SingularException lu(A)

    altStorage = Metal.DefaultStorageMode != Metal.PrivateStorage ? Metal.PrivateStorage : Metal.SharedStorage
    A = MtlMatrix{Float32,altStorage}(rand(Float32, 1024, 1024))
    lua = lu(A)
    @test storagemode(lua.factors) == storagemode(lua.ipiv) == storagemode(A)
    lua = lu!(A)
    @test storagemode(lua.factors) == storagemode(lua.ipiv) == storagemode(A)
end

end
