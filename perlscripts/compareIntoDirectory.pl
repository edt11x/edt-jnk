#!/usr/bin/env perl

use lib 'r:/tools/PerlScripts/lib';
use lib '/Users/edt/jnk/perlmodules';
use lib '/home/edt/jnk/perlmodules';
use Cwd 'realpath';
use Getopt::Long;
use Pod::Usage;
use File::Basename;
use File::Compare;
use File::Copy;
use File::DirCompare;
use File::Find;
use File::Path;
use File::Spec;
use File::stat;
use Scalar::MoreUtils qw( empty );

use strict;
use warnings;

my ( $fromDir, $intoDir, $mtime );
my ( $man,$help,$leave,$dontAdd,$verbose,$quieter,$bc2,$createDest,$overwriteBiggerNewer );

GetOptions("help|?"                 => \$help, 
           "bc2"                    => \$bc2,
           "create-dest"            => \$createDest,
           "dont-add"               => \$dontAdd,
           "man"                    => \$man, 
           "leave"                  => \$leave, 
           "mtime=s"                => \$mtime,
           "overwrite-bigger-newer" => \$overwriteBiggerNewer,
           "verbose"                => \$verbose,
           "quieter"                => \$quieter,
           "from=s"                 => \$fromDir, 
           "into=s"                 => \$intoDir) or pod2usage(2);
pod2usage(-exitval => 0) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;
pod2usage(-msg => "Unexpected argument : " . $ARGV[0], -exitval => 3) if (@ARGV != 0);

sub resolvePath { # resolve the full path with the correct separators for this OS
    return realpath(File::Spec->catdir(map { File::Spec->splitdir( $_ ) } @_));
}

if (empty($fromDir)) {
    pod2usage(-msg => "Specify the directory you want to compare from.", -exitval => 4);
}
if (empty($intoDir)) {
    pod2usage(-msg => "Specify the directory you are comparing into, the destination.", -exitval => 5);
}

$fromDir = resolvePath( $fromDir );
if ((empty($fromDir)) || (! (-d "$fromDir"))) {
    pod2usage(-msg => "Directory you are comparing from must exist.", -exitval => 6);
}

$intoDir = resolvePath( $intoDir );
if ((! empty($intoDir)) && (! (-d "$intoDir")) && ($createDest)) {
    mkpath($intoDir); # try to create the destination directory
}

if ((empty($intoDir)) || (! (-d "$intoDir"))) {
    pod2usage(-msg => "Directory you are comparing into, the destination, must exist.", -exitval => 7);
}

if ($fromDir eq $intoDir) {
    pod2usage(-msg => "From and Into directories must be different.", -exitval => 8);
}

sub qualifyMtime { # qualify the modification time of the file
    my $ret = 0; # assume the file does not qualify
    if (empty($mtime)) {
        $ret = 1; # mtime was not specified on the command line, all files match
    } else { # else, we need to qualify this file or directory
        if ($mtime =~ /^\+/) {
            $ret = 1 if ((lstat($_[0])) && (int(-M $_[0]) > $mtime));
        } elsif ($mtime =~ /^-/) {
            $ret = 1 if ((lstat($_[0])) && (int(-M $_[0]) < abs($mtime)));
        } else {
            $ret = 1 if ((lstat($_[0])) && (int(-M $_[0]) == $mtime));
        }
    }
    return $ret;
}

sub isThisFileBiggerAndNewer { # is this file bigger and newer than that one?
    my $ret = 0; # if the files do not exist, do not assert bigger and newer
    if ((!empty($_[0])) && (-f $_[0]) && (lstat($_[0])) &&
        (!empty($_[1])) && (-f $_[1]) && (lstat($_[1]))) {
        my $this = lstat($_[0]);
        my $that = lstat($_[1]);
        $ret = 1 if (($this->size > $that->size) && ($this->mtime > $that->mtime));
    }
    return $ret;
}

sub translatePathFromInto { # translate the path from source to destination
    return resolvePath( $intoDir, substr(resolvePath($_[0]), length($fromDir)));
}

sub createDestDir {
    my $dir = translatePathFromInto($_[0]);
    my $ret = 0; # return 0 - no dirs created, return 1 - created the dir
    if ((! (-d $dir)) && (! $dontAdd)) {
        $ret = mkpath($dir);
        print "Creating destination directory : $dir, returns $ret\n";
    }
    return $ret;
}

sub addFileToDestination {
    my $dir = translatePathFromInto(dirname($_[0]));
    if ($dontAdd) {
        print "Not adding $_[0]\n" if (! $quieter);
    } elsif ($leave) {
        print "copy($_[0], $dir)\n" if $verbose;
        copy($_[0], $dir) or die("Can not copy($_[0], $dir) : $!\n");
    } else {
        print "move($_[0], $dir)\n" if $verbose;
        move($_[0], $dir) or die("Can not move($_[0], $dir) : $!\n");
    }
}

