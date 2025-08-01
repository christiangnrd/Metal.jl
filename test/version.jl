@testset "version" begin

@test Metal.darwin_version() isa VersionNumber
@test Metal.macos_version() isa VersionNumber
@test Metal.is_macos(Metal.macos_version())

@test Metal.metallib_support() isa VersionNumber
@test Metal.air_support() isa VersionNumber
@test Metal.metal_support() isa VersionNumber

@test Metal.num_gpu_cores() isa Int64

end # testset "version"
