use Net::TFTP;
use strict;

my $tftp = Net::TFTP->new("158.186.37.205", BlockSize => 8192);

$tftp->binary;

$tftp->put("foo.txt", "foo.txt");

my $err = $tftp->error;

print $err, "\n";

print "All done.\n";
