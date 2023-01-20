#!perl
package EuPostFaults;

use strict;
use warnings;

use base 'Exporter';

our @EXPORT = qw(get_eu_post_faults get_errors_from_eu_post);

#    // This structure is to decode the EU IBIT Faults
#    // This table must match the FaultLog.c table!!!!
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
#    } otpPOSTFaults[]
# s/\(\s*\S\+\),\s*\(\S\+\)U, \(\S\+\)U, \(".*"\), 0U, \(\S\+U\), 0LL, \(\S\+\) },/\1 => { word => \2 , bit => \3, msg => \4, threshold => "\5", maxrate => \6 } ,/

my %eu_post_faults = 
(
    # // First word of the EU POST/IBIT faults on the OTP GUI and the ESS GUI log report
  SPU_POST_IBIT_sdramPinFault            => { word => 0 , bit => 0x00000001 , msg => "SP POST/IBIT SDRAM Pin Fault 0x%X"                            , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_sdramCellFault           => { word => 0 , bit => 0x00000002 , msg => "SP POST/IBIT SDRAM Cell Fault 0x%X"                           , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_cpuFault                 => { word => 0 , bit => 0x00000004 , msg => "SP POST/IBIT CPU Fault 0x%X"                                  , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_cacheFault               => { word => 0 , bit => 0x00000008 , msg => "SP POST/IBIT CPU Cache Fault 0x%X"                            , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_mmuFault                 => { word => 0 , bit => 0x00000010 , msg => "SP POST/IBIT MMU Fault 0x%X"                                  , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_eblImage1Fault           => { word => 0 , bit => 0x00000020 , msg => "SP POST/IBIT EBL Image 1 Fault 0x%X"                          , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_eblImage2Fault           => { word => 0 , bit => 0x00000040 , msg => "SP POST/IBIT EBL Image 2 Fault 0x%X"                          , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_nvramPinFault            => { word => 0 , bit => 0x00000080 , msg => "SP POST/IBIT NVRAM Pin Fault 0x%X"                            , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_nvramBank1CellFault      => { word => 0 , bit => 0x00000100 , msg => "SP POST/IBIT NVRAM Bank 1 Cell Fault 0x%X"                    , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_nvramBank2CellFault      => { word => 0 , bit => 0x00000200 , msg => "SP POST/IBIT NVRAM Bank 2 Cell Fault 0x%X"                    , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_CapVoltageValidityFault  => { word => 0 , bit => 0x00000400 , msg => "SP POST/IBIT Capictor Voltage Validity 0x%X"                  , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_SP6540IDFault            => { word => 0 , bit => 0x00000800 , msg => "SP POST/IBIT 6542 ID Fault 0x%X"                              , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_SP8114IDFault            => { word => 0 , bit => 0x00001000 , msg => "SP POST/IBIT 8114 ID Fault 0x%X"                              , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_SP8532VBIDFault          => { word => 0 , bit => 0x00002000 , msg => "SP POST/IBIT 8532 Virtual Bridge ID Fault 0x%X"               , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_SP8532EIOIDFault         => { word => 0 , bit => 0x00004000 , msg => "SP POST/IBIT 8532 IO ID Fault 0x%X"                           , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_SP8532FCIDFault          => { word => 0 , bit => 0x00008000 , msg => "SP POST/IBIT 8532 FC ID Fault 0x%X"                           , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_SP8532VPIDFault          => { word => 0 , bit => 0x00010000 , msg => "SP POST/IBIT 8532 VP ID Fault 0x%X"                           , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_EIO8114IDFault           => { word => 0 , bit => 0x00020000 , msg => "SP POST/IBIT IO 8114 ID Fault 0x%X"                           , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_NIU5IDFault              => { word => 0 , bit => 0x00040000 , msg => "SP POST/IBIT NIU 5 ID Fault 0x%X"                             , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_FC8114IDFault            => { word => 0 , bit => 0x00080000 , msg => "SP POST/IBIT FC 8114 ID Fault 0x%X"                           , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_NIU4IDFault              => { word => 0 , bit => 0x00100000 , msg => "SP POST/IBIT NIU 4 ID Fault  0x%X"                            , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_fpgaVersionFault         => { word => 0 , bit => 0x00200000 , msg => "SP POST/IBIT FPGA Version Fault 0x%X"                         , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_basicLoaderFlashVPCFault => { word => 0 , bit => 0x00400000 , msg => "SP POST/IBIT Basic Loader Flash VPC Fault 0x%X"               , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_sigTableEntryFault       => { word => 0 , bit => 0x00800000 , msg => "SP POST/IBIT Signature Table Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_NIU4MemFault             => { word => 0 , bit => 0x01000000 , msg => "SP POST/IBIT NIU 4 Memory Fault 0x%X"                         , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  SPU_POST_IBIT_NIU5MemFault             => { word => 0 , bit => 0x02000000 , msg => "SP POST/IBIT NIU 5 Memory Fault 0x%X"                         , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_SPFPGAFault                 => { word => 0 , bit => 0x04000000 , msg => "SP POST/IBIT SP FPGA Fault 0x%X"                              , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_DiscreteInputValidityFault  => { word => 0 , bit => 0x08000000 , msg => "SP POST/IBIT Disc In Validty Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_DiscreteOutputValidityFault => { word => 0 , bit => 0x10000000 , msg => "SP POST/IBIT Disc Out Validity Fault 0x%X"                    , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_SPTemp1ValidityFault        => { word => 0 , bit => 0x20000000 , msg => "SP POST/IBIT SP Temp 1 Validity Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_SPTemp2ValidityFault        => { word => 0 , bit => 0x40000000 , msg => "SP POST/IBIT SP Temp 2 Validity Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_VPTempValidityFault         => { word => 0 , bit => 0x80000000 , msg => "SP POST/IBIT VP Temp Validity Fault 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  # // Second word of the EU POST/IBIT faults on the OTP GUI and the ESS GUI log report
  Common_BIT_EIOTempValidityFault        => { word => 1 , bit => 0x00000001 , msg => "SP POST/IBIT IO Temp Validity Fault 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_FCTempValidityFault         => { word => 1 , bit => 0x00000002 , msg => "SP POST/IBIT FC Temp Validity Fault 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_PSTempValidityFault         => { word => 1 , bit => 0x00000004 , msg => "SP POST/IBIT PS Temp Validity Fault 0x%X"                     , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_SPETIValidityFault          => { word => 1 , bit => 0x00000008 , msg => "SP POST/IBIT SP ETI Validity Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_VPETIValidityFault          => { word => 1 , bit => 0x00000010 , msg => "SP POST/IBIT VP ETI Validity Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_EIOETIValidityFault         => { word => 1 , bit => 0x00000020 , msg => "SP POST/IBIT IO ETI Validity Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_FCETIValidityFault          => { word => 1 , bit => 0x00000040 , msg => "SP POST/IBIT FC ETI Validity Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_PSETIValidityFault          => { word => 1 , bit => 0x00000080 , msg => "SP POST/IBIT PS ETI Validity Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_EIOStatusValidityFault      => { word => 1 , bit => 0x00000100 , msg => "SP POST/IBIT IO Status Validity Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_FCStatusValidityFault       => { word => 1 , bit => 0x00000200 , msg => "SP POST/IBIT FC Status Validity Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_VPStatusValidityFault       => { word => 1 , bit => 0x00000400 , msg => "SP POST/IBIT VP Status Validity Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_PSStatusValidityFault       => { word => 1 , bit => 0x00000800 , msg => "SP POST/IBIT PS Status Validity Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_SP8532VBUncorrectableFault  => { word => 1 , bit => 0x00001000 , msg => "SP POST/IBIT SP 8532 Virtual Bridge Uncorrectable Fault 0x%X" , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_SP8532EIOLinkFault          => { word => 1 , bit => 0x00002000 , msg => "SP POST/IBIT SP 8532 IO Link Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_SP8532EIOUncorrectableFault => { word => 1 , bit => 0x00004000 , msg => "SP POST/IBIT SP 8532 IO Uncorrectable Fault 0x%X"             , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_SP8532FCLinkFault           => { word => 1 , bit => 0x00008000 , msg => "SP POST/IBIT SP 8532 FC Link Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_SP8532FCUncorrectableFault  => { word => 1 , bit => 0x00010000 , msg => "SP POST/IBIT SP 8532 FC Uncorrectable Fault 0x%X"             , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_SP8532VPLinkFault           => { word => 1 , bit => 0x00020000 , msg => "SP POST/IBIT SP 8532 VP Link Fault 0x%X"                      , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_SP8532VPUncorrectableFault  => { word => 1 , bit => 0x00040000 , msg => "SP POST/IBIT SP 8532 VP Uncorrectable Fault 0x%X"             , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_NIU5ConfigDoneFault         => { word => 1 , bit => 0x00080000 , msg => "SP POST/IBIT NIU 5 Config Done Fault 0x%X"                    , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_NIU5ConfigErrorFault        => { word => 1 , bit => 0x00100000 , msg => "SP POST/IBIT NIU 5 Config Error Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_VPConfigDoneFault           => { word => 1 , bit => 0x00200000 , msg => "SP POST/IBIT VP Config Done Fault 0x%X"                       , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_NIU4ConfigDoneFault         => { word => 1 , bit => 0x00400000 , msg => "SP POST/IBIT NIU 4 Config Done Fault 0x%X"                    , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_NIU4ConfigErrorFault        => { word => 1 , bit => 0x00800000 , msg => "SP POST/IBIT NIU 4 Config Error Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_VPDDR2PowerGoodFault        => { word => 1 , bit => 0x01000000 , msg => "SP POST/IBIT VP DDR2 Power Good Fault 0x%X"                   , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_PSBITEFault                 => { word => 1 , bit => 0x02000000 , msg => "SP POST/IBIT PS BITE Fault 0x%X"                              , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_PS5VPowerGoodFault          => { word => 1 , bit => 0x04000000 , msg => "SP POST/IBIT PS 5 Volt Power Good Fault 0x%X"                 , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_PS26VPowerGoodFault         => { word => 1 , bit => 0x08000000 , msg => "SP POST/IBIT PS 26 Volt Power Good Fault 0x%X"                , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_PS5VBoostGoodFault          => { word => 1 , bit => 0x10000000 , msg => "SP POST/IBIT PS 5 Volt Boost Good Fault 0x%X"                 , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_PS26VBoostGoodFault         => { word => 1 , bit => 0x20000000 , msg => "SP POST/IBIT PS 26 Volt Boost Good Fault 0x%X"                , threshold => "0U" , maxrate => "FIFTEENSECONDS" } , 
  Common_BIT_VPTemp1ValidityFault        => { word => 1 , bit => 0x40000000 , msg => "SP POST/IBIT VP ADT7461 Temp Good Fault 0x%X"                 , threshold => "0U" , maxrate => "FIFTEENSECONDS" } ,
  Common_BIT_VPTemp2ValidityFault        => { word => 1 , bit => 0x80000000 , msg => "SP POST/IBIT VP ATI ASIC Temp Good Fault 0x%X"                , threshold => "0U" , maxrate => "FIFTEENSECONDS" }
);

sub get_eu_post_faults
{
    return %eu_post_faults;
}

sub get_errors_from_eu_post
{
    my $searchWord = $_[0];
    my $searchBits = $_[1];
    my @results = ();

    for (my $i = 0; $i < 32; $i++)
    {
        my $bit = 2 ** $i;
        if (($bit & $searchBits) != 0)
        {
            while (my ($key, $value) = each(%eu_post_faults))
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

