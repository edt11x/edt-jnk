#! perl
# My generic template for parsing a file

use strict;
use warnings;

use lib 'r:/tools/PerlScripts/lib';
use Getopt::Long;
use File::Path;
use File::Copy;
use Time::Local;
use File::Glob ':glob';
use Win32::Autoglob;

my $help = 0;
my $yesToAllFiles = 0;
my $man = 0;

GetOptions("help|?"      => \$help,
           "yes"         => \$yesToAllFiles,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

sub parseFile
{
    my $fileName = $_[0];
    open FILE, "$fileName" or die "Could not open file : $!\n";

    while(<FILE>)
    {
        chomp;
        print $_, "\n";
    }
    close(FILE);
}

foreach my $arg (@ARGV)
{
    if (-e ($arg))
    {
        print "Parsing File : $arg\n\n";
        &parseFile($arg);
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

