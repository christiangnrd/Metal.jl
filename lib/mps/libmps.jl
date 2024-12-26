# This file is automatically generated. Do not edit!
# To re-generate, execute res/wrap/wrap.jl

using CEnum: CEnum, @cenum

using .MTL: MTLPixelFormat, MTLTextureType, MTLTextureUsage

@cenum MPSKernelOptions::UInt64 begin
    MPSKernelOptionsNone = 0x0000000000000000
    MPSKernelOptionsSkipAPIValidation = 0x0000000000000001
    MPSKernelOptionsAllowReducedPrecision = 0x0000000000000002
    MPSKernelOptionsDisableInternalTiling = 0x0000000000000004
    MPSKernelOptionsInsertDebugGroups = 0x0000000000000008
    MPSKernelOptionsVerbose = 0x0000000000000010
end

@cenum MPSImageEdgeMode::UInt64 begin
    MPSImageEdgeModeZero = 0x0000000000000000
    MPSImageEdgeModeClamp = 0x0000000000000001
    MPSImageEdgeModeMirror = 0x0000000000000002
    MPSImageEdgeModeMirrorWithEdge = 0x0000000000000003
    MPSImageEdgeModeConstant = 0x0000000000000004
end

@cenum MPSImageFeatureChannelFormat::UInt64 begin
    MPSImageFeatureChannelFormatNone = 0x0000000000000000
    MPSImageFeatureChannelFormatUnorm8 = 0x0000000000000001
    MPSImageFeatureChannelFormatUnorm16 = 0x0000000000000002
    MPSImageFeatureChannelFormatFloat16 = 0x0000000000000003
    MPSImageFeatureChannelFormatFloat32 = 0x0000000000000004
    MPSImageFeatureChannelFormat_reserved0 = 0x0000000000000005
    MPSImageFeatureChannelFormatCount = 0x0000000000000006
end

@cenum MPSFloatDataTypeBit::UInt32 begin
    MPSFloatDataTypeSignBit = 0x0000000000800000
    MPSFloatDataTypeExponentBit = 0x00000000007c0000
    MPSFloatDataTypeMantissaBit = 0x000000000003fc00
end

@cenum MPSFloatDataTypeShift::UInt32 begin
    MPSFloatDataTypeSignShift = 0x0000000000000017
    MPSFloatDataTypeExponentShift = 0x0000000000000012
    MPSFloatDataTypeMantissaShift = 0x000000000000000a
end

@cenum MPSDataType::UInt32 begin
    MPSDataTypeInvalid = 0x0000000000000000
    MPSDataTypeFloatBit = 0x0000000010000000
    MPSDataTypeFloat32 = 0x0000000010000020
    MPSDataTypeFloat16 = 0x0000000010000010
    MPSDataTypeComplexBit = 0x0000000001000000
    MPSDataTypeComplexFloat32 = 0x0000000011000040
    MPSDataTypeComplexFloat16 = 0x0000000011000020
    MPSDataTypeSignedBit = 0x0000000020000000
    MPSDataTypeIntBit = 0x0000000020000000
    MPSDataTypeInt4 = 0x0000000020000004
    MPSDataTypeInt8 = 0x0000000020000008
    MPSDataTypeInt16 = 0x0000000020000010
    MPSDataTypeInt32 = 0x0000000020000020
    MPSDataTypeInt64 = 0x0000000020000040
    MPSDataTypeUInt4 = 0x0000000000000004
    MPSDataTypeUInt8 = 0x0000000000000008
    MPSDataTypeUInt16 = 0x0000000000000010
    MPSDataTypeUInt32 = 0x0000000000000020
    MPSDataTypeUInt64 = 0x0000000000000040
    MPSDataTypeAlternateEncodingBit = 0x0000000080000000
    MPSDataTypeBool = 0x0000000080000008
    MPSDataTypeBFloat16 = 0x0000000090000010
    MPSDataTypeNormalizedBit = 0x0000000040000000
    MPSDataTypeUnorm1 = 0x0000000040000001
    MPSDataTypeUnorm8 = 0x0000000040000008
end

