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
#! /usr/bin/perl -w
#line 15
# computes and prints to stdout the CRC-32 values of the given files

use strict;
use warnings;

use lib qw( blib/lib lib );
use Archive::Zip;
use FileHandle;
use File::Glob ':glob';

my @fileList;

foreach my $arg (@ARGV)
{
    # glob each argument since we do not know if the shell will
    if ((defined($arg)) && ($arg ne ""))

    {
        my @list = bsd_glob($arg);
        foreach my $thisOne (@list)
        {
            push(@fileList, $thisOne);
        }
    }
}

my $totalFiles = scalar(@fileList);
foreach my $file (@fileList)
{
	if (-d $file)
	{
		warn "$0: ${file}: Is a directory\n";
		next;
	}
	my $fh = FileHandle->new();
	if (! $fh->open($file, 'r'))
	{
		warn "$0: $!\n";
		next;
	}
	binmode($fh);
	my $buffer;
	my $bytesRead;
	my $crc = 0;
	while ($bytesRead = $fh->read($buffer, 32768))
	{
		$crc = Archive::Zip::computeCRC32($buffer, $crc);
	}
	printf("%08x", $crc);
	print("\t$file") if ($totalFiles > 1);
	print("\n");
}

__END__
:endofperl
