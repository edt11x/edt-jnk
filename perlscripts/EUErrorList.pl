#! perl
# Print out a nice list of the possible ESS or ATP BIT errors

use strict;
use warnings;

use Getopt::Long;
use File::Path;
use File::Copy;
use Time::Local;
use File::Glob ':glob';

use lib 'r:/tools/PerlScripts/lib';
use lib '/Users/edt/files/work/l3Displays/jsf.trunk/tools/PerlScripts/lib';
use OtpFaults;
use EuCbitFaults;
use EuPostFaults;
use DpCbitFaults;
use DpPostFaults;
use DuFaults;

my $help = 0;
my $yesToAllFiles = 0;
my $man = 0;

GetOptions("help|?"      => \$help,
           "yes"         => \$yesToAllFiles,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

my %otpFaults = OtpFaults::get_otp_faults();
my %euCbitFaults = EuCbitFaults::get_eu_cbit_faults();
my %euPostFaults = EuPostFaults::get_eu_post_faults();
my %dpCbitFaults = DpCbitFaults::get_dp_cbit_faults();
my %dpPostFaults = DpPostFaults::get_dp_post_faults();
my %duFaults = DuFaults::get_du_faults();

sub printFaults
{
    my ($title, $faultsRef) = @_;
    print $title, "\n";
    for (my $word = 0; $word < 16; $word++)
    {
        my $printWord = 1;
        for (my $i = 0; $i < 32; $i++)
        {
            my $bit = 2 ** ($i);
            while (my ($key, $value) = each(%$faultsRef))
            {
                if (($value->{word} == $word) && ($value->{bit} == $bit))
                {
                    if ($printWord)
                    {
                        print "\n## Test Word ", $word+1, "\n";
                        $printWord = 0;
                    }
                    my $msg = $value->{msg};
                    $msg =~ s/ *0x%[Xx]$//;
                    $msg =~ s/ *%d$//;
                    printf "* Bit 0x%08X, %s, %s\n", $bit,
                        substr($key . (" " x 40), 0, 40), $msg;
                }
            }
        }
    }
    print "\n\n";
}

printFaults "# OTP General BIT Faults", \%otpFaults;
printFaults "# EU POST BIT Faults", \%euPostFaults;
printFaults "# EU CBIT BIT Faults", \%euCbitFaults;
printFaults "# DP POST BIT Faults", \%dpPostFaults;
printFaults "# DP CBIT BIT Faults", \%dpCbitFaults;
printFaults "# DU POST and CBIT Faults", \%duFaults;
exit 0;

__END__

=head1 NAME

EUErrorList.pl - Print out a nice list of possible ESS or ATP BIT errors

=head1 SYNOPSIS

EUErrorList.pl 

    Options:
      --help        brief help message
      --man         manual page

=head1 OPTIONS

=over 8

=item B<help>

Print a brief help message and exit

=item B<man>

Print the manual page and exit

=back

=head1 DESCRIPTION

This function prints out a nice list of possible ESS or ATP BIT errors.

=cut

