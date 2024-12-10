
# @objcwrapper immutable=false MPSNNReduceUnary <: MPSCNNKernel

function MPSNNReduceUnary(device)
    kernel = @objc [MPSNNReduceUnary alloc]::id{MPSNNReduceUnary}
    obj = MPSNNReduceUnary(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSNNReduceUnary} initWithDevice:device::id{MTLDevice}]::id{MPSNNReduceUnary}
    return obj
end

function encode!(cmdbuf::MTLCommandBuffer, kernel::K, sourceTexture, destinationTexture) where {K<:MPSNNReduceUnary}
    @objc [kernel::id{K} encodeToCommandBuffer:cmdbuf::id{MTLCommandBuffer}
                                     sourceTexture:sourceTexture::id{MTLTexture}
                                     destinationTexture:destinationTexture::id{MTLTexture}]::Nothing
end

# Implement Unary MPSNNReduce kernels
for dim in (:Row, :Column, :FeatureChannels, :FeatureChannelsArgument), func in (:Max, :Min, :Sum, :Mean)
    # MPSNNReduceFeatureChannelsArgumentSum and MPSNNReduceFeatureChannelsArgumentMean don't exist
    dim == :FeatureChannelsArgument && (func == :Sum || func == :Mean) && continue

    fullfunc = Symbol(:MPSNNReduce, dim, func)
    @eval begin
        function $(fullfunc)(device)
            kernel = @objc [$(fullfunc) alloc]::id{$(fullfunc)}
            obj = $(fullfunc)(kernel)
            finalizer(release, obj)
            @objc [obj::id{$(fullfunc)} initWithDevice:device::id{MTLDevice}]::id{$(fullfunc)}
            return obj
        end
    end
end