for (my $doAgain = 1; $doAgain; ) { # main routine
    $doAgain = 0; # assume we only have to do the directory comparison this once
    File::DirCompare->compare($fromDir, $intoDir, sub { # do the directory comparison
        my ($a, $b) = @_;
        if (( empty($b) ) && (qualifyMtime($a))) { # if destination file is missing
            print "Only in from directory, $fromDir: $a\n" if (! $quieter);
            if (-d "$a") { # if we found a directory to create
                $doAgain += createDestDir($a);# do it again if we create dir, eval new files
            } else { # else, must be a file
                $doAgain += createDestDir(dirname($a)); # do it again if we create a dir
                addFileToDestination($a);
            }
        } elsif ( empty($a) ) { # if the file is missing in the from directory
            print "Only in destination directory, $intoDir: $b\n" if ($verbose);
        } elsif (qualifyMtime($a)) { # both files exist and maybe they are different
            if (File::Compare::compare($a, $b) != 0) { # if the files are different
                if (($overwriteBiggerNewer) && (isThisFileBiggerAndNewer($a, $b))) {
                    print "Files:\n   $a\n --and--\n   $b\n -- differ, overwriting.\n\n";
                    addFileToDestination($a);
                } else { # run beyond compare on the files
                    print "Files:\n   $a\n --and--\n   $b\n -- differ, no merge.\n\n";
                    system("bc2 \"$a\" \"$b\"") if ($bc2);
                }
            } else { # else files are exactly the same, they match
                if ($leave) {
                    print "Leaving file in from dir, $fromDir: $a\n" if (! $quieter);
                } else {
                    print "Delete file in from dir, $fromDir: $a\n" if (! $quieter);
                    unlink($a); # delete the file in the from directory
                }
            }
        }
    }, { ignore_cmp => 1 }); # end of File::DirCompare->compare()
}

__END__

=head1 NAME

compareIntoDirectory - compare a directory and merge it into a second directory

=head1 SYNOPSIS

compareIntoDirectory --from=ThisDirectory --into=ThatDirectory

This is a command to compare a directory and merge it into a second directory
in an automated way, leaving behind the things that may conflict so they can be
considered manually. For example,

Directory /a compared to  directory /b

/a/f1 matches /b/f1                 - no copy needed, delete /a/f1
/a/f2 does not exist but /b/f2 does - then do nothing, file only in destination
/a/f3 exists but /b/f3 does not     - then move /a/f3 to /b
/a/f4 does not match /b/f4          - then do nothing, leave mismatches alone

  Options:
    --help                   brief help message
    --man                    manual page
    --leave                  leave files in from dir, do not delete them
    --mtime                  only consider files matching modification time
    --overwrite-bigger-newer overwrite when from files are bigger AND newer
    --verbose                info about everything, even in the into dir
    --quieter                reduce the amount of output to important info
    --bc2                    start Beyond Compare 2 on the mismatched files
    --create-dest            create the destination dir if it does not exist
    --dont-add               do not add files to the destination directory
    --from                   the directory to merge from
    --into                   the directory to merge into

=head1 OPTIONS

=over 8

=item B<help>

Print a brief help message and exit

=item B<man>

Print the manual page and exit

=item B<create-dest>

Create the destination directory if it does not exist.

=item B<dont-add>

Do not add files to the destination directory. This is useful if we are just
decimating a directory down to the differences.

=item B<leave>

Leave the files in the from directory. Normally the files are moved into the
into directory, aka the destination directory. This causes the files to be
copied instead.

=item B<mtime>

Consider only files with specified modification time. Uses the unix find
handling of mtime. For example, --mtime=-10, only allows the files in the last
10 days.  --mtime=+10, only allows files 10 or more days earlier. --mtime=10
only allows files that are 10 days old, not earlier or later. The modification
time is only considered on the "from" files.

=item B<overwrite-bigger-newer>

This flag causes the compare to overwrite files in the destination directory if
the files in the from directory are bigger and newer than the files in the
destination.  When processing log file directories, this is generally what is
desired.

=item B<verbose>

This will cause something to be printed about every file, even the ones in the
into directory.

=item B<quieter>

Reduce the amount of printed output to the important differences.

=item B<bc2>

This will start Beyond Compare 2 on the mismatched files. Be careful with this,
since you don't want to start Beyond Compare on 200 different files.

=item B<from>

The directory to merge data from

=item B<into>

The directory to merge data into

=back

=head1 DESCRIPTION

This function compares two directories and merges the data from the first
directory into the second, leaving behind any files that do not match.

=cut

