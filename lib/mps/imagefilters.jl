## gaussian blur

export MPSImageGaussianBlur

@objcwrapper immutable=false MPSImageGaussianBlur <: MPSUnaryImageKernel

function MPSImageGaussianBlur(dev::MTLDevice, sigma::Real)
    kernel = @objc [MPSImageGaussianBlur alloc]::id{MPSImageGaussianBlur}
    obj = MPSImageGaussianBlur(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSImageGaussianBlur} initWithDevice:dev::id{MTLDevice}
                                  sigma:sigma::Float32]::id{MPSImageGaussianBlur}
    return obj
end


## image box

export MPSImageBox

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

## image reduction filters #

@objcwrapper immutable=false MPSImageReduceUnary <: MPSUnaryImageKernel

@objcproperties MPSImageReduceUnary begin
    @autoproperty clipRect::MTLRegion
end

# Implement the MPSImageReduce kernels
for dim in (:Row, :Column), func in (:Max, :Min, :Sum, :Mean)
    fullfunc = Symbol(:MPSImageReduce, dim, func)
    @eval begin
        export $fullfunc

        @objcwrapper immutable=false $fullfunc <: MPSImageReduceUnary
    end
    @eval begin
        function $fullfunc(dev)
            kernel = @objc [$fullfunc alloc]::id{$fullfunc}
            obj = $fullfunc(kernel)
            finalizer(release, obj)
            @objc [obj::id{$fullfunc} initWithDevice:dev::id{MTLDevice}]::id{$fullfunc}
            return obj
        end
    end
end

## high-level blurring functionality

function unaryfilter(kernel, image; pixelFormat=MTL.MTLPixelFormatRGBA8Unorm, async=false)
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

    async || wait_completed(cmdbuf)

    return res
end

function binaryfilter(kernel, image1, image2; pixelFormat=MTL.MTLPixelFormatRGBA8Unorm, async=false)
    res = copy(image1)

    w,h = size(image1)

    alignment = MTL.minimumLinearTextureAlignmentForPixelFormat(current_device(), pixelFormat)
    preBytesPerRow = sizeof(eltype(image1))*w

    rowoffset = alignment - (preBytesPerRow - 1) % alignment - 1
    bytesPerRow = preBytesPerRow + rowoffset

    textDesc1 = MTLTextureDescriptor(pixelFormat, w, h)
    textDesc1.usage = MTL.MTLTextureUsageShaderRead | MTL.MTLTextureUsageShaderWrite
    text1 = MTL.MTLTexture(image1.data.rc.obj, textDesc1, 0, bytesPerRow)

    textDesc2 = MTLTextureDescriptor(pixelFormat, w, h)
    textDesc2.usage = MTL.MTLTextureUsageShaderRead | MTL.MTLTextureUsageShaderWrite
    text2 = MTL.MTLTexture(image2.data.rc.obj, textDesc2, 0, bytesPerRow)

    textDesc3 = MTLTextureDescriptor(pixelFormat, w, h)
    textDesc3.usage = MTL.MTLTextureUsageShaderRead | MTL.MTLTextureUsageShaderWrite
    text3 = MTL.MTLTexture(res.data.rc.obj, textDesc3, 0, bytesPerRow)

    cmdbuf = MTLCommandBuffer(global_queue(current_device()))
    encode!(cmdbuf, kernel, text1, text2, text3)
    commit!(cmdbuf)

    async || wait_completed(cmdbuf)

    return res
end

function gaussianblur(image; sigma, kwargs...)
    kernel = MPSImageGaussianBlur(device(), sigma)
    return unaryfilter(kernel, image; kwargs...)
end

function boxblur(image, kernelWidth, kernelHeight; kwargs...)
    kernel = MPSImageBox(device(), kernelWidth, kernelHeight)
    return unaryfilter(kernel, image; kwargs...)
end
