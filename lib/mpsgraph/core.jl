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
    @autoproperty metalDevice::id{MTLDevice}
end

function MPSGraphDevice(device::MTLDevice)
    obj = @objc [MPSGraphDevice deviceWithMTLDevice:device::id{MTLDevice}]::id{MPSGraphDevice}
    MPSGraphDevice(obj)
end
