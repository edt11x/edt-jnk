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
# Generate a list of files for the Release in a Comma Separated output
# so you can import it into a spreadsheet.
#
# It is in the form:
# date, time, size, full path file name
#
use strict;
use warnings;

use File::Find;
use File::stat;
use Win32::File;
use Cwd;
use FileHandle;
use Archive::Zip;
use Digest::MD5;

my @results = ();
my $outfile = "";

my $READ_SIZE = 1024 * 1024;
my $UINT_SIZE = 4;

sub wanted {
    my $thisFile = $_;
    my $thisPath = $File::Find::name;
    if (($thisFile !~ /binaries.csv/) &&
        ($thisFile !~ /sources.csv/))
    {
        my $st = stat($_) or die "No file - $thisPath";
        my $attr;
        Win32::File::GetAttributes($_, $attr) or die "No Attributes on file $thisPath";
        if (($attr > 0) && !($attr & DIRECTORY)) {
            my ($sec,$min,$hour,$mday,$mon,$year) = localtime($st->mtime);
            my $fh = FileHandle->new($thisFile);
            my $crc = 0;
            my $md5;
            my $md5hex = 0;
            my $firstRead = 0;
            if (defined $fh)
            {
                binmode($fh);
                my $buffer;
                my $bytesRead;
                $md5 = Digest::MD5->new;
                my $readSize = $UINT_SIZE;
                while ($bytesRead = $fh->read($buffer, $readSize))
                {
                    if ($readSize == $UINT_SIZE)
                    {
                        $firstRead = unpack 'N', $buffer;
                    }
                    $crc = Archive::Zip::computeCRC32($buffer, $crc);
                    $md5->add($buffer);
                    $readSize = $READ_SIZE;
                }
                $fh->close;
                $md5hex = $md5->hexdigest;
            }
            push(@results, sprintf("%02d/%02d/%04d, %02d:%02d:%02d, %d, 0x%08X, 0x%08X, %s, %s\n",
                $mon+1, $mday, $year+1900, $hour, $min, $sec, $st->size, $crc, $firstRead, $md5hex, $thisPath));
        }
    }
}

my $dir = getcwd();
if (defined($ARGV[0])) {
    chdir $ARGV[0];
}
$outfile = $ARGV[1];
find(\&wanted, '.');
chdir $dir;

# do not print the results until after all the files have been found
if (defined($outfile))
{
    open OUT, ">" . "$outfile" or die "No File $outfile : $!";
    print OUT "Date, Time, Size in Bytes, CRC, First 4 bytes, MD5, File Path\n";
    print OUT @results;
    close OUT;
}
else
{
    print "Date, Time, Size in Bytes, CRC, First 4 bytes, MD5, File Path\n";
    print @results;
}

exit 0;
__END__


__END__
:endofperl
