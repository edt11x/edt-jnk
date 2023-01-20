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
#! perl
#line 15

use lib 'r:/tools/PerlScripts/lib';

use Net::Telnet;

$telnet = new Net::Telnet( Timeout => 30, Errmode => 'die', Port => 5024 );
$telnet->input_log('c:/temp/RedBoard1PS.log');
$telnet->open('148.104.99.224');
# $telnet->output_record_separator('\r');
$telnet->waitfor('/SCPI> /');
$telnet->print('*IDN?');
$telnet->waitfor('/SCPI> /');
$telnet->print('OUTPut:STATe 0');
$telnet->waitfor('/SCPI> /');
$telnet->print('SOURce:CURRent 40.0');
$telnet->waitfor('/SCPI> /');
$telnet->print('SOURce:CURRent:PROTection:STATe 1');
$telnet->waitfor('/SCPI> /');
$telnet->print('SOURce:VOLTage 5.0');
$telnet->waitfor('/SCPI> /');
$telnet->print('OUTPut:STATe 0');
$telnet->waitfor('/SCPI> /');
$telnet->print('MEASure:CURRent?');
$telnet->waitfor('/SCPI> /');
$telnet->print('MEASure:VOLTage?');
$telnet->waitfor('/SCPI> /');
$telnet->print('');

$telnet->close;

open(FILE, 'c:/temp/RedBoard1PS.log') || die('No log');
while (<FILE>) {
    print $_;
}
close(FILE);

__END__
:endofperl
