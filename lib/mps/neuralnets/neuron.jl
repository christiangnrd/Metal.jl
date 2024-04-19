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
    @autoproperty a::Float32 setter=setA
    @autoproperty b::Float32 setter=setB
    @autoproperty c::Float32 setter=setC
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
