using Metal

dev = device()

@info dev.name |> String
@show Metal.macos_version()
@show Metal.metal_support()
@show MTL.supports_family(dev, MTL.MTLGPUFamilyApple1)
@show MTL.supports_family(dev, MTL.MTLGPUFamilyApple2)
@show MTL.supports_family(dev, MTL.MTLGPUFamilyApple3)
@show MTL.supports_family(dev, MTL.MTLGPUFamilyApple4)
@show MTL.supports_family(dev, MTL.MTLGPUFamilyApple5)
@show MTL.supports_family(dev, MTL.MTLGPUFamilyApple6)
@info "Apple7 needed for Metal 3"
@show MTL.supports_family(dev, MTL.MTLGPUFamilyApple7)
@show MTL.supports_family(dev, MTL.MTLGPUFamilyApple8)
@show MTL.supports_family(dev, MTL.MTLGPUFamilyApple9)
@show MTL.MTLCompileOptions().languageVersion
a = MtlArray([1,2,3])
@show a
a .+= 1
@show a
