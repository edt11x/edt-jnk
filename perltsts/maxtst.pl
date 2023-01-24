#! perl
#
use strict;
use warnings;

use List::Util qw( min max );
use POSIX;

my @arr;

print "Print the max value of an empty array\n";
if ( !defined(max(@arr)) ) {
    print "It correctly returned undef\n";
} else {
    print "It returned something else\n";
}

print "Does int(max(undef)) correctly return undef?\n";
if ( !defined(int(max(@arr))) ) {
    print "It correctly returned undef\n";
} else {
    print "It returned something else - ", int(max(@arr)), "\n";
}

print "Does floor(max(undef) correctly return undef?\n";
if ( !defined(floor(max(@arr))) ) {
    print "It correctly returned undef\n";
} else {
    print "It returned something else - ", floor(max(@arr)), "\n";
}



exit 0;

