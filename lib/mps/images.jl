@cenum MPSImageEdgeMode::NSUInteger begin
    MPSImageEdgeModeZero           = 0
    MPSImageEdgeModeClamp          = 1
    MPSImageEdgeModeMirror         = 2
    MPSImageEdgeModeMirrorWithEdge = 3
    MPSImageEdgeModeConstant       = 4
end

@cenum MPSImageFeatureChannelFormat::NSUInteger begin
    MPSImageFeatureChannelFormatNone       = 0
    MPSImageFeatureChannelFormatUnorm8     = 1
    MPSImageFeatureChannelFormatUnorm16    = 2
    MPSImageFeatureChannelFormatFloat16    = 3
    MPSImageFeatureChannelFormatFloat32    = 4
    MPSImageFeatureChannelFormat_reserved0 = 5
end

@objcwrapper immutable=false MPSImageDescriptor <: NSObject

@objcproperties MPSImageDescriptor begin
    # Configuring an MPSImageDescriptor
    @autoproperty width::NSUInteger
    @autoproperty height::NSUInteger
    @autoproperty featureChannels::NSUInteger
    @autoproperty numberOfImages::NSUInteger
    @autoproperty pixelFormat::MTL.MTLPixelFormat
    @autoproperty channelFormat::MPSImageFeatureChannelFormat
    @autoproperty cpuCacheMode::MTL.MTLCPUCacheMode setter=setCpuCacheMode
    @autoproperty storageMode::MTL.MTLStorageMode setter=setStorageMode
    @autoproperty usage::MTL.MTLTextureUsage setter=setUsage
end

# imageDescriptorWithChannelFormat
function MPSImageDescriptor(channelFormat, width, height, featureChannels)
    desc = @objc [MPSImageDescriptor imageDescriptorWithChannelFormat:channelFormat::MPSImageFeatureChannelFormat
                                          width:width::NSUInteger
                                          height:height::NSUInteger
                                          featureChannels:featureChannels::NSUInteger]::id{MPSImageDescriptor}
    obj = MPSImageDescriptor(desc)
    finalizer(release, obj)
    return obj
end
function MPSImageDescriptor(channelFormat, width, height, featureChannels, numberOfImages, usage)
    desc = @objc [MPSImageDescriptor imageDescriptorWithChannelFormat:channelFormat::MPSImageFeatureChannelFormat
                                          width:width::NSUInteger
                                          height:height::NSUInteger
                                          featureChannels:featureChannels::NSUInteger
                                          numberOfImages:numberOfImages::NSUInteger
                                          usage:usage::MTL.MTLTextureUsage]::id{MPSImageDescriptor}
    obj = MPSImageDescriptor(desc)
    finalizer(release, obj)
    return obj
end

@objcwrapper immutable=false MPSImage <: NSObject

# Configuring an MPSImage
@objcproperties MPSImage begin
    # Configuring an MPSImage
    @autoproperty device::id{MTLDevice}
    @autoproperty width::NSUInteger
    @autoproperty height::NSUInteger
    @autoproperty featureChannels::NSUInteger
    @autoproperty numberOfImages::NSUInteger
    # @autoproperty textureType::MTL.MTLTextureType
    @autoproperty pixelFormat::MTL.MTLPixelFormat
    @autoproperty precision::NSUInteger
    @autoproperty usage::MTL.MTLTextureUsage
    @autoproperty pixelSize::NSUInteger
    @autoproperty texture::id{MTL.MTLTexture}
    @autoproperty label::id{NSString}
end

function MPSImage(device::MTLDevice, imageDescriptor)
    imgaddr = @objc [MPSImage alloc]::id{MPSImage}
    obj = MPSImage(imgaddr)
    finalizer(release, obj)
    @objc [obj::id{MPSImage} initWithDevice:device::id{MTLDevice}
                                imageDescriptor:imageDescriptor::id{MPSImageDescriptor}]::id{MPSImage}
    return obj
end

