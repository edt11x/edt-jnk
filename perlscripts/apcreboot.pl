#! perl

use Net::Telnet;

$telnet = new Net::Telnet( Timeout => 30, Errmode => 'die' );
$telnet->input_log('c:/tmp/foo.log');
$telnet->open('158.186.41.230');
# $telnet->output_record_separator('\r');
$telnet->waitfor('/User Name :/');
$telnet->print('apc');
$telnet->waitfor('/Password  :/');
$telnet->print('apc');
$telnet->waitfor('/1- Device Manager/');
$telnet->print('1');
$telnet->waitfor('/2- Outlet Management/');
$telnet->print('2');
$telnet->waitfor('/1- Outlet Control/');
$telnet->print('1');
$telnet->waitfor('/1- EDM #1014/');
$telnet->print('1');
$telnet->waitfor('/1- Control Outlet/');
$telnet->print('1');
$telnet->waitfor('/3- Immediate Reboot/');
$telnet->print('3');
$telnet->waitfor('/to cancel :/');
$telnet->print('YES');
$telnet->waitfor('/to continue\.\.\./');
$telnet->print('');

$telnet->close;