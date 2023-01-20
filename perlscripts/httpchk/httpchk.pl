use strict;
use LWP::UserAgent;
use HTTP::Request;

sub getWebPage {
my($thisWebPage) = @_;
my($thisResponse);
my($ua);
my($request);
my($response);

	$ua = new LWP::UserAgent;
	$request = new HTTP::Request 'GET', "$thisWebPage";
	$response = $ua->request($request);

	if ($response->is_success) {
	     $thisResponse = $response->content;
	} else {
	     $thisResponse = $response->error_as_HTML;
	}
	return $thisResponse;
}

my($thisOne);
my(@list);
my(%hash);
my($i);
my($thisChk);

# $thisOne = &getWebPage("http://www.infinet.com/~edt/hobby.html");
$thisOne = &getWebPage("http://www.infinet.com/~edt/page2.html");

# Lets break that up into http addresses
# first we want to find anything starting with "http://" 
# it can be finished with any space, quote, etc.

@list = split(' ', $thisOne);
foreach $i (@list) {
   if ($i =~ /http:/) {
	$i =~ s/^.*[Hh][Tt][Tt][Pp]:\/\//http:\/\//;
        $i =~ s/[\'\"()<>].*$//;
        $hash{$i} = $i;
   }
}
open(FILE, ">>output") || die("cant open output file");
for $i (sort values %hash) {
	print "Checking : ", $i, "\n";
        $thisChk = &getWebPage($i);
        if (length($thisChk) < 1000) {
		print "Problems with : $i\n";
		print "The text returned was:\n";
		print $thisChk, "\n";
		print FILE ("=" x 79), "\n\n";
		print FILE "Problems with : $i\n";
		print FILE "The text returned was:\n";
		print FILE $thisChk, "\n\n";
	}
	sleep 5;
}
close(FILE);
