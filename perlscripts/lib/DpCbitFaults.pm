#!perl
package DpCbitFaults;

use strict;
use warnings;

use base 'Exporter';

our @EXPORT = qw(get_dp_cbit_faults get_errors_from_dp_cbit);


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

my %dp_cbit_faults = 
(
    DPTemperatureTest                         => { word => 0 , bit => 0x00000001,  msg => "DP CST Proc Temp Failure %d"    } ,
    cstECC2MemoryFailure                      => { word => 0 , bit => 0x00000002 , msg => "DP CST ECC Memory Error 2 %d"   } ,
    pcieLaneError                             => { word => 0 , bit => 0x00000004 , msg => "DP CST PCIe Lane Error %d"      } ,
    pciError                                  => { word => 0 , bit => 0x00000008 , msg => "DP CST PCI Error %d"            } ,
    cpuErrorCause                             => { word => 0 , bit => 0x00000010 , msg => "DP CST DP CPU Error Cause %d"   } ,
    _3_0VoltFailure                           => { word => 0 , bit => 0x00000020 , msg => "DP CST 3p0 Volt Failure %d"     } ,
    _1_0VoltFailure                           => { word => 0 , bit => 0x00000040 , msg => "DP CST 1p0 Volt Failure %d"     } ,
    _2_5VoltFailure                           => { word => 0 , bit => 0x00000080 , msg => "DP CST 2p5 Volt Failure %d"     } ,
    RAM_TermVoltageFailure                    => { word => 0 , bit => 0x00000100 , msg => "DP CST RAM Termination Voltage Failure %d" }
);

sub get_dp_cbit_faults
{
    return %dp_cbit_faults;
}

sub get_errors_from_dp_cbit
{
    my $searchWord = $_[0];
    my $searchBits = $_[1];
    my @results = ();

    for (my $i = 0; $i < 32; $i++)
    {
        my $bit = 2 ** $i;
        if (($bit & $searchBits) != 0)
        {
            while (my ($key, $value) = each(%dp_cbit_faults))
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

