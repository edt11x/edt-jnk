#! perl
# grepLogFiles --filepat=".log" --dir="." pattern1 pattern2 pattern3, pattern4
#
# Look for log files that contain multiple patterns
#
# I could not find something that would match patterns with an "and" operation. 
# Both of these patterns must exist in a file for it to match

use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
use File::Find;

my $help = 0;
my $man = 0;
my $dir = ".";
my $filepat = ".";
my $verbose = 0;
my @patterns = ();

GetOptions("help|?"      => \$help,
           "dir"         => \$dir,
           "filepat"     => \$filepat,
           "verbose"     => \$verbose,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

sub wanted {
    my $thisFile = $File::Find::name;
    my $foundIt = 1;
    if ($verbose)
    {
        print "$thisFile -- is it a file ?\n";
    }
    if (($thisFile =~ /$filepat/) &&
        (-f $thisFile))
    {
        my @results = ();
        if ($verbose)
        {
            print "$thisFile -- evaluating\n";
        }
        open FILE, "$thisFile" or die "Could not open $thisFile : $!";
        while (<FILE>)
        {
            for (my $i = 0; $i < @patterns; $i++)
            {
                my $thisPattern = $patterns[$i];
                if (/$thisPattern/)
                {
                    $results[$i] = 1;
                }
            }
        }
        close(FILE);
        # Check the results and see if all of them are set
        for (my $i = 0; $i < @patterns; $i++)
        {
            if (! defined($results[$i]))
            {
                $foundIt = 0;
            }
        }
        if ($foundIt)
        {
            if ($verbose)
            {
                print "$thisFile matches\n";
            }
            else
            {
                print "$thisFile\n";
            }
        }
        else
        {
            if ($verbose)
            {
                print "$thisFile does NOT match\n";
            }
        }
    }
}

@patterns = splice(@ARGV, 0);
if (@patterns) {
    foreach my $pat (@patterns)
    {
        if ($verbose)
        {
            print "Arg **$pat**\n";
        }
    }
    find(\&wanted, $dir);
}
else
{
    print "Must have a pattern to search for.\n";
    pod2usage(1);
}

exit 0;

__END__

=head1 NAME

grepLogFiles.pl - grep log files for logs which match multiple patterns

=head1 SYNOPSIS

grepLogFiles.pl --filepat=".log" --dir="." pattern1 pattern2 pattern3..

    Options:
      --filepat     the pattern to pick which files to search
      --dir         the directory to start the search in
      --help        brief help message
      --man         manual page

=head1 OPTIONS

=over 8

=item B<filepat>

The file pattern to use to select the files to evaluate.

=item B<dir>

The directory to start the search in

=item B<help>

Print a brief help message and exit

=item B<man>

Print the manual page and exit

=back

=head1 DESCRIPTION

This function digests the logs.

=cut