@cenum MPSAliasingStrategy::UInt64 begin
    MPSAliasingStrategyDefault = 0x0000000000000000
    MPSAliasingStrategyDontCare = 0x0000000000000000
    MPSAliasingStrategyShallAlias = 0x0000000000000001
    MPSAliasingStrategyShallNotAlias = 0x0000000000000002
    MPSAliasingStrategyAliasingReserved = 0x0000000000000003
    MPSAliasingStrategyPreferTemporaryMemory = 0x0000000000000004
    MPSAliasingStrategyPreferNonTemporaryMemory = 0x0000000000000008
end

struct MPSOffset
    x::NSInteger
    y::NSInteger
    z::NSInteger
    MPSOffset(x=0, y=0, z=0) = new(x, y, z)
end

struct MPSOrigin
    x::Cdouble
    y::Cdouble
    z::Cdouble
    MPSOrigin(x=0.0, y=0.0, z=0.0) = new(x, y, z)
end

struct MPSSize
    width::Cdouble
    height::Cdouble
    depth::Cdouble
    MPSSize(w=1.0, h=1.0, d=1.0) = new(w, h, d)
end

struct MPSDimensionSlice
    start::NSUInteger
    length::NSUInteger
end

struct MPSRegion
    origin::MPSOrigin
    size::MPSSize
    MPSRegion(origin=MPSOrigin(), size=MPSSize()) = new(origin, size)
end

struct MPSScaleTransform
    scaleX::Cdouble
    scaleY::Cdouble
    translateX::Cdouble
    translateY::Cdouble
end

struct MPSImageCoordinate
    x::NSUInteger
    y::NSUInteger
    channel::NSUInteger
end

struct MPSImageRegion
    offset::MPSImageCoordinate
    size::MPSImageCoordinate
end

@cenum MPSPurgeableState::UInt64 begin
    MPSPurgeableStateAllocationDeferred = 0x0000000000000000
    MPSPurgeableStateKeepCurrent = 0x0000000000000001
    MPSPurgeableStateNonVolatile = 0x0000000000000002
    MPSPurgeableStateVolatile = 0x0000000000000003
    MPSPurgeableStateEmpty = 0x0000000000000004
end

@cenum MPSDataLayout::UInt64 begin
    MPSDataLayoutHeightxWidthxFeatureChannels = 0x0000000000000000
    MPSDataLayoutFeatureChannelsxHeightxWidth = 0x0000000000000001
end

struct MPSImageReadWriteParams
    featureChannelOffset::NSUInteger
    numberOfFeatureChannelsToReadWrite::NSUInteger
end

struct MPSStateTextureInfo
    width::NSUInteger
    height::NSUInteger
    depth::NSUInteger
    arrayLength::NSUInteger
    pixelFormat::MTLPixelFormat
    textureType::MTLTextureType
    usage::MTLTextureUsage
    _reserved::NTuple{4,NSUInteger}
end

@cenum MPSStateResourceType::UInt64 begin
    MPSStateResourceTypeNone = 0x0000000000000000
    MPSStateResourceTypeBuffer = 0x0000000000000001
    MPSStateResourceTypeTexture = 0x0000000000000002
end

@cenum MPSDeviceCapsValues::UInt32 begin
    MPSDeviceCapsNull = 0x0000000000000000
    MPSDeviceSupportsReadableArrayOfTextures = 0x0000000000000001
    MPSDeviceSupportsWritableArrayOfTextures = 0x0000000000000002
    MPSDeviceSupportsReadWriteTextures = 0x0000000000000004
    MPSDeviceSupportsSimdgroupBarrier = 0x0000000000000008
    MPSDeviceSupportsQuadShuffle = 0x0000000000000010
    MPSDeviceSupportsSimdShuffle = 0x0000000000000020
    MPSDeviceSupportsSimdReduction = 0x0000000000000040
    MPSDeviceSupportsFloat32Filtering = 0x0000000000000080
    MPSDeviceSupportsNorm16BicubicFiltering = 0x0000000000000100
    MPSDeviceSupportsFloat16BicubicFiltering = 0x0000000000000200
    MPSDeviceIsAppleDevice = 0x0000000000000400
    MPSDeviceSupportsSimdShuffleAndFill = 0x0000000000000800
    MPSDeviceSupportsBFloat16Arithmetic = 0x0000000000001000
    MPSDeviceCapsLast = 0x0000000000002000
end

const MPSDeviceCaps = UInt32

