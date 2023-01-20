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

use lib 'p:\edt\jnk\perlmodules';
use Net::Telnet;

sub countDown
{
    my $count = $_[0];
    my $beginTime = time;
    my $endTime = $beginTime + $count;
    my $lastPrintTime = 0;

    $| = 1;

    print "Count down $count seconds\n";
    for (;;)
    {
        my $time = time;
        last if ($time >= $endTime);

        # if we have 60 seconds left ($endTime - $time) we want to print
        # at 60 seconds and at least at 30 seconds
        # so if the difference between the last time we printed and now,
        # ($time - $lastPrintTime), is greater than half the time left
        # print something
        if (($time - $lastPrintTime) >= (($endTime - $time) / 2))
        {
            printf("%02d:%02d:%02d left\n", 
                ($endTime - $time) / (60*60),
                ($endTime - $time) / (   60) % 60,
                ($endTime - $time) % 60);
            $lastPrintTime = time;
        }
        sleep(1);
    }
}

while (1)
{
print "Initiating Power On.\n";
$telnet = new Net::Telnet( Timeout => 30, Errmode => 'die' );
$telnet->input_log('c:/tmp/foo.log');
$telnet->open('10.0.10.4');
# $telnet->output_record_separator('\r');
$telnet->waitfor('/User Name :/');
$telnet->print('apc');
$telnet->waitfor('/Password  :/');
$telnet->print('apc');
$telnet->waitfor('/apc>/');
$telnet->print('olon 1');
$telnet->waitfor('/apc>/');
$telnet->print('exit');

$telnet->close;
countDown(60);
print "Initiating Power Off.\n";
$telnet = new Net::Telnet( Timeout => 30, Errmode => 'die' );
$telnet->input_log('c:/tmp/foo.log');
$telnet->open('10.0.10.4');
# $telnet->output_record_separator('\r');
$telnet->waitfor('/User Name :/');
$telnet->print('apc');
$telnet->waitfor('/Password  :/');
$telnet->print('apc');
$telnet->waitfor('/apc>/');
$telnet->print('oloff 1');
$telnet->waitfor('/apc>/');
$telnet->print('exit');

$telnet->close;
countDown(60);
}
__END__
:endofperl
