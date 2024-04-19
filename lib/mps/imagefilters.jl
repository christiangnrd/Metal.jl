@objcwrapper immutable=false MPSImageGaussianBlur <: MPSUnaryImageKernel

function MPSImageGaussianBlur(device::MTLDevice, sigma::Real)
    kernel = @objc [MPSImageGaussianBlur alloc]::id{MPSImageGaussianBlur}
    obj = MPSImageGaussianBlur(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSImageGaussianBlur} initWithDevice:device::id{MTLDevice}
                                  sigma:sigma::Float32]::id{MPSImageGaussianBlur}
    return obj
end


@objcwrapper immutable=false MPSImageBox <: MPSUnaryImageKernel

function MPSImageBox(device, kernelWidth, kernelHeight)
    kernel = @objc [MPSImageBox alloc]::id{MPSImageBox}
    obj = MPSImageBox(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSImageBox} initWithDevice:device::id{MTLDevice}
                                kernelWidth:kernelWidth::Int
                                kernelHeight:kernelHeight::Int]::id{MPSImageBox}
    return obj
end

###########################
# Image Reduction Filters #
###########################

@objcwrapper immutable=false MPSImageReduceUnary <: MPSUnaryImageKernel

@objcproperties MPSImageReduceUnary begin
    @autoproperty clipRect::MTLRegion
end

# Implement the MPSImageReduce kernels
for dim in (:Row, :Column), func in (:Max, :Min, :Sum, :Mean)
    fullfunc = Symbol(:MPSImageReduce, dim, func)
    @eval begin
        @objcwrapper immutable=false $fullfunc <: MPSImageReduceUnary

        function $fullfunc(device)
            kernel = @objc [$fullfunc alloc]::id{$fullfunc}
            obj = $fullfunc(kernel)
            finalizer(release, obj)
            @objc [obj::id{$fullfunc} initWithDevice:device::id{MTLDevice}]::id{$fullfunc}
            return obj
        end
    end
end

############################
# Image Arithmetic Filters #
############################

@objcwrapper immutable=false MPSImageArithmetic <: MPSBinaryImageKernel

@objcproperties MPSImageArithmetic begin
    @autoproperty bias::Float32 setter=setBias
    @autoproperty primaryScale::Float32 setter=setPrimaryScale
    @autoproperty primaryStrideInPixels::MTLSize setter=setPrimaryStrideInPixels
    @autoproperty secondaryScale::Float32 setter=setSecondaryScale
    @autoproperty secondaryStrideInPixels::MTLSize setter=setSecondaryStrideInPixels
    @autoproperty minimumValue::Float32 setter=setMinimumValue
    @autoproperty maximumValue::Float32 setter=setMaximumValue
end

# Implement the MPSImageArithmetic kernels
for func in (:Add, :Subtract, :Multiply, :Divide)
    fullfunc = Symbol(:MPSImage, func)
    @eval begin
        @objcwrapper immutable=false $fullfunc <: MPSImageArithmetic

        function $fullfunc(device)
            kernel = @objc [$fullfunc alloc]::id{$fullfunc}
            obj = $fullfunc(kernel)
            finalizer(release, obj)
            @objc [obj::id{$fullfunc} initWithDevice:device::id{MTLDevice}]::id{$fullfunc}
            return obj
        end
    end
end

###########################################
# High-level functions for image blurring #
###########################################

function blur(image, kernel; pixelFormat=MTL.MTLPixelFormatRGBA8Unorm)
    res = copy(image)

    w,h = size(image)

    alignment = MTL.minimumLinearTextureAlignmentForPixelFormat(current_device(), pixelFormat)
    preBytesPerRow = sizeof(eltype(image))*w

    rowoffset = alignment - (preBytesPerRow - 1) % alignment - 1
    bytesPerRow = preBytesPerRow + rowoffset

    textDesc1 = MTLTextureDescriptor(pixelFormat, w, h)
    textDesc1.usage = MTL.MTLTextureUsageShaderRead | MTL.MTLTextureUsageShaderWrite
    text1 = MTL.MTLTexture(image.data.rc.obj, textDesc1, 0, bytesPerRow)

    textDesc2 = MTLTextureDescriptor(pixelFormat, w, h)
    textDesc2.usage = MTL.MTLTextureUsageShaderRead | MTL.MTLTextureUsageShaderWrite
    text2 = MTL.MTLTexture(res.data.rc.obj, textDesc2, 0, bytesPerRow)

    cmdbuf = MTLCommandBuffer(global_queue(current_device()))
    encode!(cmdbuf, kernel, text1, text2)
    commit!(cmdbuf)

    return res
end

function gaussianblur(image; sigma, pixelFormat=MTL.MTLPixelFormatRGBA8Unorm)
    kernel = MPSImageGaussianBlur(current_device(), sigma)
    return blur(image, kernel; pixelFormat)
end

function boxblur(image, kernelWidth, kernelHeight; pixelFormat=MTL.MTLPixelFormatRGBA8Unorm)
    kernel = MPSImageBox(current_device(), kernelWidth, kernelHeight)
    return blur(image, kernel; pixelFormat)
end