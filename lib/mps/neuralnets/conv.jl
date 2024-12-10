# @objcwrapper immutable=false MPSCNNKernel <: MPSKernel

function MPSCNNKernel(device)
    kernel = @objc [MPSCNNKernel alloc]::id{MPSCNNKernel}
    obj = MPSCNNKernel(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSCNNKernel} initWithDevice:device::id{MTLDevice}]::id{MPSCNNKernel}
    return obj
end

function encode!(cmdbuf::MTLCommandBuffer, kernel::K, sourceTexture, destinationTexture) where {K<:MPSCNNKernel}
    @objc [kernel::id{K} encodeToCommandBuffer:cmdbuf::id{MTLCommandBuffer}
                                     sourceTexture:sourceTexture::id{MTLTexture}
                                     destinationTexture:destinationTexture::id{MTLTexture}]::Nothing
end

# Missing PRelu MPSNNNeuronDescriptor constructor

# @objcwrapper immutable=false MPSCNNNeuron <: MPSCNNKernel

function MPSCNNNeuron(device, neuronDescriptor)
    kernel = @objc [MPSCNNNeuron alloc]::id{MPSCNNNeuron}
    obj = MPSCNNNeuron(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSCNNNeuron} initWithDevice:device::id{MTLDevice}
                                neuronDescriptor:neuronDescriptor::id{MPSNNNeuronDescriptor}]::id{MPSCNNNeuron}
    return obj
end

# @objcwrapper immutable=false MPSCNNConvolutionDescriptor <: NSObject

function MPSCNNConvolutionDescriptor(kernelWidth, kernelHeight, inputFeatureChannels, outputFeatureChannels)
    desc = @objc [MPSCNNConvolutionDescriptor cnnConvolutionDescriptorWithKernelWidth:kernelWidth::NSUInteger
                                                    kernelHeight:kernelHeight::NSUInteger
                                                    inputFeatureChannels:inputFeatureChannels::NSUInteger
                                                    outputFeatureChannels:outputFeatureChannels::NSUInteger]::id{MPSCNNConvolutionDescriptor}
    obj = MPSCNNConvolutionDescriptor(desc)
    finalizer(release, obj)
    return obj
end
function MPSCNNConvolutionDescriptor(kernelWidth, kernelHeight, inputFeatureChannels, outputFeatureChannels, neuronFilter)
    desc = @objc [MPSCNNConvolutionDescriptor cnnConvolutionDescriptorWithKernelWidth:kernelWidth::NSUInteger
                                                    kernelHeight:kernelHeight::NSUInteger
                                                    inputFeatureChannels:inputFeatureChannels::NSUInteger
                                                    outputFeatureChannels:outputFeatureChannels::NSUInteger
                                                    neuronFilter:neuronFilter::id{MPSCNNNeuron}]::id{MPSCNNConvolutionDescriptor}
    obj = MPSCNNConvolutionDescriptor(desc)
    finalizer(release, obj)
    return obj
end

# @objcwrapper immutable=false MPSCNNConvolution <: MPSCNNKernel

function MPSCNNConvolution(device)
    kernel = @objc [MPSCNNConvolution alloc]::id{MPSCNNConvolution}
    obj = MPSCNNConvolution(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSCNNConvolution} initWithDevice:device::id{MTLDevice}]::id{MPSCNNConvolution}
    return obj
end

#########################
### XXX:Testing stuff ###
#########################

function testMPSCNNKernel(kernel::K, image, pixelFormat) where K<:MPSCNNKernel

    res = copy(image)

    h,w = size(image)

    alignment = MTL.minimumLinearTextureAlignmentForPixelFormat(current_device(), pixelFormat)
    preBytesPerRow = sizeof(eltype(image))*w

    rowoffset = alignment - (preBytesPerRow - 1) % alignment - 1
    bytesPerRow = preBytesPerRow + rowoffset
    offset = (rowoffset * h) % bytesPerRow

    @show Int(alignment)
    @show Int(preBytesPerRow)
    @show Int(rowoffset)
    @show Int(bytesPerRow)
    @show Int(offset)

    textDesc1 = MTLTextureDescriptor(pixelFormat, w, h)
    textDesc1.usage = MTL.MTLTextureUsageShaderRead | MTL.MTLTextureUsageShaderWrite
    text1 = MTL.MTLTexture(image.data.rc.obj, textDesc1, 0, bytesPerRow)
    img1 = MPSImage(text1, 4)

    textDesc2 = MTLTextureDescriptor(pixelFormat, w, h)
    textDesc2.usage = MTL.MTLTextureUsageShaderRead | MTL.MTLTextureUsageShaderWrite
    text2 = MTL.MTLTexture(res.data.rc.obj, textDesc2, 0, bytesPerRow)
    img2 = MPSImage(text2, 4)

    cmdbuf = MTLCommandBuffer(global_queue(current_device()))
    # encode!(cmdbuf, kernel, text1)
    # encode!(cmdbuf, kernel, img1, img2)
    @objc [kernel::id{K} encodeToCommandBuffer:cmdbuf::id{MTLCommandBuffer}
                                     sourceImage:img1::id{MPSImage}
                                     destinationImage:img2::id{MPSImage}]::Nothing
    commit!(cmdbuf)
    synchronize()
    return res
end