@cenum MPSCustomKernelIndex::UInt32 begin
    MPSCustomKernelIndexDestIndex = 0
    MPSCustomKernelIndexSrc0Index = 0
    MPSCustomKernelIndexSrc1Index = 1
    MPSCustomKernelIndexSrc2Index = 2
    MPSCustomKernelIndexSrc3Index = 3
    MPSCustomKernelIndexSrc4Index = 4
    MPSCustomKernelIndexUserDataIndex = 30
end

struct MPSMatrixOffset
    rowOffset::UInt32
    columnOffset::UInt32
end

struct MPSIntegerDivisionParams
    divisor::UInt16
    recip::UInt16
    addend::UInt16
    shift::UInt16
end

@cenum MPSImageType::UInt32 begin
    MPSImageType2d = 0x0000000000000000
    MPSImageType2d_array = 0x0000000000000001
    MPSImageTypeArray2d = 0x0000000000000002
    MPSImageTypeArray2d_array = 0x0000000000000003
    MPSImageType_ArrayMask = 0x0000000000000001
    MPSImageType_BatchMask = 0x0000000000000002
    MPSImageType_typeMask = 0x0000000000000003
    MPSImageType_noAlpha = 0x0000000000000004
    MPSImageType_texelFormatMask = 0x0000000000000038
    MPSImageType_texelFormatShift = 0x0000000000000003
    MPSImageType_texelFormatStandard = 0x0000000000000000
    MPSImageType_texelFormatUnorm8 = 0x0000000000000008
    MPSImageType_texelFormatFloat16 = 0x0000000000000010
    MPSImageType_texelFormatBFloat16 = 0x0000000000000018
    MPSImageType_bitCount = 0x0000000000000006
    MPSImageType_mask = 0x000000000000003f
    MPSImageType2d_noAlpha = 0x0000000000000004
    MPSImageType2d_array_noAlpha = 0x0000000000000005
    MPSImageTypeArray2d_noAlpha = 0x0000000000000006
    MPSImageTypeArray2d_array_noAlpha = 0x0000000000000007
end

const MPSFunctionConstant = Int64

const MPSFunctionConstantInMetal = UInt32

struct MPSCustomKernelArgumentCount
    destinationTextureCount::Culong
    sourceTextureCount::Culong
    broadcastTextureCount::Culong
end

@cenum MPSAlphaType::UInt64 begin
    MPSAlphaTypeNonPremultiplied = 0x0000000000000000
    MPSAlphaTypeAlphaIsOne = 0x0000000000000001
    MPSAlphaTypePremultiplied = 0x0000000000000002
end

@cenum MPSMatrixDecompositionStatus::Int32 begin
    MPSMatrixDecompositionStatusSuccess = 0
    MPSMatrixDecompositionStatusFailure = -1
    MPSMatrixDecompositionStatusSingular = -2
    MPSMatrixDecompositionStatusNonPositiveDefinite = -3
end

struct MPSMatrixCopyOffsets
    sourceRowOffset::UInt32
    sourceColumnOffset::UInt32
    destinationRowOffset::UInt32
    destinationColumnOffset::UInt32
end

@cenum MPSMatrixRandomDistribution::UInt64 begin
    MPSMatrixRandomDistributionDefault = 0x0000000000000001
    MPSMatrixRandomDistributionUniform = 0x0000000000000002
    MPSMatrixRandomDistributionNormal = 0x0000000000000003
end

struct MPSImageKeypointRangeInfo
    maximumKeypoints::NSUInteger
    minimumThresholdValue::Cfloat
end

@cenum MPSCNNConvolutionFlags::UInt64 begin
    MPSCNNConvolutionFlagsNone = 0x0000000000000000
end

@cenum MPSCNNBinaryConvolutionFlags::UInt64 begin
    MPSCNNBinaryConvolutionFlagsNone = 0x0000000000000000
    MPSCNNBinaryConvolutionFlagsUseBetaScaling = 0x0000000000000001
end

@cenum MPSCNNBinaryConvolutionType::UInt64 begin
    MPSCNNBinaryConvolutionTypeBinaryWeights = 0x0000000000000000
    MPSCNNBinaryConvolutionTypeXNOR = 0x0000000000000001
    MPSCNNBinaryConvolutionTypeAND = 0x0000000000000002
end

@cenum MPSNNConvolutionAccumulatorPrecisionOption::UInt64 begin
    MPSNNConvolutionAccumulatorPrecisionOptionHalf = 0x0000000000000000
    MPSNNConvolutionAccumulatorPrecisionOptionFloat = 0x0000000000000001
end

