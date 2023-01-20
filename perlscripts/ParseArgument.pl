#! perl
# My generic template for parsing command line arguments

use strict;
use warnings;

use lib 'r:/tools/PerlScripts/lib';
use lib '/Users/edt/jnk/perlmodules';
use lib '/home/edt/jnk/perlmodules';
use Getopt::Long;
use File::Path;
use File::Copy;
use Time::Local;

my $help = 0;
my $yesToAll = 0;
my $man = 0;

GetOptions("help|?"      => \$help,
           "yes"         => \$yesToAll,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

sub parseArguments
{
    print "Argument --" . $_ . "--\n" for @_;
}

parseArguments(@ARGV);

exit 0;

__END__

=head1 NAME

parseArgument.pl - generic program to parse arguments

=head1 SYNOPSIS

parseArguments.pl 

    Options:
      --yes         answer yes to everything
      --help        brief help message
      --man         manual page

=head1 OPTIONS

=over 8

=item B<yes>

Answer yes to everything.

=item B<help>

Print a brief help message and exit.

=item B<man>

Print the manual page and exit.

=back

=head1 DESCRIPTION

This program parses arguments.

=cut

