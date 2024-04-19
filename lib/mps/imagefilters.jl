###############################
# Morphological Image Filters #
###############################

# The following two filter definitions are defined with the MPSImageBox-like filters
@objcwrapper immutable=false MPSImageAreaMax <: MPSUnaryImageKernel
@objcwrapper immutable=false MPSImageAreaMin <: MPSImageAreaMax

# Also defines MPSImageAreaMin properties
@objcproperties MPSImageAreaMax begin
    @autoproperty kernelHeight::Int
    @autoproperty kernelWidth::Int
end


@objcwrapper immutable=false MPSImageDilate <: MPSUnaryImageKernel
@objcwrapper immutable=false MPSImageErode <: MPSImageDilate

# Also defines MPSImageErode properties
@objcproperties MPSImageDilate begin
    @autoproperty kernelHeight::Int
    @autoproperty kernelWidth::Int
end

for filt in (:MPSImageDilate, :MPSImageErode)
    @eval begin
        $(filt)(device::MTLDevice, kernelWidth::Integer, kernelHeight::Integer, values::AbstractMatrix{Float32}) =
            $(filt)(device, kernelWidth, kernelHeight, view(values,:))
        function $(filt)(device::MTLDevice, kernelWidth::Integer, kernelHeight::Integer, values::AbstractVector{Float32})
            _check_kernel_size(kernelHeight, kernelWidth)
            kernel = @objc [$(filt) alloc]::id{$(filt)}
            obj = $(filt)(kernel)
            finalizer(release, obj)
            @objc [obj::id{$(filt)} initWithDevice:device::id{MTLDevice}
                                        kernelWidth:kernelWidth::Int
                                        kernelHeight:kernelHeight::Int
                                        values:values::Vector{Float32}]::id{$(filt)}
            return obj
        end
    end
end

#############################
# Convolution Image Filters #
#############################

@objcwrapper immutable=false MPSImageConvolution <: MPSUnaryImageKernel

@objcproperties MPSImageConvolution begin
    @autoproperty kernelHeight::Int
    @autoproperty kernelWidth::Int
    @autoproperty bias::Float32
end

MPSImageConvolution(device::MTLDevice, kernelWidth::Integer, kernelHeight::Integer, weights::AbstractMatrix{Float32}) =
    MPSImageConvolution(device, kernelWidth, kernelHeight, view(weights,:))
function MPSImageConvolution(device::MTLDevice, kernelWidth::Integer, kernelHeight::Integer, weights::AbstractVector{Float32})
    _check_kernel_size(kernelHeight, kernelWidth)
    kernel = @objc [MPSImageConvolution alloc]::id{MPSImageConvolution}
    obj = MPSImageConvolution(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSImageConvolution} initWithDevice:device::id{MTLDevice}
                                kernelWidth:kernelWidth::Int
                                kernelHeight:kernelHeight::Int
                                weights:weights::Vector{Float32}]::id{MPSImageConvolution}
    return obj
end

@objcwrapper immutable=false MPSImageMedian <: MPSUnaryImageKernel

@objcproperties MPSImageMedian begin
    @autoproperty kernelDiameter::Int
end

function MPSImageMedian(device::MTLDevice, kernelDiameter::Integer)
    _check_kernel_diameter(kernelDiameter)
    kernel = @objc [MPSImageMedian alloc]::id{MPSImageMedian}
    obj = MPSImageMedian(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSImageMedian} initWithDevice:device::id{MTLDevice}
                                kernelDiameter:kernelDiameter::Int]::id{MPSImageMedian}
    return obj
end
maxKernelDiameter() = @objc [MPSImageMedian maxKernelDiameter]::Int
minKernelDiameter() = @objc [MPSImageMedian minKernelDiameter]::Int


@objcwrapper immutable=false MPSImageBox <: MPSUnaryImageKernel
@objcwrapper immutable=false MPSImageTent <: MPSImageBox
for filt in (:MPSImageBox, :MPSImageTent, :MPSImageAreaMin, :MPSImageAreaMax)
    @eval begin
        function $(filt)(device::MTLDevice, kernelWidth::Integer, kernelHeight::Integer)
            _check_kernel_size(kernelHeight, kernelWidth)
            kernel = @objc [$(filt) alloc]::id{$(filt)}
            obj = $(filt)(kernel)
            finalizer(release, obj)
            @objc [obj::id{$(filt)} initWithDevice:device::id{MTLDevice}
                                        kernelWidth:kernelWidth::Int
                                        kernelHeight:kernelHeight::Int]::id{$(filt)}
            return obj
        end
    end
end

@objcwrapper immutable=false MPSImageGaussianBlur <: MPSUnaryImageKernel

function MPSImageGaussianBlur(device::MTLDevice, sigma::Real)
    kernel = @objc [MPSImageGaussianBlur alloc]::id{MPSImageGaussianBlur}
    obj = MPSImageGaussianBlur(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSImageGaussianBlur} initWithDevice:device::id{MTLDevice}
                                  sigma:sigma::Float32]::id{MPSImageGaussianBlur}
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

############################################
# High-level functions for image filtering #
############################################

function unaryfilter(kernel, image; pixelFormat=MTL.MTLPixelFormatRGBA8Unorm, async=false)
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
    kernel = MPSImageGaussianBlur(current_device(), sigma)
    return unaryfilter(kernel, image; kwargs...)
end

function boxblur(image, kernelWidth, kernelHeight; kwargs...)
    kernel = MPSImageBox(current_device(), kernelWidth, kernelHeight)
    return unaryfilter(kernel, image; kwargs...)
end
