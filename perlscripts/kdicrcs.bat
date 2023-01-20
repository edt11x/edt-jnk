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
#!perl -w
#line 15

use strict;
use warnings;

my $buffer = "";
my $crc    = 0;

open KDI, "<kdi" or die "Can not open kdi file: $!";
binmode(KDI);
sysread(KDI, $buffer, 4) or die "Can not read kdi CRC : $!";
$crc = unpack 'N', $buffer;
printf("kdi     CRC - 0x%08X\n", $crc);
close(KDI);

open LOCALFS, "<localfs" or die "Can not open localfs file: $!";
binmode(LOCALFS);
sysread(LOCALFS, $buffer, 4) or die "Can not read localfs CRC : $!";
$crc = unpack 'N', $buffer;
printf("localfs CRC - 0x%08X\n", $crc);
close(LOCALFS);

open USRFS, "<usrfs" or die "Can not open usrfs file: $!";
binmode(USRFS);
sysread(USRFS, $buffer, 4) or die "Can not read usrfs CRC : $!";
$crc = unpack 'N', $buffer;
printf("usrfs   CRC - 0x%08X\n", $crc);
close(USRFS);

exit(0);

__END__
:endofperl
