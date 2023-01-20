use strict;

my $trailer = 0;

for ($trailer = 0; $trailer < 1000000000; $trailer += 128)
{
    if (int((2 * $trailer + 0x160) / 128) * 128 == (2 * $trailer + 0x160))
    {
        print "Solution, trailer == $trailer\n";
    }
}
