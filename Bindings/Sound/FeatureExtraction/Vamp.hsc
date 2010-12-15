{-# LANGUAGE ForeignFunctionInterface #-}

#include <bindings.dsl.h>
#include <vamp/vamp.h>

module Bindings.Sound.FeatureExtraction.Vamp where

#strict_import

#cinline VAMP_API_VERSION , IO CInt

#starttype VampParameterDescriptor
-- | Computer-usable name of the parameter. Must not change. [a-zA-Z0-9_]
#field identifier , CString

-- | Human-readable name of the parameter. May be translatable.
#field name , CString

-- | Human-readable short text about the parameter.  May be translatable.
#field description , CString

-- | Human-readable unit of the parameter. 
#field unit , CString

-- | Minimum value. 
#field minValue , CFloat

-- | Maximum value. 
#field maxValue , CFloat

-- | Default value. Plugin is responsible for setting this on initialise. 
#field defaultValue , CFloat

-- | 1 if parameter values are quantized to a particular resolution.
#field isQuantized , CInt

-- | Quantization resolution, if isQuantized.
#field quantizeStep , CFloat

-- | Human-readable names of the values, if isQuantized.  May be NULL.
#field valueNames , Ptr CString
#stoptype

#integral_t VampSampleType
-- | Each process call returns results aligned with call's block start. 
#num vampOneSamplePerStep
-- | Returned results are evenly spaced at samplerate specified below. 
#num vampFixedSampleRate
-- | Returned results have their own individual timestamps. 
#num vampVariableSampleRate

#starttype VampOutputDescriptor
    -- | Computer-usable name of the output. Must not change. [a-zA-Z0-9_] 
    #field identifier , CString

    -- | Human-readable name of the output. May be translatable. 
    #field name , CString

    -- | Human-readable short text about the output. May be translatable. 
    #field description , CString

    -- | Human-readable name of the unit of the output. 
    #field unit , CString

    -- | 1 if output has equal number of values for each returned result. 
    #field hasFixedBinCount , CInt

    -- | Number of values per result, if hasFixedBinCount. 
    #field binCount , CUInt

    -- | Names of returned value bins, if hasFixedBinCount.  May be NULL. 
    #field binNames , Ptr CString

    -- | 1 if each returned value falls within the same fixed min/max range. 
    #field hasKnownExtents , CInt
    
    -- | Minimum value for a returned result in any bin, if hasKnownExtents. 
    #field minValue , CFloat

    -- | Maximum value for a returned result in any bin, if hasKnownExtents. 
    #field maxValue , CFloat

    -- | 1 if returned results are quantized to a particular resolution. 
    #field isQuantized , CInt

    -- | Quantization resolution for returned results, if isQuantized. 
    #field quantizeStep , CFloat

    -- | Time positioning method for returned results (see VampSampleType). 
    #field sampleType , <VampSampleType>

    -- | Sample rate of returned results, if sampleType is vampFixedSampleRate.
    -- "Resolution" of result, if sampleType is vampVariableSampleRate.
    #field sampleRate , CFloat

    -- | 1 if the returned results for this output are known to have a
    -- duration field.
    -- 
    -- This field is new in Vamp API version 2; it must not be tested
    -- for plugins that report an older API version in their plugin
    -- descriptor.
    #field hasDuration , CInt
#stoptype

#starttype VampFeature
-- | 1 if the feature has a timestamp (i.e. if vampVariableSampleRate).
#field hasTimestamp , CInt

-- | Seconds component of timestamp.
#field sec , CInt

-- | Nanoseconds component of timestamp.
#field nsec , CInt

-- | Number of values.  Must be binCount if hasFixedBinCount.
#field valueCount , CUInt

-- | Values for this returned sample.
#field values , Ptr CFloat

-- | Label for this returned sample.  May be NULL.
#field label , CString
#stoptype

#starttype VampFeatureV2
    -- | 1 if the feature has a duration.
    #field hasDuration , CInt

    -- | Seconds component of duration.
    #field durationSec , CInt

    -- | Nanoseconds component of duration.
    #field durationNsec , CInt
#stoptype

#starttype VampFeatureUnion
    -- sizeof(featureV1) >= sizeof(featureV2) for backward compatibility
    #union_field v1 , <VampFeature>
    #union_field v2 , <VampFeatureV2>
#stoptype

#starttype VampFeatureList
    -- | Number of features in this feature list. 
    #field featureCount , CUInt

    -- | Features in this feature list.  May be NULL if featureCount is zero.
    --
    -- If present, this array must contain featureCount feature
    -- structures for a Vamp API version 1 plugin, or 2*featureCount
    -- feature unions for a Vamp API version 2 plugin.
    -- 
    -- The features returned by an API version 2 plugin must consist
    -- of the same feature structures as in API version 1 for the
    -- first featureCount array elements, followed by featureCount
    -- unions that contain VampFeatureV2 structures (or NULL pointers
    -- if no V2 feature structures are present).
    #field features , Ptr <VampFeatureUnion>
#stoptype

#integral_t VampInputDomain
#num vampTimeDomain
#num vampFrequencyDomain

#synonym_t VampPluginHandle , Ptr ()

#starttype VampPluginDescriptor
    -- | API version with which this descriptor is compatible. 
    #field vampApiVersion , CUInt

    -- | Computer-usable name of the plugin. Must not change. [a-zA-Z0-9_] 
    #field identifier , CString

    -- | Human-readable name of the plugin. May be translatable. 
    #field name , CString

    -- | Human-readable short text about the plugin. May be translatable. 
    #field description , CString

    -- | Human-readable name of plugin's author or vendor. 
    #field maker , CString

    -- | Version number of the plugin. 
    #field pluginVersion , CInt

    -- | Human-readable summary of copyright or licensing for plugin. 
    #field copyright , CString

    -- | Number of parameter inputs. 
    #field parameterCount , CUInt

    -- | Fixed descriptors for parameter inputs. 
    #field parameters , Ptr (Ptr <VampParameterDescriptor>)

    -- | Number of programs. 
    #field programCount , CUInt

    -- | Fixed names for programs. 
    #field programs , Ptr CString

    -- | Preferred input domain for audio input (time or frequency). 
    #field inputDomain , <VampInputDomain>

    -- | Create and return a new instance of this plugin. 
    -- #field instantiate , FunPtr (Ptr <VampPluginDescriptor> -> CFloat -> IO <VampPluginHandle>)
    #field instantiate , <instantiate>

    -- | Destroy an instance of this plugin. 
    #field cleanup , <cleanup>

    -- | Initialise an instance following parameter configuration.
    --
    -- int (*initialise)(VampPluginHandle,
    --                   unsigned int inputChannels,
    --                   unsigned int stepSize, 
    --                   unsigned int blockSize);
    #field initialise , <initialise>
    
    -- | Reset an instance, ready to use again on new input data. 
    #field reset , <reset>

    -- | Get a parameter value.
    #field getParameter , <getParameter>

    -- | Set a parameter value. May only be called before initialise. 
    #field setParameter , <setParameter>
    
    -- | Get the current program (if programCount > 0). 
    #field getCurrentProgram , <getCurrentProgram>
    
    -- | Set the current program. May only be called before initialise. 
    #field selectProgram , <selectProgram>
    
    -- | Get the plugin's preferred processing window increment in samples. 
    #field getPreferredStepSize , <getPreferredStepSize>

    -- | Get the plugin's preferred processing window size in samples. 
    #field getPreferredBlockSize , <getPreferredBlockSize>
    
    -- | Get the minimum number of input channels this plugin can handle. 
    #field getMinChannelCount , <getMinChannelCount>
    
    -- | Get the maximum number of input channels this plugin can handle. 
    #field getMaxChannelCount , <getMaxChannelCount>
    
    -- | Get the number of feature outputs (distinct sets of results). 
    #field getOutputCount , <getOutputCount>
    
    -- | Get a descriptor for a given feature output.
    --
    -- Returned pointer is valid only until next call to getOutputDescriptor for this
    -- handle, or releaseOutputDescriptor for this descriptor. Host must call
    -- releaseOutputDescriptor after use.
    #field getOutputDescriptor , <getOutputDescriptor>

    -- | Destroy a descriptor for a feature output. 
    #field releaseOutputDescriptor , <releaseOutputDescriptor>
    
    -- | Process an input block and return a set of features.
    -- 
    -- Returned
    -- pointer is valid only until next call to process,
    -- getRemainingFeatures, or cleanup for this handle, or
    -- releaseFeatureSet for this feature set. Host must call
    -- releaseFeatureSet after use.
    --
    -- const float *const *inputBuffers,
    -- int sec,
    -- int nsec);
    #field process , <process>
    
    -- | Return any remaining features at the end of processing.
    #field getRemainingFeatures , <getRemainingFeatures>
    
    -- | Release a feature set returned from process or getRemainingFeatures. 
    #field releaseFeatureSet , <releaseFeatureSet>
