@objcwrapper immutable=false MPSCNNKernel <: MPSKernel

# @objcproperties MPSCNNKernel begin
#     @autoproperty offset::MPSOffset
#     @autoproperty clipRect::MTLRegion
#     @autoproperty destinationFeatureChannelOffset::NSUInteger
#     @autoproperty edgeMode::MPSImageEdgeMode
#     # More properties
# end

function MPSCNNKernel(device)
    kernel = @objc [MPSCNNKernel alloc]::id{MPSCNNKernel}
    obj = MPSCNNKernel(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSCNNKernel} initWithDevice:device::id{MTLDevice}]::id{MPSCNNKernel}
    return obj
end
# function MPSCNNKernel(aDecoder, device)
# kernel = @objc [MPSCNNKernel alloc]::id{MPSCNNKernel}
#     obj = MPSCNNKernel(kernel)
#     finalizer(release, obj)
#     @objc [obj::id{MPSCNNKernel} initWithCoder:Ptr(aDecoder)::Ptr{NSCoder}
#                                     device:device::id{MTLDevice}]::id{MPSCNNKernel}

#     obj = MPSCNNKernel(kernel)
#     finalizer(release, obj)
#     return obj
# end

@cenum MPSCNNNeuronType::Int32 begin
    MPSCNNNeuronTypeNone        = 0
    MPSCNNNeuronTypeReLU        = 1
    MPSCNNNeuronTypeLinear      = 2
    MPSCNNNeuronTypeSigmoid     = 3
    MPSCNNNeuronTypeHardSigmoid = 4
    MPSCNNNeuronTypeTanH        = 5
    MPSCNNNeuronTypeAbsolute    = 6
    MPSCNNNeuronTypeSoftPlus    = 7
    MPSCNNNeuronTypeSodtSign    = 8
    MPSCNNNeuronTypeELU         = 9
    MPSCNNNeuronTypeCount       = 16
    MPSCNNNeuronTypeExponential = 13
    MPSCNNNeuronTypeGeLU        = 15
    MPSCNNNeuronTypeLogarithm   = 14
    MPSCNNNeuronTypePReLU       = 10
    MPSCNNNeuronTypePower       = 12
    MPSCNNNeuronTypePowerReLUN  = 11
end

@objcwrapper immutable=false MPSNNNeuronDescriptor <: NSObject

@objcproperties MPSNNNeuronDescriptor begin
    @autoproperty a::Float32
    @autoproperty b::Float32
    @autoproperty c::Float32
    # @autoproperty data::Ptr{NSData}
    @autoproperty neuronType::MPSCNNNeuronType
end
function MPSNNNeuronDescriptor(neuronType)
    desc = @objc [MPSNNNeuronDescriptor cnnNeuronDescriptorWithType:neuronType::MPSCNNNeuronType]::id{MPSNNNeuronDescriptor}

    obj = MPSNNNeuronDescriptor(desc)
    finalizer(release, obj)
    return obj
end
function MPSNNNeuronDescriptor(neuronType, a)
    desc = @objc [MPSNNNeuronDescriptor cnnNeuronDescriptorWithType:neuronType::MPSCNNNeuronType
                                    a:a::Float32]::id{MPSNNNeuronDescriptor}

    obj = MPSNNNeuronDescriptor(desc)
    finalizer(release, obj)
    return obj
end
function MPSNNNeuronDescriptor(neuronType, a, b)
    desc = @objc [MPSNNNeuronDescriptor cnnNeuronDescriptorWithType:neuronType::MPSCNNNeuronType
                                    a:a::Float32
                                    b:b::Float32]::id{MPSNNNeuronDescriptor}

    obj = MPSNNNeuronDescriptor(desc)
    finalizer(release, obj)
    return obj
end
function MPSNNNeuronDescriptor(neuronType, a, b, c)
    desc = @objc [MPSNNNeuronDescriptor cnnNeuronDescriptorWithType:neuronType::MPSCNNNeuronType
                                    a:a::Float32
                                    b:b::Float32
                                    c:c::Float32]::id{MPSNNNeuronDescriptor}

    obj = MPSNNNeuronDescriptor(desc)
    finalizer(release, obj)
    return obj
end

# Missing PRelu MPSNNNeuronDescriptor constructor

@objcwrapper immutable=false MPSCNNNeuron <: MPSCNNKernel

# @objcproperties MPSCNNNeuron begin
#     @autoproperty a::Float32
#     @autoproperty b::Float32
#     @autoproperty c::Float32
#     # @autoproperty data::Ptr{NSData}
#     @autoproperty neuronType::MPSCNNNeuronType
# end
function MPSCNNNeuron(device, neuronDescriptor)
    kernel = @objc [MPSCNNNeuron alloc]::id{MPSCNNNeuron}
    obj = MPSCNNNeuron(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSCNNNeuron} initWithDevice:device::id{MTLDevice}
                                neuronDescriptor:neuronDescriptor::id{MPSNNNeuronDescriptor}]::id{MPSCNNNeuron}
    return obj
end

@objcwrapper immutable=false MPSCNNConvolutionDescriptor <: NSObject

# @objcproperties MPSCNNConvolutionDescriptor begin
#     @autoproperty a::Float32
#     @autoproperty b::Float32
#     @autoproperty c::Float32
#     # @autoproperty data::Ptr{NSData}
#     @autoproperty neuronType::MPSCNNNeuronType
# end
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

@objcwrapper immutable=false MPSCNNConvolution <: MPSCNNKernel

# @objcproperties MPSCNNConvolution begin
#     @autoproperty offset::MPSOffset
#     @autoproperty clipRect::MTLRegion
#     @autoproperty destinationFeatureChannelOffset::NSUInteger
#     @autoproperty edgeMode::MPSImageEdgeMode
#     # More properties
# end

function MPSCNNConvolution(device)
    kernel = @objc [MPSCNNConvolution alloc]::id{MPSCNNConvolution}
    obj = MPSCNNConvolution(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSCNNConvolution} initWithDevice:device::id{MTLDevice}]::id{MPSCNNConvolution}
    return obj
end