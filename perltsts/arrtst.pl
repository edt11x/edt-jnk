#! perl
#
my @arr = ( 1 .. 100 );

print "Size      of the  array should be 100 : ", scalar(@arr), "\n";
print "Max index of the  array should be  99 : ", $#arr, "\n";

my @emptyArr;

print "Size      of empty array should be  0 : ", scalar(@emptyArr), "\n";
print "Max index of empty array should be -1 : ", $#emptyArr, "\n";

exit 0;

