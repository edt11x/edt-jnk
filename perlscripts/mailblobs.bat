@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#! C:\Perl\bin\perl.exe -w
#line 15
    eval 'exec C:\Perl\bin\perl.exe -S $0 ${1+"$@"}'
        if 0; #$running_under_some_shell

use strict;
use warnings;

use lib 'r:/tools/PerlScripts/lib';
use lib '/Users/edt/jnk/perlmodules';
use Archive::Zip;
use Cwd 'realpath';
use MIME::Base64 qw(encode_base64);
use Getopt::Long;
use File::Basename;
use File::Find ();
use File::Path;
use File::Copy;
use File::Spec;
use Pod::Usage;
use Scalar::MoreUtils qw(empty);
use Time::Local;
use File::Glob ':glob';
use Win32::Autoglob;

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

my $help = 0;
my $allFiles = 0;
my $yesToAllFiles = 0;
my $man = 0;
my $win32 = 0;
my $zipArchive;
my $zipFileName = "mailblob.zip";
my $mimeFileName = "mailblob.txt";
my $chunkSize = 1024;
my $mtime = "";

GetOptions("help|?"      => \$help,
           "all"         => \$allFiles,
           "mtime=s"     => \$mtime,
           "win32"       => \$win32,
           "yes"         => \$yesToAllFiles,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

sub isWin32 {
    return (($^O =~ /Win32/) || ($win32));
}

sub resolvePath { # resolve the full path with the correct separators for this OS
    return File::Spec->canonpath(File::Spec->catdir(map { File::Spec->splitdir( $_ ) } @_));
}

sub qualifyMtime { # qualify the modification time of the file
    my $ret = 0; # assume the file does not qualify
    my $thisFile = $_[0];

    if ((!defined($mtime)) || (empty($mtime))) {
        $ret = 1; # mtime was not specified on the command line, all files match
    } else { # else, we need to qualify this file or directory
        if ($mtime =~ /^\+/) {
            $ret = 1 if ((lstat($thisFile)) && (int(-M $thisFile) > $mtime));
        } elsif ($mtime =~ /^-/) {
            $ret = 1 if ((lstat($thisFile)) && (int(-M $thisFile) < abs($mtime)));
        } else {
            $ret = 1 if ((lstat($thisFile)) && (int(-M $thisFile) == $mtime));
        }
    }
    return $ret;
}

sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    /^\.svn\z/s &&
    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -d _ &&
    ($File::Find::prune = 1)
    ||
    /\.swp\z/s &&
    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f _ &&
    ($File::Find::prune = 1)
    ||
    ($nlink || (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_))) &&
    -f _ &&
    qualifyMtime($_) &&
    # print "$_\n" && $zipArchive->addFile($name);
    $zipArchive->addFile($name);
}

sub parsePath
{
    # Traverse desired filesystems
    File::Find::find({wanted => \&wanted}, $_[0]);
}

my $tmpDirPath = "/tmp";
$tmpDirPath = "/Users/edt/tmp" if (-d "/Users/edt/tmp");
$tmpDirPath = "/home/edt/tmp" if (-d "/home/edt/tmp");
$tmpDirPath = "C:/TMP" if (isWin32());

my $zipFilePath = resolvePath($tmpDirPath, $zipFileName);
my $mimeFilePath = resolvePath($tmpDirPath, $mimeFileName);

unlink($zipFilePath);
$zipArchive = Archive::Zip->new();

foreach my $arg (@ARGV)
{
    if (-e ($arg))
    {
        print "Parsing Path : $arg\n\n";
        &parsePath($arg);
    }
}

($zipArchive->writeToFileNamed($zipFilePath) == Archive::Zip::AZ_OK) or die("Could not create archive.");

my $buffer = '';
unlink($mimeFilePath);

open(ENCODEME, $zipFilePath) or die "$!";
open(OUTPUT, ">" . $mimeFilePath) or die "$!";
binmode ENCODEME;
binmode OUTPUT;
while ( read(ENCODEME, $buffer, $chunkSize ) ) {
    print OUTPUT encode_base64($buffer);
}
close(ENCODEME);
close(OUTPUT);

exit 0;

__END__

=head1 NAME

mailblobs.pl - generate blobs of files that can be mailed

=head1 SYNOPSIS

mailblobs.pl 

    Options:
      --help        brief help message
      --man         manual page
      --mtime       consider only files with matching modification time
      --win32       the resulting command will be run on Windows

=head1 OPTIONS

=over 8

=item B<help>

Print a brief help message and exit

=item B<all>

All files in the currect directory go.

=item B<mtime>

Consider only files with specified modification time. Uses the unix find handling
of mtime. For example, --mtime=-10, only allows the files in the last 10 days. The
modification time is only considered on the "from" files.

=item B<win32>

The resulting command will be run on some form of Windows.

=item B<man>

Print the manual page and exit

=back

=head1 DESCRIPTION

This function generates blobs of files that can be mailed.

=cut



__END__
:endofperl
