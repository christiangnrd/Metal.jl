# Contains all enum definitions for MPSGraph
@cenum MPSGraphTensorNamedDataLayout::NSUInteger begin
    MPSGraphTensorNamedDataLayoutNCHW  =  0
    MPSGraphTensorNamedDataLayoutNHWC  =  1
    MPSGraphTensorNamedDataLayoutOIHW  =  2
    MPSGraphTensorNamedDataLayoutHWIO  =  3
    MPSGraphTensorNamedDataLayoutCHW   =  4
    MPSGraphTensorNamedDataLayoutHWC   =  5
    MPSGraphTensorNamedDataLayoutHW    =  6
    MPSGraphTensorNamedDataLayoutNCDHW =  7
    MPSGraphTensorNamedDataLayoutNDHWC =  8
    MPSGraphTensorNamedDataLayoutOIDHW =  9
    MPSGraphTensorNamedDataLayoutDHWIO =  10
end

@cenum MPSGraphPaddingStyle::NSUInteger begin
        MPSGraphPaddingStyleExplicit        = 0
        MPSGraphPaddingStyleTF_VALID        = 1
        MPSGraphPaddingStyleTF_SAME         = 2
        MPSGraphPaddingStyleExplicitOffset  = 3
        MPSGraphPaddingStyleONNX_SAME_LOWER = 4
end

@cenum MPSGraphPaddingMode::NSInteger begin
        MPSGraphPaddingModeConstant     = 0
        MPSGraphPaddingModeReflect      = 1
        MPSGraphPaddingModeSymmetric    = 2
        MPSGraphPaddingModeClampToEdge  = 3
        MPSGraphPaddingModeZero         = 4
        MPSGraphPaddingModePeriodic     = 5
        MPSGraphPaddingModeAntiPeriodic = 6
end

@cenum MPSGraphReductionMode::NSUInteger begin
        MPSGraphReductionModeMin         = 0
        MPSGraphReductionModeMax         = 1
        MPSGraphReductionModeSum         = 2
        MPSGraphReductionModeProduct     = 3
        MPSGraphReductionModeArgumentMin = 4
        MPSGraphReductionModeArgumentMax = 5
end

@cenum MPSGraphDeviceType::UInt32 begin
    MPSGraphDeviceTypeMetal = 0
end

@cenum MPSGraphOptions::UInt64 begin
    MPSGraphOptionsNone               = 0
    MPSGraphOptionsSynchronizeResults = 1
    MPSGraphOptionsVerbose            = 2
    MPSGraphOptionsDefault            = 1 # MPSGraphOptionsSynchronizeResults
end

@cenum MPSGraphOptimization::UInt64 begin
    MPSGraphOptimizationLevel0 = 0
    MPSGraphOptimizationLevel1 = 1
end

@cenum MPSGraphOptimizationProfile::UInt64 begin
    MPSGraphOptimizationProfilePerformance     = 0
    MPSGraphOptimizationProfilePowerEfficiency = 1
end

@cenum MPSGraphExecutionStage::UInt64 begin
    MPSGraphExecutionStageCompleted = 0
end

@cenum MPSGraphDeploymentPlatform::UInt64 begin
    MPSGraphDeploymentPlatformMacOS    = 0
    MPSGraphDeploymentPlatformIOS      = 1
    MPSGraphDeploymentPlatformTvOS     = 2
    MPSGraphDeploymentPlatformVisionOS = 3
end

##VERIFY
@cenum MPSGraphFFTScalingMode::NSUInteger begin
    MPSGraphFFTScalingModeNone    = 0
    MPSGraphFFTScalingModeSize    = 1
    MPSGraphFFTScalingModeUnitary = 2
end

@cenum MPSGraphLossReductionType::UInt64 begin
    MPSGraphLossReductionTypeNone = 0
    MPSGraphLossReductionTypeAxis = 0 # MPSGraphLossReductionTypeNone
    MPSGraphLossReductionTypeSum  = 1
    MPSGraphLossReductionTypeMean = 2
end

@cenum MPSGraphNonMaximumSuppressionCoordinateMode::NSUInteger begin
    MPSGraphNonMaximumSuppressionCoordinateModeCornersHeightFirst = 0
    MPSGraphNonMaximumSuppressionCoordinateModeCornersWidthFirst  = 1
    MPSGraphNonMaximumSuppressionCoordinateModeCentersHeightFirst = 2
    MPSGraphNonMaximumSuppressionCoordinateModeCentersWidthFirst  = 3
end

#VERIFY
@cenum MPSGraphPoolingReturnIndicesMode::NSUInteger begin
    MPSGraphPoolingReturnIndicesNone            = 0
    MPSGraphPoolingReturnIndicesGlobalFlatten1D = 1
    MPSGraphPoolingReturnIndicesGlobalFlatten2D = 2
    MPSGraphPoolingReturnIndicesGlobalFlatten3D = 3
    MPSGraphPoolingReturnIndicesGlobalFlatten4D = 4
    MPSGraphPoolingReturnIndicesLocalFlatten1D  = 5
    MPSGraphPoolingReturnIndicesLocalFlatten2D  = 6
    MPSGraphPoolingReturnIndicesLocalFlatten3D  = 7
    MPSGraphPoolingReturnIndicesLocalFlatten4D  = 8
end

@cenum MPSGraphRandomDistribution::UInt64 begin
    MPSGraphRandomDistributionUniform         = 0
    MPSGraphRandomDistributionNormal          = 1
    MPSGraphRandomDistributionTruncatedNormal = 2
end

@cenum MPSGraphRandomNormalSamplingMethod::UInt64 begin
    MPSGraphRandomNormalSamplingInvCDF    = 0
    MPSGraphRandomNormalSamplingBoxMuller = 1
end

@cenum MPSGraphResizeMode::NSUInteger begin
    MPSGraphResizeNearest  = 0
    MPSGraphResizeBilinear = 1
end

@cenum MPSGraphResizeNearestRoundingMode::NSUInteger begin
    MPSGraphResizeNearestRoundingModeRoundPreferCeil  = 0
    MPSGraphResizeNearestRoundingModeRoundPreferFloor = 1
    MPSGraphResizeNearestRoundingModeCeil             = 2
    MPSGraphResizeNearestRoundingModeFloor            = 3
    MPSGraphResizeNearestRoundingModeRoundToEven      = 4
    MPSGraphResizeNearestRoundingModeRoundToOdd       = 5
end

@cenum MPSGraphRNNActivation::NSUInteger begin
    MPSGraphRNNActivationNone        = 0
    MPSGraphRNNActivationRelu        = 1
    MPSGraphRNNActivationTanh        = 2
    MPSGraphRNNActivationSigmoid     = 3
    MPSGraphRNNActivationHardSigmoid = 4
end

@cenum MPSGraphScatterMode::NSInteger begin
    MPSGraphScatterModeAdd = 0
    MPSGraphScatterModeSub = 1
    MPSGraphScatterModeMul = 2
    MPSGraphScatterModeDiv = 3
    MPSGraphScatterModeMin = 4
    MPSGraphScatterModeMax = 5
    MPSGraphScatterModeSet = 6
end

@cenum MPSGraphSparseStorageType::UInt64 begin
    MPSGraphSparseStorageCOO = 0
    MPSGraphSparseStorageCSC = 1
    MPSGraphSparseStorageCSR = 2
end
