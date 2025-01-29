function graph_matmul!(c::MtlArray{T1,N}, a::MtlArray{T2,N}, b::MtlArray{T3,N}, alpha::Number=true, beta::Number=false, transpose_a=false, transpose_b=false) where {T1, T2, T3, N}
    graph = MPSGraph()

    placeA = placeholderTensor(graph, reverse(UInt.(size(a))), T2)
    placeB = placeholderTensor(graph, reverse(UInt.(size(b))), T3)

    transA = if transpose_a
        transposeTensor(graph, placeA, 0, 1)
    else
        placeA
    end

    transB = if transpose_b
        transposeTensor(graph, placeB, 0, 1)
    else
        placeB
    end

    matmul = matrixMultiplicationWithPrimaryTensor(graph,transB,transA)

    afteralpha = if alpha == 1
        matmul
    else
        alphatensor = constantWithScalar(graph, alpha, T1)
        multiplicationWithPrimaryTensor(graph,alphatensor,matmul)
    end

    feed = Dict(
        placeA => MPSGraphTensorData(a),
        placeB => MPSGraphTensorData(b)
    )



    afterbeta = if beta == 0
        afteralpha
    else
        placeC = placeholderTensor(graph, reverse(UInt.(size(c))), T1)
        feed[placeC] = MPSGraphTensorData(c)
        betatensor = constantWithScalar(graph, beta, T1)
        betaC = multiplicationWithPrimaryTensor(graph,betatensor,placeC)
        additionWithPrimaryTensor(graph, afteralpha, betaC)
    end

    res = run(graph, feed, [afterbeta])
    resultdata = only(Dict{MPSGraphTensor,MPSGraphTensorData}(res)).second
    return exportToMtlArray!(c, MPSNDArray(resultdata))
end

function graph_matvecmul!(c::MtlVector{T1}, a::MtlMatrix{T2}, b::MtlVector{T3}, alpha::Number=true, beta::Number=false, transpose=false) where {T1, T2, T3}
    graph = MPSGraph()

    placeA = placeholderTensor(graph, reverse(UInt.(size(a))), T2)
    placeB = placeholderTensor(graph, reverse(UInt.(size(b))), T3)

    transA = if !transpose
        transposeTensor(graph, placeA, 0, 1)
    else
        placeA
    end


    matmul = matrixMultiplicationWithPrimaryTensor(graph,transA,placeB)

    afteralpha = if alpha == 1
        matmul
    else
        alphatensor = constantWithScalar(graph, alpha, T1)
        multiplicationWithPrimaryTensor(graph,alphatensor,matmul)
    end

    feed = Dict(
        placeA => MPSGraphTensorData(a),
        placeB => MPSGraphTensorData(b)
    )

    afterbeta = if beta == 0
        afteralpha
    else
        placeC = placeholderTensor(graph, reverse(UInt.(size(c))), T1)
        feed[placeC] = MPSGraphTensorData(c)
        betatensor = constantWithScalar(graph, beta, T1)
        betaC = multiplicationWithPrimaryTensor(graph,betatensor,placeC)
        additionWithPrimaryTensor(graph, afteralpha, betaC)
    end

    res = run(graph, feed, [afterbeta])
    resultdata = only(Dict{MPSGraphTensor,MPSGraphTensorData}(res)).second
    return exportToMtlArray!(c, MPSNDArray(resultdata))
end