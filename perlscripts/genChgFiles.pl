#! perl
use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
use File::Find qw(finddepth);

my @commands;
my $savedDir;
my $currentDrive;
my $cmd = "copy";
my $fromDir;
my $toDir;
my $help = 0;
my $verbose = 0;
my $prefix = "";
my $win32 = 0;
my $mtime = 3;
my $man = 0;

# Need to think about a syntax to ignore things like .svn directories.
# find . -name .svn -a -type d -prune -o -type f -mtime -20 -print

sub isEmpty {
    return ((!defined($_[0])) || ($_[0] eq ""));
}

sub pod2useWithMsg {
    pod2usage(-msg => $_[0], -exitval => $_[1]);
}

sub isWin32 {
    return (($^O =~ /Win32/) || ($win32));
}

sub linuxSlashes {
    $_[0] =~ s/\\/\//g;
    return $_[0];
}

sub nativeSlashes {
    my $str = linuxSlashes($_[0]);
    $str =~ s/\//\\/g if isWin32();
    return $str;
}

sub fromSlashes {
    my $str = linuxSlashes($_[0]);
    $str =~ s/\//\\/g if ($^O =~ /Win32/);
    return $str;
}

sub replaceDir {
    my $thisDir = $_[0];
    my $thisFromDir = $_[1];
    my $thisToDir = $_[2];
    # backslash Q tells Perl to start escaping special chars, backslash E to end escaping
    $thisDir =~ s/\Q$thisFromDir\E/$thisToDir/;
    return $thisDir;
}

GetOptions("help|?"      => \$help, 
           "man"         => \$man, 
           "mtime=s"     => \$mtime,
           "win32"       => \$win32,
           "verbose"     => \$verbose,
           "cmd=s"       => \$cmd,
           "prefix=s"    => \$prefix,
           "from=s"      => \$fromDir, 
           "into=s"      => \$toDir) or pod2useWthMsg("Invalid option", 2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;
pod2useWithMsg("Need a valid from dir!", 4) if isEmpty($fromDir);
# we may be dealing with a mix of Linux and Windows, map everything to one kind of slashes
$fromDir = linuxSlashes($fromDir);
pod2useWithMsg("Need a valid to dir!", 5) if isEmpty($toDir);
$toDir = linuxSlashes($toDir);
pod2useWithMsg("Unexpected argument.", 3) if (!isEmpty($ARGV[0]));

# Main
finddepth(sub {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);
    if ((($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f _ &&
    (int(-M _) < $mtime)) {
        # figure out the destination directory for the file
        my $thisToDir = replaceDir(linuxSlashes($File::Find::dir), $fromDir, $toDir);
        # check to see if the directory for the file is different than the last
        if ((isEmpty($savedDir)) || ($thisToDir ne $savedDir)) {
            # build the commands to create the necessary directories for the file
            my $thisDir = "";
            my $restOfThePath = $savedDir = $thisToDir;
            # we may have to deal with a drive letter
            if ((isWin32()) && ($savedDir =~ /:/)) {
                ($thisDir, $restOfThePath) = split(':', $savedDir, 2);
                $thisDir = $thisDir . ':';
            }
            my @pieces = split("/", $restOfThePath);
            foreach my $piece (@pieces) {
                if (!isEmpty($piece)) {
                    $thisDir = $thisDir . '/' . $piece;
                    push @commands, "mkdir \"" . nativeSlashes($thisDir) . "\"";
                }
            }
        }
        # build the commands to copy the file
        my $thisFromFile = linuxSlashes($File::Find::name);
        my $thisToFile = replaceDir(linuxSlashes($File::Find::name), $fromDir, $toDir);
        push @commands, $cmd . " \"" . $prefix . fromSlashes($thisFromFile) . "\" \"" . nativeSlashes($thisToFile) . "\"";
    }
}, $fromDir);

print map { "$_\n" } @commands;

__END__

=head1 NAME

genChgFiles.pl - generate a command file of changed files to copy.

=head1 SYNOPSIS

genChgFiles --from=ThisDirectory --into=ThatDirectory

    Options:
      --help        brief help message
      --man         manual page
      --mtime       consider only files with matching modification time
      --verbose     tell about everything, even in the into directory
      --cmd         the command to use to copy the files
      --prefix      the string to prefix the from file with
      --from        the directory to merge from
      --into        the directory to merge into
      --win32       the resulting command will be run on Windows

Example of generating a Putty command file:

$ perl /home/edt/bin/genChgFiles.pl --cmd='c:\putty\pscp.exe -load mte1-linux' 
    --prefix=edt@158.186.41.157:/home/edt/files/work/l3Displays/ 
    --from=logfiles --into='P:\tmp' --mtime=20 --win32 > /home/edt/tmp/foo.cmd

=head1 OPTIONS

=over 8

=item B<help>

Print a brief help message and exit

=item B<man>

Print the manual page and exit

=item B<mtime>

Consider only files with specified modification time. Uses the unix find handling
of mtime. For example, --mtime=-10, only allows the files in the last 10 days. The
modification time is only considered on the "from" files.

=item B<verbose>

This will cause something to be printed about every file, even the ones in the into 
directory.

=item B<cmd>

The command to use to copy the file

=item B<prefix>

The string to prefix the from file with. When executing the copy on the destination
machine, the from file may have other path decorations than on the source machine.

=item B<win32>

The resulting command will be run on some form of Windows.

=item B<from>

The directory to merge data from

=item B<into>

The directory to merge data into

=back

=head1 DESCRIPTION

This generates a command file with a list of files to copy.

=cut


