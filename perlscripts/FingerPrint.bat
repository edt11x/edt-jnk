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
#!perl
#line 15
#
# Generate a finger print for a file, including size, CRC and MD5 hash.
#
use strict;
use warnings;

use lib 'r:/tools/PerlScripts/lib';
use Archive::Zip;
use Cwd;
use Digest::MD5;
use Digest::SHA1;
use File::Find;
use File::stat;
use FileHandle;
use Getopt::Long;
use Scalar::MoreUtils qw(empty);
use Win32::Autoglob;
use Win32::File;

my $READ_SIZE = 1024 * 1024;
my $UINT_SIZE = 4;

my $help = 0;
my $man  = 0;
my $terse = 0;

GetOptions("help|?"      => \$help,
           "terse"       => \$terse,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

sub parseFile {
    my ( $thisFile ) = @_;
    my $st = stat($thisFile) or die "No file - $thisFile";
    my $attr;
    Win32::File::GetAttributes($thisFile, $attr) or die "No Attributes on file $thisFile";
    if (($attr > 0) && !($attr & DIRECTORY)) {
        my $fh = FileHandle->new($thisFile);
        my ($crc, $md5hex, $sha1hex, $firstRead, $sizeRead, $bytesRead) = (0, 0, 0, 0, 0, 0);
        if (defined $fh) {
            binmode($fh);
            my $buffer;
            my $md5 = Digest::MD5->new;
            my $sha1 = Digest::SHA1->new;
            my $readSize = $UINT_SIZE;
            while ($bytesRead = $fh->read($buffer, $readSize)) {
                $firstRead = unpack 'N', $buffer if ($readSize == $UINT_SIZE);
                $crc = Archive::Zip::computeCRC32($buffer, $crc);
                $md5->add($buffer);
                $sha1->add($buffer);
                $sizeRead += $bytesRead;
                $readSize = $READ_SIZE;
            }
            $fh->close;
            $md5hex = $md5->hexdigest;
            $sha1hex = $sha1->hexdigest;
        }
        if ($terse) {
            printf("%s,", $thisFile);
            my ($sec,$min,$hour,$mday,$mon,$year) = localtime($st->atime);
            printf("%02d/%02d/%04d,", $mon+1, $mday, $year+1900);
            printf("%02d:%02d:%02d,", $hour, $min, $sec);
            ($sec,$min,$hour,$mday,$mon,$year) = localtime($st->mtime);
            printf("%02d/%02d/%04d,", $mon+1, $mday, $year+1900);
            printf("%02d:%02d:%02d,", $hour, $min, $sec);
            ($sec,$min,$hour,$mday,$mon,$year) = localtime($st->ctime);
            printf("%02d/%02d/%04d,", $mon+1, $mday, $year+1900);
            printf("%02d:%02d:%02d,", $hour, $min, $sec);
            printf("%d,", $st->size);
            printf("%d,", $sizeRead);
            printf("%d", $st->blocks) if (!empty($st->blocks));
            print ",";
            printf("%d", $st->blksize) if (!empty($st->blksize));
            print ",";
            printf("0x%08X,", $crc);
            printf("0x%08X,", $firstRead);
            printf("%s\n", $md5hex);
            printf("%s\n", $sha1hex);
        } else {
            printf("File Name     : %s\n", $thisFile);
            my ($sec,$min,$hour,$mday,$mon,$year) = localtime($st->atime);
            printf("Date Accessed : %02d/%02d/%04d\n", $mon+1, $mday, $year+1900);
            printf("Time Accessed : %02d:%02d:%02d\n", $hour, $min, $sec);
            ($sec,$min,$hour,$mday,$mon,$year) = localtime($st->mtime);
            printf("Date Modified : %02d/%02d/%04d\n", $mon+1, $mday, $year+1900);
            printf("Time Modified : %02d:%02d:%02d\n", $hour, $min, $sec);
            ($sec,$min,$hour,$mday,$mon,$year) = localtime($st->ctime);
            printf("Date Created  : %02d/%02d/%04d\n", $mon+1, $mday, $year+1900);
            printf("Time Created  : %02d:%02d:%02d\n", $hour, $min, $sec);
            printf("Size in bytes : %d bytes\n", $st->size);
            printf("Size read     : %d bytes\n", $sizeRead);
            printf("Size in blocks: %d blocks\n", $st->blocks) if (!empty($st->blocks));
            printf("Block size    : %d bytes\n", $st->blksize) if (!empty($st->blksize));
            printf("CRC 32        : 0x%08X\n", $crc);
            printf("First 32 bits : 0x%08X\n", $firstRead);
            printf("MD5  Hash     : %s\n", $md5hex);
            printf("SHA1 Hash     : %s\n", $sha1hex);
            printf("\n");
        }
    }
}

defined($ARGV[0]) || die("Must have a file name to finger print the file.\n");
foreach my $arg (@ARGV) {
    &parseFile($arg);
}

exit 0;

__END__


__END__

=head1 NAME

FingerPrint.pl - Finger Print the specified files.

=head1 SYNOPSIS

FingerPrint.pl listOfFiles...

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

This function finger prints a set of files, giving the time and date of last
modification, CRC32, 32 bit CheckSum, MD5 and the first 4 bytes of the file.
The first 4 bytes often give us the check embedded as part of the file, such as
the Lockheed Vertical Parity Check or the Rockwell Collins CRC32 in the RC
Header.

=cut


__END__
:endofperl
