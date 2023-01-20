@rem = '--*-Perl-*--
@echo off
perl -x -S %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
@rem ';
#!perl
#line 8
use Socket;
use Sys::Hostname;
if ($ARGV[0] eq "") {
    die("Need the name of a host to cache, Usage : cache hostname\n");
}
$host = $ARGV[0];
if (gethostbyname($host) ne "")
{
    $addr = inet_ntoa(scalar(gethostbyname($host)));
    print "Host Name $host - $addr \n";
    open(FILE, ">>C:/windows/hosts") || die("Failed to open hosts file");
    print FILE "$addr   $host\n";
    close(FILE);
    open(FILE, ">>C:/windows/hosts.app") || die("Failed to open hosts append file");
    print FILE "$addr   $host\n";
    close(FILE);
}
exit(0);
__END__
:endofperl
