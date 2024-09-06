# Contains definitions for api from MPSGraphCore.h, MPSGraphDevice.h

## MPSGraphCore.h
@objcwrapper MPSGraphObject <: NSObject

@objcwrapper Graph <: MPSGraphObject

@objcwrapper MPSGraphType <: MPSGraphObject

@objcwrapper MPSGraphShapedType <: MPSGraphType

@objcproperties MPSGraphShapedType begin
    # @autoproperty shape::id{MPSShape} # Not doable yet as MPSShape is NSArray of NSNumber
    @autoproperty dataType::MPSDataType setter=setDataType
end

# function MPSGraphShapedType(shape::MPSShape)
#     TODO
# end

## MPSGraphDevice.h
@objcwrapper MPSGraphDevice <: MPSGraphType

@objcproperties MPSGraphDevice begin
    @autoproperty type::MPSGraphDeviceType
    @autoproperty metalDevice::id{MTLDevice} # Not doable yet as MPSShape is NSArray of NSNumber
end

function MPSGraphDevice(device::MTLDevice)
    dev = @objc [MPSGraphDevice deviceWithMTLDevice:metalDevice::id{MTLDevice}]::id{MPSGraphDevice}
    MPSGraphDevice(dev)
end