@cenum MPSNNTrainingStyle::UInt64 begin
    MPSNNTrainingStyleUpdateDeviceNone = 0x0000000000000000
    MPSNNTrainingStyleUpdateDeviceCPU = 0x0000000000000001
    MPSNNTrainingStyleUpdateDeviceGPU = 0x0000000000000002
end

@cenum MPSCNNBatchNormalizationFlags::UInt64 begin
    MPSCNNBatchNormalizationFlagsDefault = 0x0000000000000000
    MPSCNNBatchNormalizationFlagsCalculateStatisticsAutomatic = 0x0000000000000000
    MPSCNNBatchNormalizationFlagsCalculateStatisticsAlways = 0x0000000000000001
    MPSCNNBatchNormalizationFlagsCalculateStatisticsNever = 0x0000000000000002
    MPSCNNBatchNormalizationFlagsCalculateStatisticsMask = 0x0000000000000003
end

@cenum MPSNNPaddingMethod::UInt64 begin
    MPSNNPaddingMethodAlignCentered = 0x0000000000000000
    MPSNNPaddingMethodAlignTopLeft = 0x0000000000000001
    MPSNNPaddingMethodAlignBottomRight = 0x0000000000000002
    MPSNNPaddingMethodAlign_reserved = 0x0000000000000003
    MPSNNPaddingMethodAlignMask = 0x0000000000000003
    MPSNNPaddingMethodAddRemainderToTopLeft = 0x0000000000000000
    MPSNNPaddingMethodAddRemainderToTopRight = 0x0000000000000004
    MPSNNPaddingMethodAddRemainderToBottomLeft = 0x0000000000000008
    MPSNNPaddingMethodAddRemainderToBottomRight = 0x000000000000000c
    MPSNNPaddingMethodAddRemainderToMask = 0x000000000000000c
    MPSNNPaddingMethodSizeValidOnly = 0x0000000000000000
    MPSNNPaddingMethodSizeSame = 0x0000000000000010
    MPSNNPaddingMethodSizeFull = 0x0000000000000020
    MPSNNPaddingMethodSize_reserved = 0x0000000000000030
    MPSNNPaddingMethodCustomWhitelistForNodeFusion = 0x0000000000002000
    MPSNNPaddingMethodCustomAllowForNodeFusion = 0x0000000000002000
    MPSNNPaddingMethodCustom = 0x0000000000004000
    MPSNNPaddingMethodSizeMask = 0x00000000000007f0
    MPSNNPaddingMethodExcludeEdges = 0x0000000000008000
end

@cenum MPSCNNNeuronType::Int32 begin
    MPSCNNNeuronTypeNone = 0
    MPSCNNNeuronTypeReLU = 1
    MPSCNNNeuronTypeLinear = 2
    MPSCNNNeuronTypeSigmoid = 3
    MPSCNNNeuronTypeHardSigmoid = 4
    MPSCNNNeuronTypeTanH = 5
    MPSCNNNeuronTypeAbsolute = 6
    MPSCNNNeuronTypeSoftPlus = 7
    MPSCNNNeuronTypeSoftSign = 8
    MPSCNNNeuronTypeELU = 9
    MPSCNNNeuronTypePReLU = 10
    MPSCNNNeuronTypeReLUN = 11
    MPSCNNNeuronTypePower = 12
    MPSCNNNeuronTypeExponential = 13
    MPSCNNNeuronTypeLogarithm = 14
    MPSCNNNeuronTypeGeLU = 15
    MPSCNNNeuronTypeCount = 16
end

@cenum MPSCNNConvolutionWeightsLayout::UInt32 begin
    MPSCNNConvolutionWeightsLayoutOHWI = 0x0000000000000000
end

@cenum MPSCNNWeightsQuantizationType::UInt32 begin
    MPSCNNWeightsQuantizationTypeNone = 0x0000000000000000
    MPSCNNWeightsQuantizationTypeLinear = 0x0000000000000001
    MPSCNNWeightsQuantizationTypeLookupTable = 0x0000000000000002
end

@cenum MPSCNNConvolutionGradientOption::UInt64 begin
    MPSCNNConvolutionGradientOptionGradientWithData = 0x0000000000000001
    MPSCNNConvolutionGradientOptionGradientWithWeightsAndBias = 0x0000000000000002
    MPSCNNConvolutionGradientOptionAll = 0x0000000000000003
end

