#! perl

use strict;
use warnings;

# I needed to add a partion that ran without the kernel but had the Network
# stack. The problem is that if the kernel is consumed with processing
# errors, the GHNet stack can not get enough time to send out the errors.
my $minSlice         = 0.00001;
my $slicePercision   = 1000000.0;
my $majorFramePeriod = 0.0166667;
my @partitionOne    = ( "partitionOne",    92, 73, 2, "driver", "client1" );
my @partitionThree  = ( "partitionThree",  33, 75, 2, "driver", "client3" );
my @partitionFive   = ( "partitionFive",   84, 77, 3, "driver", "KernelSpace", "client5" );
my @partitionSix    = ( "partitionSix",    11, 78, 3, "driver", "KernelSpace", "client6" );
my @partitionSeven  = ( "partitionSeven",  44, 79, 2, "driver", "client7" );
my @partitionEight  = ( "partitionEight",  44, 79, 2, "driver", "client8" );
my @partitionNine   = ( "partitionNine",    1, 79, 5, "driver", "KernelSpace", "client9", "ghnet2Stack", "network_client" );
my @partitionTen    = ( "partitionTen",     1, 79, 5, "driver", "KernelSpace", "client10", "ghnet2Stack", "network_client" );
my @partitionEleven = ( "partitionEleven",  8, 79, 4, "driver", "KernelSpace", "ghnet2Stack", "network_client" );
my @partitionTwelve = ( "partitionTwelve",  4, 79, 3, "driver", "ghnet2Stack", "network_client" ); # a small amount of time without the kernel

my @listOfPartitions = ( \@partitionOne, \@partitionThree, \@partitionFive, \@partitionSix, \@partitionSeven, \@partitionEight, \@partitionNine, \@partitionTen, \@partitionEleven, \@partitionTwelve);

my %slicesLeft = ();

my $totalSliceCount     = 0;
my $totalPossibleSlices = 0;

foreach my $j (@listOfPartitions)
{
    $slicesLeft{$j->[0]} = $j->[1];
}

# Add up the total number of partition slices we would like
foreach my $i (@listOfPartitions)
{
    print "# Processing ", $i->[0], " requested slices - ", $i->[1], "\n";
    $totalSliceCount += $i->[1];
}
print "# Total Slices - $totalSliceCount\n";
$totalPossibleSlices = int($majorFramePeriod / $minSlice);
print "# Total Possible Slices - ", $totalPossibleSlices, "\n";
if ($totalSliceCount > $totalPossibleSlices)
{
    print "The total slice count is greater than total possible slices, no solution, abort.\n";
    exit(1);
}

$minSlice = int($majorFramePeriod * $slicePercision / $totalSliceCount);
print "# New minimum slice is ", $minSlice, "\n";
my $currentOffset = 0;

print "    PartitionSchedule Three\n";
print "        MajorFramePeriod $majorFramePeriod\n";
print "        FrameReleaseNotification 72\n";

for (my $i = 0; $i < $totalSliceCount; $i++)
{
    # my $maxCountFound = 0;
    # my $foundRef;
# Search through the list and find one with the most slices left
    # foreach my $j (@listOfPartitions)
    # {
    #    if ($j->[1] > $maxCountFound)
    #    {
    #        $maxCountFound = $j->[1];
    #        $foundRef        = $j;
    #    }
    #}
# Look to see if any ideal slice matches the current slice
    my $foundRef;
    my $foundCount = 0;
    for (my $k = 0; $k < $i; $k++)
    {
        foreach my $j (@listOfPartitions)
        {
            # If there are slices left in this partition
            if ($slicesLeft{$j->[0]} > 0)
            {
                my $idealSlot = int($totalSliceCount * ( $j->[1] - $slicesLeft{$j->[0]} ) / $j->[1]);
                if (($foundCount == 0) && ($idealSlot == $k))
                {
                    # If this is partition 3 then wait until all the partition 1 slieces are used up
                    # if (($j != \@partitionThree) || ($slicesLeft{$partitionOne[0]} == 0))
                    {
                        $foundCount = $j->[1];
                        $foundRef   = $j;
                    }
                }
            }
        }
    }
    for (my $k = $i; $k < $totalSliceCount; $k++)
    {
        foreach my $j (@listOfPartitions)
        {
            # If there are slices left in this partition
            if ($slicesLeft{$j->[0]} > 0)
            {
                my $idealSlot = int($totalSliceCount * ( $j->[1] - $slicesLeft{$j->[0]} ) / $j->[1]);
                if (($foundCount == 0) && ($idealSlot == $k))
                {
                    # if (($j != \@partitionThree) || ($slicesLeft{$partitionOne[0]} == 0))
                    {
                        $foundCount = $j->[1];
                        $foundRef   = $j;
                    }
                }
            }
        }
    }
    print "\n";
    print "        Partition ", $foundRef->[0] .  $slicesLeft{$foundRef->[0]}, "\n";
    print "\n";
    print "            PartitionReleaseNotification ", $foundRef->[2], "\n";
    print "\n";
    for (my $j = 0; $j < $foundRef->[3]; $j++)
    {
        print "            AddressSpace ", $foundRef->[4+$j], "\n";
    }
    print "\n";
    print "            Offset ", sprintf("%.7f", $currentOffset / $slicePercision), "\n";
    print "            ExecTime ", sprintf("%.7f", $minSlice / $slicePercision), "\n";
    print "\n";
    print "        EndPartition\n";
    # $foundRef->[1] -= 1;
    $slicesLeft{$foundRef->[0]} -= 1;
    $currentOffset += $minSlice;
}
print "    EndPartitionSchedule Three\n";