#stoptype

#callback instantiate             , Ptr <VampPluginDescriptor> -> CFloat -> IO <VampPluginHandle>
#callback cleanup                 , <VampPluginHandle> -> IO ()
#callback initialise              , <VampPluginHandle> -> CUInt -> CUInt -> CUInt -> IO CInt
#callback reset                   , <VampPluginHandle> -> IO ()
#callback getParameter            , <VampPluginHandle> -> CInt -> IO CFloat
#callback setParameter            , <VampPluginHandle> -> CInt -> CFloat -> IO ()
#callback getCurrentProgram       , <VampPluginHandle> -> IO CUInt
#callback selectProgram           , <VampPluginHandle> -> CUInt -> IO ()
#callback getPreferredStepSize    , <VampPluginHandle> -> IO CUInt
#callback getPreferredBlockSize   , <VampPluginHandle> -> IO CUInt
#callback getMinChannelCount      , <VampPluginHandle> -> IO CUInt
#callback getMaxChannelCount      , <VampPluginHandle> -> IO CUInt
#callback getOutputCount          , <VampPluginHandle> -> IO CUInt
#callback getOutputDescriptor     , <VampPluginHandle> -> CUInt -> IO (Ptr <VampOutputDescriptor>)
#callback releaseOutputDescriptor , Ptr <VampOutputDescriptor> -> IO ()
#callback process                 , <VampPluginHandle> -> Ptr (Ptr CFloat) -> CInt -> CInt -> IO (Ptr <VampFeatureList>)
#callback getRemainingFeatures    , <VampPluginHandle> -> IO (Ptr <VampFeatureList>)
#callback releaseFeatureSet       , Ptr <VampFeatureList> -> IO ()

-- | Get the descriptor for a given plugin index in this library.
--
-- Return NULL if the index is outside the range of valid indices for
-- this plugin library.
-- 
-- The hostApiVersion argument tells the library code the highest
-- Vamp API version supported by the host.  The function should
-- return a plugin descriptor compatible with the highest API version
-- supported by the library that is no higher than that supported by
-- the host.  Provided the descriptor has the correct vampApiVersion
-- field for its actual compatibility level, the host should be able
-- to do the right thing with it: use it if possible, discard it
-- otherwise.
-- 
-- This is the only symbol that a Vamp plugin actually needs to
-- export from its shared object; all others can be hidden.  See the
-- accompanying documentation for notes on how to achieve this with
-- certain compilers.
#callback vampGetPluginDescriptor , CUInt -> CUInt -> IO (Ptr <VampPluginDescriptor>)
