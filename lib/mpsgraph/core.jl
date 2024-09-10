# Contains definitions for api from MPSGraphCore.h, MPSGraphDevice.h

## MPSGraphCore.h
@objcwrapper MPSGraphObject <: NSObject

@objcwrapper Graph <: MPSGraphObject

@objcwrapper MPSGraphType <: MPSGraphObject

@objcwrapper MPSGraphShapedType <: MPSGraphType

@objcproperties MPSGraphShapedType begin
    # @autoproperty shape::id{MPSShape} setter=setShape # Not doable yet as MPSShape is NSArray of NSNumber
    @autoproperty dataType::MPSDataType setter=setDataType
end

function MPSGraphShapedType(shape::MPSShape)
    tmp = @objc [MPSGraphShapedType alloc]::id{MPSGraphShapedType}
    obj = MPSGraphShapedType(tmp)
    finalizer(release, obj)
    # @objc [MPSGraphShapedType initWithShape:shape::id{MPSShape}
    @objc [obj::id{MPSGraphShapedType} initWithShape:shape::id{MPSShape}
                                       dataType:dataType::MPSDataType]::id{MPSGraphShapedType}

   return obj
end

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