function MPSImage(texture, featureChannels)
    imgaddr = @objc [MPSImage alloc]::id{MPSImage}
    obj = MPSImage(imgaddr)
    finalizer(release, obj)
    @objc [obj::id{MPSImage} initWithTexture:texture::id{MTLTexture}
                                featureChannels:featureChannels::NSUInteger]::id{MPSImage}
    return obj
end

function MPSImage(parent::MPSImage, sliceRange, featureChannels)
    imgaddr = @objc [MPSImage alloc]::id{MPSImage}
    obj = MPSImage(imgaddr)
    finalizer(release, obj)
    @objc [obj::id{MPSImage} initWithParentImage:parent::id{MPSImage}
                            sliceRange:sliceRange::NSRange
                            featureChannels:featureChannels::NSUInteger]::id{MPSImage}
    return obj
end

@objcwrapper immutable=false MPSUnaryImageKernel <: MPSKernel

@objcproperties MPSUnaryImageKernel begin
    @autoproperty offset::MPSOffset setter=setOffset
    @autoproperty clipRect::MTLRegion setter=setClipRect
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
    @autoproperty primaryOffset::MPSOffset
    @autoproperty secondaryOffset::MPSOffset
    @autoproperty primaryEdgeMode::MPSImageEdgeMode
    @autoproperty secondaryEdgeMode::MPSImageEdgeMode
    @autoproperty clipRect::MTLRegion
end

@objcwrapper immutable=false MPSImageGaussianBlur <: MPSUnaryImageKernel

function MPSImageGaussianBlur(dev, sigma)
    kernel = @objc [MPSImageGaussianBlur alloc]::id{MPSImageGaussianBlur}
    obj = MPSImageGaussianBlur(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSImageGaussianBlur} initWithDevice:dev::id{MTLDevice}
                                  sigma:sigma::Float32]::id{MPSImageGaussianBlur}
    return obj
end


@objcwrapper immutable=false MPSImageBox <: MPSUnaryImageKernel

function MPSImageBox(dev, kernelWidth, kernelHeight)
    kernel = @objc [MPSImageBox alloc]::id{MPSImageBox}
    obj = MPSImageBox(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSImageBox} initWithDevice:dev::id{MTLDevice}
                                kernelWidth:kernelWidth::Int
                                kernelHeight:kernelHeight::Int]::id{MPSImageBox}
    return obj
end


# High-level functions for image blurring

function blur(image, kernel::MPSUnaryImageKernel; pixelFormat=MTL.MTLPixelFormatRGBA8Unorm)
    res = copy(image)

    w,h = size(image)

    alignment = MTL.minimumLinearTextureAlignmentForPixelFormat(device(), pixelFormat)
    preBytesPerRow = sizeof(eltype(image))*w

    rowoffset = alignment - (preBytesPerRow - 1) % alignment - 1
    bytesPerRow = preBytesPerRow + rowoffset

    textDesc1 = MTLTextureDescriptor(pixelFormat, w, h)
    textDesc1.usage = MTL.MTLTextureUsageShaderRead | MTL.MTLTextureUsageShaderWrite
    text1 = MTL.MTLTexture(image.data.rc.obj, textDesc1, 0, bytesPerRow)

    textDesc2 = MTLTextureDescriptor(pixelFormat, w, h)
    textDesc2.usage = MTL.MTLTextureUsageShaderRead | MTL.MTLTextureUsageShaderWrite
    text2 = MTL.MTLTexture(res.data.rc.obj, textDesc2, 0, bytesPerRow)

    cmdbuf = MTLCommandBuffer(global_queue(device()))
    encode!(cmdbuf, kernel, text1, text2)
    commit!(cmdbuf)

    return res
end

function gaussianblur(image; sigma, pixelFormat=MTL.MTLPixelFormatRGBA8Unorm)
    kernel = MPSImageGaussianBlur(device(), sigma)
    return blur(image, kernel; pixelFormat)
end

function boxblur(image, kernelWidth, kernelHeight; pixelFormat=MTL.MTLPixelFormatRGBA8Unorm)
    kernel = MPSImageBox(device(), kernelWidth, kernelHeight)
    return blur(image, kernel; pixelFormat)
end