@cenum MPSCNNLossType::UInt32 begin
    MPSCNNLossTypeMeanAbsoluteError = 0x0000000000000000
    MPSCNNLossTypeMeanSquaredError = 0x0000000000000001
    MPSCNNLossTypeSoftMaxCrossEntropy = 0x0000000000000002
    MPSCNNLossTypeSigmoidCrossEntropy = 0x0000000000000003
    MPSCNNLossTypeCategoricalCrossEntropy = 0x0000000000000004
    MPSCNNLossTypeHinge = 0x0000000000000005
    MPSCNNLossTypeHuber = 0x0000000000000006
    MPSCNNLossTypeCosineDistance = 0x0000000000000007
    MPSCNNLossTypeLog = 0x0000000000000008
    MPSCNNLossTypeKullbackLeiblerDivergence = 0x0000000000000009
    MPSCNNLossTypeCount = 0x000000000000000a
end

@cenum MPSCNNReductionType::Int32 begin
    MPSCNNReductionTypeNone = 0
    MPSCNNReductionTypeSum = 1
    MPSCNNReductionTypeMean = 2
    MPSCNNReductionTypeSumByNonZeroWeights = 3
    MPSCNNReductionTypeCount = 4
end

@cenum MPSNNComparisonType::UInt64 begin
    MPSNNComparisonTypeEqual = 0x0000000000000000
    MPSNNComparisonTypeNotEqual = 0x0000000000000001
    MPSNNComparisonTypeLess = 0x0000000000000002
    MPSNNComparisonTypeLessOrEqual = 0x0000000000000003
    MPSNNComparisonTypeGreater = 0x0000000000000004
    MPSNNComparisonTypeGreaterOrEqual = 0x0000000000000005
end

@cenum MPSRNNSequenceDirection::UInt64 begin
    MPSRNNSequenceDirectionForward = 0x0000000000000000
    MPSRNNSequenceDirectionBackward = 0x0000000000000001
end

@cenum MPSRNNBidirectionalCombineMode::UInt64 begin
    MPSRNNBidirectionalCombineModeNone = 0x0000000000000000
    MPSRNNBidirectionalCombineModeAdd = 0x0000000000000001
    MPSRNNBidirectionalCombineModeConcatenate = 0x0000000000000002
end

@cenum MPSRNNMatrixId::UInt64 begin
    MPSRNNMatrixIdSingleGateInputWeights = 0x0000000000000000
    MPSRNNMatrixIdSingleGateRecurrentWeights = 0x0000000000000001
    MPSRNNMatrixIdSingleGateBiasTerms = 0x0000000000000002
    MPSRNNMatrixIdLSTMInputGateInputWeights = 0x0000000000000003
    MPSRNNMatrixIdLSTMInputGateRecurrentWeights = 0x0000000000000004
    MPSRNNMatrixIdLSTMInputGateMemoryWeights = 0x0000000000000005
    MPSRNNMatrixIdLSTMInputGateBiasTerms = 0x0000000000000006
    MPSRNNMatrixIdLSTMForgetGateInputWeights = 0x0000000000000007
    MPSRNNMatrixIdLSTMForgetGateRecurrentWeights = 0x0000000000000008
    MPSRNNMatrixIdLSTMForgetGateMemoryWeights = 0x0000000000000009
    MPSRNNMatrixIdLSTMForgetGateBiasTerms = 0x000000000000000a
    MPSRNNMatrixIdLSTMMemoryGateInputWeights = 0x000000000000000b
    MPSRNNMatrixIdLSTMMemoryGateRecurrentWeights = 0x000000000000000c
    MPSRNNMatrixIdLSTMMemoryGateMemoryWeights = 0x000000000000000d
    MPSRNNMatrixIdLSTMMemoryGateBiasTerms = 0x000000000000000e
    MPSRNNMatrixIdLSTMOutputGateInputWeights = 0x000000000000000f
    MPSRNNMatrixIdLSTMOutputGateRecurrentWeights = 0x0000000000000010
    MPSRNNMatrixIdLSTMOutputGateMemoryWeights = 0x0000000000000011
    MPSRNNMatrixIdLSTMOutputGateBiasTerms = 0x0000000000000012
    MPSRNNMatrixIdGRUInputGateInputWeights = 0x0000000000000013
    MPSRNNMatrixIdGRUInputGateRecurrentWeights = 0x0000000000000014
    MPSRNNMatrixIdGRUInputGateBiasTerms = 0x0000000000000015
    MPSRNNMatrixIdGRURecurrentGateInputWeights = 0x0000000000000016
    MPSRNNMatrixIdGRURecurrentGateRecurrentWeights = 0x0000000000000017
    MPSRNNMatrixIdGRURecurrentGateBiasTerms = 0x0000000000000018
    MPSRNNMatrixIdGRUOutputGateInputWeights = 0x0000000000000019
    MPSRNNMatrixIdGRUOutputGateRecurrentWeights = 0x000000000000001a
    MPSRNNMatrixIdGRUOutputGateInputGateWeights = 0x000000000000001b
    MPSRNNMatrixIdGRUOutputGateBiasTerms = 0x000000000000001c
    MPSRNNMatrixId_count = 0x000000000000001d
