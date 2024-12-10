
# @objcwrapper immutable=false MPSNNNeuronDescriptor <: NSObject

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
