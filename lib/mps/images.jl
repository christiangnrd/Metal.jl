## kernels

# @objcwrapper immutable=false MPSImageDescriptor <: NSObject

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

# @objcwrapper immutable=false MPSImage <: NSObject

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

# @objcwrapper immutable=false MPSUnaryImageKernel <: MPSKernel

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

# @objcwrapper immutable=false MPSBinaryImageKernel <: MPSKernel

## gaussian blur

export MPSImageGaussianBlur, encode!

# @objcwrapper immutable=false MPSImageGaussianBlur <: MPSUnaryImageKernel

function MPSImageGaussianBlur(dev, sigma)
    kernel = @objc [MPSImageGaussianBlur alloc]::id{MPSImageGaussianBlur}
    obj = MPSImageGaussianBlur(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSImageGaussianBlur} initWithDevice:dev::id{MTLDevice}
                                  sigma:sigma::Float32]::id{MPSImageGaussianBlur}
    return obj
end


## image box

export MPSImageBox

# @objcwrapper immutable=false MPSImageBox <: MPSUnaryImageKernel

function MPSImageBox(dev, kernelWidth, kernelHeight)
    kernel = @objc [MPSImageBox alloc]::id{MPSImageBox}
    obj = MPSImageBox(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSImageBox} initWithDevice:dev::id{MTLDevice}
                                kernelWidth:kernelWidth::Int
                                kernelHeight:kernelHeight::Int]::id{MPSImageBox}
    return obj
end


## high-level blurring functionality. Interface subject to change

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
