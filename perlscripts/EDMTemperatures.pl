#! perl
# My generic template for parsing a file

use strict;
use warnings;

use Getopt::Long;
use File::Path;
use File::Copy;
use Time::Local;
use File::Glob ':glob';
use List::Util qw(sum);

my $help = 0;
my $yesToAllFiles = 0;
my $man = 0;

GetOptions("help|?"      => \$help,
           "yes"         => \$yesToAllFiles,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

my @spModTemp = ();
my @spCPUTemp = ();
my @vpModTemp = ();
my @ioModTemp = ();
my @fcModTemp = ();

sub printArrayTemperatureInfo
{
    my $refToArr = $_[0];
    my $fmt = $_[1];
    my @arr = sort { $a <=> $b } @$refToArr;

    if (@arr != 0)
    {
        printf(" Max : " . $fmt, $arr[$#arr]);
        printf(", Min : " . $fmt, $arr[0]);
        printf(", Avg : " . $fmt, sum(@arr) / @arr);
        printf(", Mean : " . $fmt, $arr[int(@arr / 2)]);
    }
}

sub searchForErrors
{
    my $lineCount = $_[0];
    my $thisLine = $_[1];

    if ($thisLine =~ /(error|fail|fatal|fault|not found|unknown|disabled|undervoltage|overcurrent|unusually|under threshold|bad packet|time out)/i)
    {
        if (($thisLine !~ /Debug Mode Disabled/) &&
            ($thisLine !~ /SP CPU temp unusually/) &&
            ($thisLine !~ /LVPS Module temp unusually/) &&
            ($thisLine !~ /First attempt to read the DP Fault Log/) &&
            ($thisLine !~ /OTP: DP POST: DP POST ATI ASIC Memory FAIL/) &&
            ($thisLine !~ /OTP: Early Continuous BIT test FAILED./) &&
            ($thisLine !~ /OTP: Fault: OTP Initial CST tests failed in Kernel Main/) &&
            ($thisLine !~ /OTP: Fault: OTP LVPS ETI Not Incrementing/) &&
            ($thisLine !~ /OTP: Fault: OTP LVPS ETI Not Valid/) &&
            ($thisLine !~ /OTP: Fault: OTP PS/) &&
            ($thisLine !~ /OTP: Fault: OTP Fibre Channel/) &&
            ($thisLine !~ /OTP: Fault: OTP FC.AV Video/) &&
            ($thisLine !~ /OTP: Fault: OTP FC Loss Of Sync/) &&
            ($thisLine !~ /OTP: Fault: OTP Power Supply/) &&
            ($thisLine !~ /OTP: Fault: OTP STOF Pulse/) &&
            ($thisLine !~ /OTP: application7 main\(\) FCReceive/) &&
            ($thisLine !~ /OTP: InitializeDPFaultMaintStruct\(\) succeeded./) &&
            ($thisLine !~ /OTP: Loop to call InitializeDPFaultMaintStruct\(\)/) &&
            ($thisLine !~ /OTP: application6 main\(\) Setting PBIT FAIL in AS OTP Flags./) &&
            ($thisLine !~ /OTP: application6 main\(\) Zeroing CPU Error Cause register./) &&
            ($thisLine !~ /OTP: application6 main\(\), first pcd_perform_pbit\(\) FAILURE/) &&
            ($thisLine !~ /SP CBIT: Fault: SP CBIT PS /) &&
            ($thisLine !~ /pcd_perform_pbit\(\).* Operation Failed /))
        {
            print "At Line ", $lineCount, ": ", $thisLine, "\n";
        }
    }
}

sub parseFile
{
    my $fileName = $_[0];
    my $lineCount = 0;
    my $lastTimeFound = 0;
    my $bootCount = 0;
    my $suspeciousBoots = 0;
    open FILE, "$fileName" or die "Could not open file : $!\n";

    while(<FILE>)
    {
        chomp;
        $lineCount++;
        my $thisLine = $_;
        searchForErrors($lineCount, $thisLine);
        if ($thisLine =~ /at time (\d+)$/)
        {
            $lastTimeFound = $1;
        }
        if ($thisLine =~ /EBL Formal/)
        {
            $bootCount++;
            if (($lineCount > 20) &&
                ($lastTimeFound < 165))
            {
                print "Look at boot at line $lineCount\n";
                $suspeciousBoots++;
            }
            $lastTimeFound = 0;
        }
        if ($thisLine =~ /SP\s+Module\s+Temperature : (\S+)/)
        {
            push(@spModTemp, $1);
        }
        if ($thisLine =~ /SP\s+CPU\s+Temperature : (\S+)/)
        {
            push(@spCPUTemp, $1);
        }
        if ($thisLine =~ /VP\s+Module\s+Temperature : (\S+)/)
        {
            push(@vpModTemp, $1);
        }
        if ($thisLine =~ /IO\s+Module\s+Temperature : (\S+)/)
        {
            push(@ioModTemp, $1);
        }
        if ($thisLine =~ /FC\s+Module\s+Temperature : (\S+)/)
        {
            push(@fcModTemp, $1);
        }
    }
    close(FILE);
    print "\nTotal Number of Boots      : $bootCount\n";
    print "\nNumber of Suspecious Boots : $suspeciousBoots\n";
    print "\nSP Module Temperature      : ";
    printArrayTemperatureInfo(\@spModTemp, "%3d");
    print "\nSP CPU    Temperature      : ";
    printArrayTemperatureInfo(\@spCPUTemp, "%3d");
    print "\nVP Module Temperature      : ";
    printArrayTemperatureInfo(\@vpModTemp, "%3d");
    print "\nIO Module Temperature      : ";
    printArrayTemperatureInfo(\@ioModTemp, "%3d");
    print "\nFC Module Temperature      : ";
    printArrayTemperatureInfo(\@fcModTemp, "%3d");
}

foreach my $arg (@ARGV)
{
    # glob each argument
    if ((defined($arg)) && ($arg ne ""))
    {
        my @list = bsd_glob($arg);
        foreach my $thisOne (@list)
        {
            if ((defined($thisOne)) && ($thisOne ne ""))
            {
                if (-e ($thisOne))
                {
                    print "Parsing File : $thisOne\n\n";
                    &parseFile($thisOne);
                }
            }
        }
    }
}

exit 0;

__END__

=head1 NAME

digestLogs.pl - digest the logs from the merged log repository

=head1 SYNOPSIS

digestLogs.pl 

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

This function digests the logs.

=cut

