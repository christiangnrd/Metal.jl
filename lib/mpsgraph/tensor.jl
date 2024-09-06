# Contains definitions for api from MPSGraphTensor.h, MPSGraphTensorData.h, MPSGraphOperation.h

## MPSGraphTensor.h
@objcwrapper MPSGraphTensor <: MPSGraphObject

# Define MPSGraphOperation here to define the MPSGraphTensor properties
@objcwrapper MPSGraphOperation <: MPSGraphObject

@objcproperties MPSGraphOperation begin
    @autoproperty inputTensors::id{NSArray}#{id{MPSGraphTensor}}}
    @autoproperty outputTensors::id{NSArray}#{id{MPSGraphTensor}}}
    @autoproperty controlDependencies::id{NSArray}#{id{MPSGraphOperation}}}
    @autoproperty graph::id{Graph};
    @autoproperty name::String;
end

@objcproperties MPSGraphTensor begin
    # @autoproperty shape::id{MPSShape} # Not doable yet as MPSShape is NSArray of NSNumber
    @autoproperty dataType::MPSDataType
    @autoproperty operation::id{MPSGraphOperation}
end

## MPSGraphTensorData.h
@objcwrapper MPSGraphTensorData <: MPSGraphObject

@objcproperties MPSGraphTensorData begin
    # @autoproperty shape::id{MPSShape} # Not doable yet as MPSShape is NSArray of NSNumber
    @autoproperty dataType::MPSDataType
    @autoproperty device::id{MTLDevice}
end

# MPSShape not defined
# function MPSGraphTensorData(buffer::MTLBuffer, shape::MPSShape, dataType::MPSDataType)
#     obj = @objc [MPSGraphTensorData initWithMTLBuffer:buffer::id{MTLDevice}
#                                     shape:shape::id{MPSShape}
#                                     dataType:dataType::MPSDataType]::id{MPSGraphTensorData}
#     MPSGraphTensorData(obj)
# end
# function MPSGraphTensorData(buffer::MTLBuffer, shape::MPSShape, dataType::MPSDataType, rowBytes)
#     obj = @objc [MPSGraphTensorData initWithMTLBuffer:buffer::id{MTLDevice}
#                                     shape:shape::id{MPSShape}
#                                     dataType:dataType::MPSDataType
#                                     rowBytes:rowBytes::NSUInteger]::id{MPSGraphTensorData}
#     MPSGraphTensorData(obj)
# end

function MPSGraphTensorData(matrix::MPSMatrix)
    obj = @objc [MPSGraphTensorData initWithMPSMatrix:matrix::id{MPSMatrix}]::id{MPSGraphTensorData}
    MPSGraphTensorData(obj)
end

# rank must be between 1 and 16 inclusive
function MPSGraphTensorData(matrix::MPSMatrix, rank)
    obj = @objc [MPSGraphTensorData initWithMPSMatrix:matrix::id{MPSMatrix}
                                    rank:rank::NSUInteger]::id{MPSGraphTensorData}
    MPSGraphTensorData(obj)
end

function MPSGraphTensorData(vector::MPSVector)
    obj = @objc [MPSGraphTensorData initWithMPSMatrix:vector::id{MPSMatrix}]::id{MPSGraphTensorData}
    MPSGraphTensorData(obj)
end

# rank must be between 1 and 16 inclusive
function MPSGraphTensorData(vector::MPSVector, rank)
    obj = @objc [MPSGraphTensorData initWithMPSMatrix:vector::id{MPSVector}
                                    rank:rank::NSUInteger]::id{MPSGraphTensorData}
    MPSGraphTensorData(obj)
end

# Not yet implemented
# function MPSGraphTensorData(ndarr::MPSNDArray)
#     obj = @objc [MPSGraphTensorData initWithMPSNDArray:ndarr::id{MPSNDArray}]::id{MPSGraphTensorData}
#     MPSGraphTensorData(obj)
# end
# function MPSGraphTensorData(imgbatch::MPSImageBatch)
#     obj = @objc [MPSGraphTensorData initWithMPSImageBatch:imgbatch::id{MPSImageBatch}]::id{MPSGraphTensorData}
#     MPSGraphTensorData(obj)
# end