end

@cenum MPSNNRegularizationType::UInt64 begin
    MPSNNRegularizationTypeNone = 0x0000000000000000
    MPSNNRegularizationTypeL1 = 0x0000000000000001
    MPSNNRegularizationTypeL2 = 0x0000000000000002
end

struct MPSNDArrayOffsets
    dimensions::NTuple{16,NSInteger}
end

struct MPSNDArraySizes
    dimensions::NTuple{16,NSUInteger}
end

@cenum MPSNDArrayQuantizationScheme::UInt64 begin
    MPSNDArrayQuantizationTypeNone = 0x0000000000000000
    MPSNDArrayQuantizationTypeAffine = 0x0000000000000001
    MPSNDArrayQuantizationTypeLUT = 0x0000000000000002
end

struct _MPSPackedFloat3
    data::NTuple{12,UInt8}
end

function Base.getproperty(x::Ptr{_MPSPackedFloat3}, f::Symbol)
    f === :x && return Ptr{Cfloat}(x + 0)
    f === :y && return Ptr{Cfloat}(x + 4)
    f === :z && return Ptr{Cfloat}(x + 8)
    f === :elements && return Ptr{NTuple{3,Cfloat}}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::_MPSPackedFloat3, f::Symbol)
    r = Ref{_MPSPackedFloat3}(x)
    ptr = Base.unsafe_convert(Ptr{_MPSPackedFloat3}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_MPSPackedFloat3}, f::Symbol, v)
    return unsafe_store!(getproperty(x, f), v)
end

const MPSPackedFloat3 = _MPSPackedFloat3

struct MPSRayPackedOriginDirection
    origin::MPSPackedFloat3
    direction::MPSPackedFloat3
end

struct MPSRayOriginMinDistanceDirectionMaxDistance
    origin::MPSPackedFloat3
    minDistance::Cfloat
    direction::MPSPackedFloat3
    maxDistance::Cfloat
end

struct MPSRayOriginMaskDirectionMaxDistance
    origin::MPSPackedFloat3
    mask::Cuint
    direction::MPSPackedFloat3
    maxDistance::Cfloat
end

struct MPSIntersectionDistance
    distance::Cfloat
end

struct MPSIntersectionDistancePrimitiveIndex
    distance::Cfloat
    primitiveIndex::Cuint
end

struct MPSIntersectionDistancePrimitiveIndexBufferIndex
    distance::Cfloat
    primitiveIndex::Cuint
    bufferIndex::Cuint
end

struct MPSIntersectionDistancePrimitiveIndexInstanceIndex
    distance::Cfloat
    primitiveIndex::Cuint
    instanceIndex::Cuint
end

struct MPSIntersectionDistancePrimitiveIndexBufferIndexInstanceIndex
    distance::Cfloat
    primitiveIndex::Cuint
    bufferIndex::Cuint
    instanceIndex::Cuint
end

@cenum MPSAccelerationStructureUsage::UInt64 begin
    MPSAccelerationStructureUsageNone = 0x0000000000000000
    MPSAccelerationStructureUsageRefit = 0x0000000000000001
    MPSAccelerationStructureUsageFrequentRebuild = 0x0000000000000002
    MPSAccelerationStructureUsagePreferGPUBuild = 0x0000000000000004
    MPSAccelerationStructureUsagePreferCPUBuild = 0x0000000000000008
end

@cenum MPSAccelerationStructureStatus::UInt64 begin
    MPSAccelerationStructureStatusUnbuilt = 0x0000000000000000
    MPSAccelerationStructureStatusBuilt = 0x0000000000000001
