# Contains definitions for api from MPSGraphTensor.h, MPSGraphTensorData.h, MPSGraphOperation.h

## MPSGraphTensor.h
@objcwrapper MPSGraphTensor <: MPSGraphObject

# Define MPSGraphOperation here to define the MPSGraphTensor properties
@objcwrapper MPSGraphOperation <: MPSGraphObject

@objcproperties MPSGraphOperation begin
    @autoproperty inputTensors::id{NSArray}#{id{MPSGraphTensor}}
    @autoproperty outputTensors::id{NSArray}#{id{MPSGraphTensor}}
    @autoproperty controlDependencies::id{NSArray}#{id{MPSGraphOperation}}
    @autoproperty graph::id{MPSGraph};
    @autoproperty name::String;
end

@objcproperties MPSGraphTensor begin
    @autoproperty dataType::MPSDataType
    @autoproperty operation::id{MPSGraphOperation}
    @autoproperty shape::id{MPSShape}
end
function Base.size(td::MPSGraphTensor)
    temp = map(td.shape) do nsnum
        NSNumber(reinterpret(id{NSNumber}, nsnum)).unsignedIntegerValue |> Int
    end
    Tuple(temp)
end

function placeholderTensor(graph::MPSGraph, shape::Union{Vector, Tuple}, args...)
    mpsshape = convert(MPSShape, shape)
    return placeholderTensor(graph, mpsshape, args...)
end
function placeholderTensor(graph::MPSGraph, shape::MPSShape, dataType::Type, name="placeholder tensor")
    obj = @objc [graph::id{MPSGraph} placeholderWithShape:shape::id{MPSShape}
                                dataType:dataType::MPSDataType
                                name:name::id{NSString}]::id{MPSGraphTensor}
    return MPSGraphTensor(obj)
end

## MPSGraphTensorData.h
@objcwrapper immutable=false MPSGraphTensorData <: MPSGraphObject

@objcproperties MPSGraphTensorData begin
    @autoproperty dataType::MPSDataType
    @autoproperty device::id{MPSGraphDevice}
    @autoproperty shape::id{MPSShape}
end
function Base.size(td::MPSGraphTensorData)
    temp = map(td.shape) do nsnum
        NSNumber(reinterpret(id{NSNumber}, nsnum)).unsignedIntegerValue |> Int
    end
    Tuple(temp)
end

function MPSGraphTensorData(buffer::MTLBuffer, shape::MPSShape, dataType)
    obj = @objc [MPSGraphTensorData alloc]::id{MPSGraphTensorData}
    tensor = MPSGraphTensorData(obj)
    finalizer(release, tensor)
    @objc [tensor::id{MPSGraphTensorData} initWithMTLBuffer:buffer::id{MTLBuffer}
                                    shape:shape::id{MPSShape}
                                    dataType:dataType::MPSDataType]::id{MPSGraphTensorData}
    return tensor
end
function MPSGraphTensorData(buffer::MTLBuffer, shape::MPSShape, dataType, rowBytes)
    obj = @objc [MPSGraphTensorData alloc]::id{MPSGraphTensorData}
    tensor = MPSGraphTensorData(obj)
    finalizer(release, tensor)
    @objc [tensor::id{MPSGraphTensorData} initWithMTLBuffer:buffer::id{MTLBuffer}
                                    shape:shape::id{MPSShape}
                                    dataType:dataType::MPSDataType
                                    rowBytes:rowBytes::NSUInteger]::id{MPSGraphTensorData}
    return tensor
end
# MPSGraphTensorData(matrix::MtlMatrix{T}) where T = MPSGraphTensorData(matrix.data[], convert(MPSShape, reverse(size(matrix))), T)
MPSGraphTensorData(matrix::MtlMatrix) = MPSGraphTensorData(MPSMatrix(matrix))

function MPSGraphTensorData(matrix::MPSMatrix)
    obj = @objc [MPSGraphTensorData alloc]::id{MPSGraphTensorData}
    tensor = MPSGraphTensorData(obj)
    finalizer(release, tensor)
    @objc [tensor::id{MPSGraphTensorData} initWithMPSMatrix:matrix::id{MPSMatrix}]::id{MPSGraphTensorData}
    return tensor
end

# rank must be between 1 and 16 inclusive
function MPSGraphTensorData(matrix::MPSMatrix, rank)
    obj = @objc [MPSGraphTensorData alloc]::id{MPSGraphTensorData}
    tensor = MPSGraphTensorData(obj)
    finalizer(release, tensor)
    @objc [tensor::id{MPSGraphTensorData} initWithMPSMatrix:matrix::id{MPSMatrix}
                              rank:rank::NSUInteger]::id{MPSGraphTensorData}
    return tensor
end

function MPSGraphTensorData(vector::MPSVector)
    obj = @objc [MPSGraphTensorData alloc]::id{MPSGraphTensorData}
    tensor = MPSGraphTensorData(obj)
    finalizer(release, tensor)
    @objc [tensor::id{MPSGraphTensorData} initWithMPSVector:vector::id{MPSVector}]::id{MPSGraphTensorData}
    return tensor
end
# MPSGraphTensorData(vector::MtlVector{T}) where T = MPSGraphTensorData(vector.data[], convert(MPSShape, size(vector)), T)
MPSGraphTensorData(vector::MtlVector) = MPSGraphTensorData(MPSVector(vector))

# rank must be between 1 and 16 inclusive
function MPSGraphTensorData(vector::MPSVector, rank)
    obj = @objc [MPSGraphTensorData alloc]::id{MPSGraphTensorData}
    tensor = MPSGraphTensorData(obj)
    finalizer(release, tensor)
    @objc [tensor::id{MPSGraphTensorData} initWithMPSMatrix:vector::id{MPSVector}
                                          rank:rank::NSUInteger]::id{MPSGraphTensorData}
    return tensor
end

function MPSGraphTensorData(ndarr::MPSNDArray)
    obj = @objc [MPSGraphTensorData alloc]::id{MPSGraphTensorData}
    tensor = MPSGraphTensorData(obj)
    finalizer(release, tensor)
    @objc [tensor::id{MPSGraphTensorData} initWithMPSNDArray:ndarr::id{MPSNDArray}]::id{MPSGraphTensorData}
    return tensor
end
# TODO: MPSImage is not yet implemented
# function MPSGraphTensorData(imgbatch::MPSImageBatch)
#     obj = @objc [MPSGraphTensorData alloc]::id{MPSGraphTensorData}
#     tensor = MPSGraphTensorData(obj)
#     finalizer(release, tensor)
#     @objc [tensor::id{MPSGraphTensorData} initWithMPSImageBatch:imgbatch::id{MPSImageBatch}]::id{MPSGraphTensorData}
#     MPSGraphTensorData(obj)
# end

"""
    MPSNDArray(tens::MPSGraphTensorData)

Return an MPSNDArray object.

Will copy contents if the contents are not stored in an MPS ndarray.
"""
function MPS.MPSNDArray(tens::MPSGraphTensorData)
    arr = @objc [tens::id{MPSNDArray} mpsndarray]::id{MPSNDArray}
    MPSNDArray(arr)
end