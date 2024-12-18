@objcwrapper immutable=false MPSGraphRandomOpDescriptor <: MPSGraphObject

@objcproperties MPSGraphRandomOpDescriptor begin
    @autoproperty dataType::MPSDataType
    @autoproperty distribution::MPSGraphRandomDistribution
    @autoproperty max::Float32 setter=setMax
    @autoproperty maxInteger::Int32 setter=setMaxInteger
    @autoproperty mean::Float32 setter=setMean
    @autoproperty min::Float32 setter=setMin
    @autoproperty minInteger::Int32 setter=setMinInteger
    @autoproperty samplingMethod::Float32 setter=setStandardDeviation
    @autoproperty standardDeviation::Float32 setter=setStandardDeviation
end

function MPSMatrixRandomOpDescriptor(distribution::MPSGraphRandomDistribution, dataType::MPSDataType)
    desc = @objc [MPSMatrixRandomOpDescriptor descriptorWithDistribution:distribution::MPSGraphRandomDistribution
                    dataType:dataType::MPSDataType]::id{MPSGraphRandomOpDescriptor}
    obj = MPSGraphRandomOpDescriptor(desc)
    return obj
end