end

@cenum MPSPolygonType::UInt64 begin
    MPSPolygonTypeTriangle = 0x0000000000000000
    MPSPolygonTypeQuadrilateral = 0x0000000000000001
end

@cenum MPSTransformType::UInt64 begin
    MPSTransformTypeFloat4x4 = 0x0000000000000000
    MPSTransformTypeIdentity = 0x0000000000000001
end

@cenum MPSTemporalWeighting::UInt64 begin
    MPSTemporalWeightingAverage = 0x0000000000000000
    MPSTemporalWeightingExponentialMovingAverage = 0x0000000000000001
end

@cenum MPSDeviceOptions::UInt64 begin
    MPSDeviceOptionsDefault = 0x0000000000000000
    MPSDeviceOptionsLowPower = 0x0000000000000001
    MPSDeviceOptionsSkipRemovable = 0x0000000000000002
end

@cenum MPSIntersectionType::UInt64 begin
    MPSIntersectionTypeNearest = 0x0000000000000000
    MPSIntersectionTypeAny = 0x0000000000000001
end

@cenum MPSTriangleIntersectionTestType::UInt64 begin
    MPSTriangleIntersectionTestTypeDefault = 0x0000000000000000
    MPSTriangleIntersectionTestTypeWatertight = 0x0000000000000001
end

@cenum MPSBoundingBoxIntersectionTestType::UInt64 begin
    MPSBoundingBoxIntersectionTestTypeDefault = 0x0000000000000000
    MPSBoundingBoxIntersectionTestTypeAxisAligned = 0x0000000000000001
    MPSBoundingBoxIntersectionTestTypeFast = 0x0000000000000002
end

@cenum MPSRayMaskOptions::UInt64 begin
    MPSRayMaskOptionNone = 0x0000000000000000
    MPSRayMaskOptionPrimitive = 0x0000000000000001
    MPSRayMaskOptionInstance = 0x0000000000000002
end

@cenum MPSRayDataType::UInt64 begin
    MPSRayDataTypeOriginDirection = 0x0000000000000000
    MPSRayDataTypeOriginMinDistanceDirectionMaxDistance = 0x0000000000000001
    MPSRayDataTypeOriginMaskDirectionMaxDistance = 0x0000000000000002
    MPSRayDataTypePackedOriginDirection = 0x0000000000000003
end

@cenum MPSIntersectionDataType::UInt64 begin
    MPSIntersectionDataTypeDistance = 0x0000000000000000
    MPSIntersectionDataTypeDistancePrimitiveIndex = 0x0000000000000001
    MPSIntersectionDataTypeDistancePrimitiveIndexCoordinates = 0x0000000000000002
    MPSIntersectionDataTypeDistancePrimitiveIndexInstanceIndex = 0x0000000000000003
    MPSIntersectionDataTypeDistancePrimitiveIndexInstanceIndexCoordinates = 0x0000000000000004
    MPSIntersectionDataTypeDistancePrimitiveIndexBufferIndex = 0x0000000000000005
    MPSIntersectionDataTypeDistancePrimitiveIndexBufferIndexCoordinates = 0x0000000000000006
    MPSIntersectionDataTypeDistancePrimitiveIndexBufferIndexInstanceIndex = 0x0000000000000007
    MPSIntersectionDataTypeDistancePrimitiveIndexBufferIndexInstanceIndexCoordinates = 0x0000000000000008
end

@cenum MPSRayMaskOperator::UInt64 begin
    MPSRayMaskOperatorAnd = 0x0000000000000000
    MPSRayMaskOperatorNotAnd = 0x0000000000000001
    MPSRayMaskOperatorOr = 0x0000000000000002
    MPSRayMaskOperatorNotOr = 0x0000000000000003
    MPSRayMaskOperatorXor = 0x0000000000000004
    MPSRayMaskOperatorNotXor = 0x0000000000000005
    MPSRayMaskOperatorLessThan = 0x0000000000000006
    MPSRayMaskOperatorLessThanOrEqualTo = 0x0000000000000007
    MPSRayMaskOperatorGreaterThan = 0x0000000000000008
    MPSRayMaskOperatorGreaterThanOrEqualTo = 0x0000000000000009
    MPSRayMaskOperatorEqual = 0x000000000000000a
    MPSRayMaskOperatorNotEqual = 0x000000000000000b
end