## kernels

export encode!

@cenum MPSImageEdgeMode::NSUInteger begin
    MPSImageEdgeModeZero           = 0
    MPSImageEdgeModeClamp          = 1
    MPSImageEdgeModeMirror         = 2
    MPSImageEdgeModeMirrorWithEdge = 3
    MPSImageEdgeModeConstant       = 4
end

@objcwrapper immutable=false MPSUnaryImageKernel <: MPSKernel

@objcproperties MPSUnaryImageKernel begin
    @autoproperty offset::MPSOffset setter=setOffset
    @autoproperty clipRect::MTLRegion
    @autoproperty edgeMode::MPSImageEdgeMode setter=setEdgeMode
end

function encode!(cmdbuf::MTLCommandBuffer, kernel::K, sourceTexture::MTLTexture, destinationTexture::MTLTexture) where {K<:MPSUnaryImageKernel}
    @objc [kernel::id{K} encodeToCommandBuffer:cmdbuf::id{MTLCommandBuffer}
                                     sourceTexture:sourceTexture::id{MTLTexture}
                                     destinationTexture:destinationTexture::id{MTLTexture}]::Nothing
end

# TODO: Implement MPSCopyAllocator to allow blurring (and other things) to be done in-place
# function encode!(cmdbuf::MTLCommandBuffer, kernel::K, inPlaceTexture::MTLTexture, copyAllocator=nothing) where {K<:MPSUnaryImageKernel}
#     @objc [kernel::id{K} encodeToCommandBuffer:cmdbuf::id{MTLCommandBuffer}
#                                      inPlaceTexture:inPlaceTexture::id{MTLTexture}
#                                      fallbackCopyAllocator:copyAllocator::MPSCopyAllocator]::Bool
# end

@objcwrapper immutable=false MPSBinaryImageKernel <: MPSKernel

@objcproperties MPSBinaryImageKernel begin
    @autoproperty primaryOffset::MPSOffset setter=setPrimaryOffset
    @autoproperty secondaryOffset::MPSOffset setter=setSecondaryOffset
    @autoproperty primaryEdgeMode::MPSImageEdgeMode
    @autoproperty secondaryEdgeMode::MPSImageEdgeMode
    @autoproperty clipRect::MTLRegion
end

function encode!(cmdbuf::MTLCommandBuffer, kernel::K, primaryTexture::MTLTexture, secondaryTexture::MTLTexture, destinationTexture::MTLTexture) where {K<:MPSBinaryImageKernel}
    @objc [kernel::id{K} encodeToCommandBuffer:cmdbuf::id{MTLCommandBuffer}
                                     primaryTexture:primaryTexture::id{MTLTexture}
                                     secondaryTexture:secondaryTexture::id{MTLTexture}
                                     destinationTexture:destinationTexture::id{MTLTexture}]::Nothing
end
