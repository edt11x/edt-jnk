#!/usr/bin/perl -w
use Getopt::Long;
use File::Find;

my $this_sem_name = "";
my $new_func_name = "";

sub generateSem {
my($thisLine) = @_;

# get the pieces otp_integrity_get_semaphore_value(KS_FIBRE_CHANNEL_60HZ_SYNC)

    if ($thisLine =~ /otp_integrity_get_semaphore_value\(([A-Z0-9_]+)\)/)
    {
        $this_sem_name = $1;
        $new_func_name = "otp_integrity_get_value_$this_sem_name";
        my $header = <<END_FUNCTION;
//#############################################################################
//
//  Name  $new_func_name
//
/// \@Description
/// This function gets the value for the $this_sem_name semaphore.
///
/// \@Inputs
/// <B>None</B>
///
/// \@Outputs
/// <B>None</B>
///
/// \@Return_Values
/// The value of the semaphore
//
//#############################################################################
INT32 $new_func_name(void)
{
    //lint -e{747,917}
    return otp_integrity_get_semaphore_value($this_sem_name);
}
END_FUNCTION
        print $header;
    }
}

while (<>) {
    &generateSem($_);
}
exit(0);
