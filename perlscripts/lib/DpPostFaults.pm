#!perl
package DpPostFaults;

use strict;
use warnings;

use base 'Exporter';

our @EXPORT = qw(get_dp_post_faults get_errors_from_dp_post);


#    // Global Types and Objects
#    /// the enumerator for all fault IDs
#    struct
#    {
#        DP_SelfTestFaultIdType faultId;
#        UINT32 dpFaultNum;          // mostly for documetation to make the table more meaningful. The enum should have the same value
#        UINT32 whichWord;
#        UINT32 whichBit;
#        CHAR const *msg;
#    } const dpErr2TxtArray[] = {

my %dp_post_faults = 
(
    ReservedPST1                              => { word => 0 , bit => 0x00000001 , msg => "DP POST Reserved POST Error 1 %d"}            ,
    postECC2MemoryFailure                     => { word => 0 , bit => 0x00000002 , msg => "DP POST ECC Memory Error 2 %d"}               ,
    ReservedPST2                              => { word => 0 , bit => 0x00000004 , msg => "DP POST Reserved POST Error 2 %d"}            ,
    cacheFailure                              => { word => 0 , bit => 0x00000008 , msg => "DP POST POST Cache Failure %d"}               ,
    ReservedPST3                              => { word => 0 , bit => 0x00000010 , msg => "DP POST Reserved POST Error 3 %d"}            ,
    systemControllerNotFound                  => { word => 0 , bit => 0x00000020 , msg => "DP POST System Controller Not Found %d"}      ,
    interProcessorBridgeNotFound              => { word => 0 , bit => 0x00000040 , msg => "DP POST Inter Processor Bridge Not Found %d"} ,
    pcieBridgeNotFound                        => { word => 0 , bit => 0x00000080 , msg => "DP POST 8114 PCIe Bridge Not Found %d"}       ,
    pcieSwitchNotFound                        => { word => 0 , bit => 0x00000100 , msg => "DP POST 8532 PCIe Switch Not Found %d"}       ,
    mpegFPGANotFound                          => { word => 0 , bit => 0x00000200 , msg => "DP POST Video Comp (MPEG) FPGA Not Found %d"} ,
    videoFPGANotFound                         => { word => 0 , bit => 0x00000400 , msg => "DP POST Video Input FPGA Not Found %d"}       ,
    gpuNotFound                               => { word => 0 , bit => 0x00000800 , msg => "DP POST ATI ASIC Not Found %d"}               ,
    videoFPGArwFail                           => { word => 0 , bit => 0x00001000 , msg => "DP POST VIDEO Input FPGA FAIL %d"}            ,
    mpegFPGArwFail                            => { word => 0 , bit => 0x00002000 , msg => "DP POST Video Comp (MPEG) FPGA FAIL %d"}      ,
    gpuMemoryFail                             => { word => 0 , bit => 0x00004000 , msg => "DP POST ATI ASIC Memory FAIL %d"}             ,
    mpegFPGAMemoryFail                        => { word => 0 , bit => 0x00008000 , msg => "DP POST Video Comp (MPEG) Memory FAIL %d"}    ,
    videoFPGAMemoryFail                       => { word => 0 , bit => 0x00010000 , msg => "DP POST Video Input Memory FAIL %d"}
);

sub get_dp_post_faults
{
    return %dp_post_faults;
}

sub get_errors_from_dp_post
{
    my $searchWord = $_[0];
    my $searchBits = $_[1];
    my @results = ();

    for (my $i = 0; $i < 32; $i++)
    {
        my $bit = 2 ** $i;
        if (($bit & $searchBits) != 0)
        {
            while (my ($key, $value) = each(%dp_post_faults))
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

