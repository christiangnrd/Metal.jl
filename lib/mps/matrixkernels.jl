
# @objcwrapper immutable=false MPSMatrixSum <: MPSKernel

function MPSMatrixSum(device, count, rows, columns, transpose)
    kernel = @objc [MPSMatrixSum alloc]::id{MPSMatrixSum}
    obj = MPSMatrixSum(kernel)
    finalizer(release, obj)
    @objc [obj::id{MPSMatrixSum} initWithDevice:device::id{MTLDevice}
                                            count:count::NSUInteger
                                            rows:rows::NSUInteger
                                            columns:columns::NSUInteger
                                            transpose:transpose::Bool]::id{MPSMatrixSum}
    return obj
end

function encode!(cmdbuf::MTLCommandBuffer, matsum::MPSMatrixSum, sourceMatrices, resultMatrix; scaleVector=nil, offsetVector=nil, biasVector=nil, startIndex=0)
    @objc [matsum::id{MPSMatrixSum} encodeToCommandBuffer:cmdbuf::id{MTLCommandBuffer}
                                    sourceMatrices:sourceMatrices::id{NSArray}
                                    resultMatrix:resultMatrix::id{MPSMatrix}
                                    scaleVector:scaleVector::id{MPSVector}
                                    offsetVector:offsetVector::id{MPSVector}
                                    biasVector:biasVector::id{MPSVector}
                                    startIndex:startIndex::NSUInteger]::Nothing
end

function pointwisesum(mtlmat1, mtlmat2)
    mpsmat1 = MPSMatrix(mtlmat1)
    mpsmat2 = MPSMatrix(mtlmat2)

    mtlres = Metal.zeros(eltype(mtlmat1),size(mtlmat1); storage=Metal.storagemode(mtlmat1))
    mpsres = MPSMatrix(mtlres)

    columns,rows = size(mtlres)

    mat_sum_kernel = MPSMatrixSum(current_device(),
                                  2,
                                  rows,
                                  columns,
                                  false)


    # Encode and commit matmul kernel
    cmdbuf = MTLCommandBuffer(global_queue(current_device()))
    encode!(cmdbuf, mat_sum_kernel, NSArray([mpsmat1, mpsmat2]), mpsres.ptr;)
    commit!(cmdbuf)

    return mtlres
end
