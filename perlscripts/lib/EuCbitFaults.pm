#!perl
package EuCbitFaults;

use strict;
use warnings;

use base 'Exporter';

our @EXPORT = qw(get_eu_cbit_faults get_errors_from_eu_cbit);


#    // This structure is to decode the EU CBIT Faults
#    // This table must match the OFPS_FaultLog.c table!!!!
#    static struct
#    {
#        FaultIdType faultId;
#        UINT32 whichWord;
#        UINT32 whichBit;
#        CHAR const * msg;
#        UINT32 count;
#        UINT32 threshold;
#        INT64 lastTime;
#        INT64 maxRate; // how often in otpGetTime64() time that this fault will be accepted, zero is infinite
#    } otpCBITFaults[] =

my %eu_cbit_faults = 
(
    # // First word of the EU CBIT faults on the OTP GUI and the ESS GUI log report
     Common_BIT_SPFPGAFault                   => { word => 0 , bit => 0x00000001 , msg => "SP CBIT SP FPGA Fault 0x%X"                              , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_DiscreteInputValidityFault    => { word => 0 , bit => 0x00000002 , msg => "SP CBIT Disc In Validty Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_DiscreteOutputValidityFault   => { word => 0 , bit => 0x00000004 , msg => "SP CBIT Disc Out Validity Fault 0x%X"                    , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_SPTemp1ValidityFault          => { word => 0 , bit => 0x00000008 , msg => "SP CBIT SP Temp 1 Validity Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_SPTemp2ValidityFault          => { word => 0 , bit => 0x00000010 , msg => "SP CBIT SP Temp 2 Validity Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_VPTempValidityFault           => { word => 0 , bit => 0x00000020 , msg => "SP CBIT VP Temp Validity Fault 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_EIOTempValidityFault          => { word => 0 , bit => 0x00000040 , msg => "SP CBIT IO Temp Validity Fault 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_FCTempValidityFault           => { word => 0 , bit => 0x00000080 , msg => "SP CBIT FC Temp Validity Fault 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_PSTempValidityFault           => { word => 0 , bit => 0x00000100 , msg => "SP CBIT PS Temp Validity Fault 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_SPETIValidityFault            => { word => 0 , bit => 0x00000200 , msg => "SP CBIT SP ETI Validity Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_VPETIValidityFault            => { word => 0 , bit => 0x00000400 , msg => "SP CBIT VP ETI Validity Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_EIOETIValidityFault           => { word => 0 , bit => 0x00000800 , msg => "SP CBIT IO ETI Validity Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_FCETIValidityFault            => { word => 0 , bit => 0x00001000 , msg => "SP CBIT FC ETI Validity Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_PSETIValidityFault            => { word => 0 , bit => 0x00002000 , msg => "SP CBIT PS ETI Validity Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_EIOStatusValidityFault        => { word => 0 , bit => 0x00004000 , msg => "SP CBIT IO Status Validity Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_FCStatusValidityFault         => { word => 0 , bit => 0x00008000 , msg => "SP CBIT FC Status Validity Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_VPStatusValidityFault         => { word => 0 , bit => 0x00010000 , msg => "SP CBIT VP Status Validity Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_PSStatusValidityFault         => { word => 0 , bit => 0x00020000 , msg => "SP CBIT PS Status Validity Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_SP8532VBUncorrectableFault    => { word => 0 , bit => 0x00040000 , msg => "SP CBIT SP 8532 Virtual Bridge Uncorrectable Fault 0x%X" , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_SP8532EIOLinkFault            => { word => 0 , bit => 0x00080000 , msg => "SP CBIT SP 8532 IO Link Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_SP8532EIOUncorrectableFault   => { word => 0 , bit => 0x00100000 , msg => "SP CBIT SP 8532 IO Uncorrectable Fault 0x%X"             , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_SP8532FCLinkFault             => { word => 0 , bit => 0x00200000 , msg => "SP CBIT SP 8532 FC Link Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_SP8532FCUncorrectableFault    => { word => 0 , bit => 0x00400000 , msg => "SP CBIT SP 8532 FC Uncorrectable Fault 0x%X"             , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_SP8532VPLinkFault             => { word => 0 , bit => 0x00800000 , msg => "SP CBIT SP 8532 VP Link Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_SP8532VPUncorrectableFault    => { word => 0 , bit => 0x01000000 , msg => "SP CBIT SP 8532 VP Uncorrectable Fault 0x%X"             , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_NIU5ConfigDoneFault           => { word => 0 , bit => 0x02000000 , msg => "SP CBIT NIU 5 Config Done Fault 0x%X"                    , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_NIU5ConfigErrorFault          => { word => 0 , bit => 0x04000000 , msg => "SP CBIT NIU 5 Config Error Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_VPConfigDoneFault             => { word => 0 , bit => 0x08000000 , msg => "SP CBIT VP Config Done Fault 0x%X"                       , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_NIU4ConfigDoneFault           => { word => 0 , bit => 0x10000000 , msg => "SP CBIT NIU 4 Config Done Fault 0x%X"                    , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_NIU4ConfigErrorFault          => { word => 0 , bit => 0x20000000 , msg => "SP CBIT NIU 4 Config Error Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_VPDDR2PowerGoodFault          => { word => 0 , bit => 0x40000000 , msg => "SP CBIT VP DDR2 Power Good Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_PSBITEFault                   => { word => 0 , bit => 0x80000000 , msg => "SP CBIT PS BITE Fault 0x%X"                              , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
      # // Second word of the EU CBIT faults on the OTP GUI and the ESS GUI log report
     Common_BIT_PS5VPowerGoodFault            => { word => 1 , bit => 0x00000001 , msg => "SP CBIT PS 5 Volt Fault 0x%X"                            , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_PS26VPowerGoodFault           => { word => 1 , bit => 0x00000002 , msg => "SP CBIT PS 26 Volt Fault 0x%X"                           , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_DiscOutputFeedbackValidityFault => { word => 1 , bit => 0x00000004 , msg => "SP CBIT Discr Output Feedback Validity 0x%X"             , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_DiscOutputSenseFault            => { word => 1 , bit => 0x00000008 , msg => "SP CBIT Discrete Output Sense Failure 0x%X"              , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_MV64460CPUAccessFault           => { word => 1 , bit => 0x00000010 , msg => "SP CBIT Marvell CPU Access Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_MV64460PCI0Fault                => { word => 1 , bit => 0x00000020 , msg => "SP CBIT Marvell PCI 0 Fault 0x%X"                        , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_MV64460PCI1Fault                => { word => 1 , bit => 0x00000040 , msg => "SP CBIT Marvell PCI 1 Fault 0x%X"                        , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_SPTempWarnFault                 => { word => 1 , bit => 0x00000080 , msg => "SP CBIT SP Temperature Warning 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_SPOverTempFault                 => { word => 1 , bit => 0x00000100 , msg => "SP CBIT SP Over Temp Fault 0x%X"                         , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_VPTempWarnFault                 => { word => 1 , bit => 0x00000200 , msg => "SP CBIT VP Temperature Warning 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_VPOverTempFault                 => { word => 1 , bit => 0x00000400 , msg => "SP CBIT VP Over Temp Fault 0x%X"                         , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_EIOTempWarnFault                => { word => 1 , bit => 0x00000800 , msg => "SP CBIT IO Temperature Warning 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_EIOOverTempFault                => { word => 1 , bit => 0x00001000 , msg => "SP CBIT IO Over Temp Fault 0x%X"                         , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_FCTempWarnFault                 => { word => 1 , bit => 0x00002000 , msg => "SP CBIT FC Temperature Warning 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_FCOverTempFault                 => { word => 1 , bit => 0x00004000 , msg => "SP CBIT FC Over Temp Fault 0x%X"                         , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_PSTempWarnFault                 => { word => 1 , bit => 0x00008000 , msg => "SP CBIT PS Temperature Warning 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_PSOverTempFault                 => { word => 1 , bit => 0x00010000 , msg => "SP CBIT PS Over Temp Fault 0x%X"                         , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_DimmingBusValidityFault         => { word => 1 , bit => 0x00020000 , msg => "SP CBIT Dimming Bus Validity Fault 0x%X"                 , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_GPUVSyncFault                   => { word => 1 , bit => 0x00040000 , msg => "SP CBIT GPU VSYNC Fault 0x%X"                            , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_VRFault                         => { word => 1 , bit => 0x00080000 , msg => "SP CBIT Video Recording Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_VPPFault                        => { word => 1 , bit => 0x00100000 , msg => "SP CBIT Video Input Fault 0x%X"                          , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_VPOutFault                      => { word => 1 , bit => 0x00200000 , msg => "SP CBIT Video Processor Out Fault 0x%X"                  , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_DUCommunicationsFault           => { word => 1 , bit => 0x00400000 , msg => "SP CBIT DU Communications 0x%X"                          , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_MV64460ECCFault                 => { word => 1 , bit => 0x00800000 , msg => "SP CBIT Marvell Dbl Bit ECC Fault 0x%X"                  , threshold => "0U" , maxrate => "FIFTEENSECONDS" } ,
     Common_BIT_PS5VBoostGoodFault            => { word => 1 , bit => 0x01000000 , msg => "SP CBIT PS 5 Volt Boost Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     Common_BIT_PS26VBoostGoodFault           => { word => 1 , bit => 0x02000000 , msg => "SP CBIT PS 26 Volt Boost Fault 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } ,
     SPU_PBIT_MPEGCompressionFault            => { word => 1 , bit => 0x04000000 , msg => "SP CBIT MPEG COmpression Fault 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } ,
     SPU_PBIT_VPTemp1WarnFault                => { word => 1 , bit => 0x08000000 , msg => "SP CBIT VP ADT 7461 Temp Warning 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } ,
     SPU_PBIT_VPTemp1OverTempFault            => { word => 1 , bit => 0x10000000 , msg => "SP CBIT VP ADT 7461 Over Temp 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } ,
     SPU_PBIT_VPTemp2WarnFault                => { word => 1 , bit => 0x20000000 , msg => "SP CBIT VP ATI ASIC Temp Warning 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } ,
     SPU_PBIT_VPTemp2OverTempFault            => { word => 1 , bit => 0x40000000 , msg => "SP CBIT VP ATI ASIC Over Temp 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } ,
     Common_BIT_VPTemp1ValidityFault          => { word => 1 , bit => 0x80000000 , msg => "SP POST/IBIT VP ADT7461 Temp Good Fault 0x%X"            , threshold => "0U" , maxrate => "FIFTEENSECONDS" } ,
      # // Third word of the EU CBIT faults on the OTP GUI and the ESS GUI log report
     Common_BIT_VPTemp2ValidityFault          => { word => 2 , bit => 0x00000001 , msg => "SP POST/IBIT VP ATI ASIC Temp Good Fault 0x%X"           , threshold => "0U" , maxrate => "FIFTEENSECONDS" } ,
     SPU_PBIT_SPCPUTempWarnFault              => { word => 2 , bit => 0x00000002 , msg => "SP CBIT SP CPU Temperature Warning 0x%X"                 , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
     SPU_PBIT_SPCPUOverTempFault              => { word => 2 , bit => 0x00000004 , msg => "SP CBIT SP CPU Over Temp Fault 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" }
);

sub get_eu_cbit_faults
{
    return %eu_cbit_faults;
}

sub get_errors_from_eu_cbit
{
    my $searchWord = $_[0];
    my $searchBits = $_[1];
    my @results = ();

    for (my $i = 0; $i < 32; $i++)
    {
        my $bit = 2 ** $i;
        if (($bit & $searchBits) != 0)
        {
            while (my ($key, $value) = each(%eu_cbit_faults))
            {
                if (($value->{word} == $searchWord) && ($value->{bit} == $bit))
                {
                    push(@results, $value->{msg});
                }
            }
        }
    }
    return @results;
}

1;

