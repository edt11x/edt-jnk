use strict;

# open FILE, "<preload_texture_data.h" or die $!;
open FILE, "<foo.h" or die $!;
my @file = <FILE>;
close FILE or die $!;

my $in_block = 0;
my $regex = 'initial_texture_data';
my $byte_line = '';
my @dword_entries;
foreach my $line (@file) {
    chomp $line;

    if ( $line =~ /$regex/ ) {
        $in_block = 1;
        print "Got it\n";
        next;
    }

    if ( $in_block ) {
        my @digits = @{ match_digits($line) };
        # print @digits, "\n";
        push @dword_entries, @digits;
    }

    if ( $line =~ /\}/ ) {
        $in_block = 0;
    }
}

# print "const BYTE Some_Idx_Mod_mul_2[] = {\n";
# print join ",", map { $_ * 2 } @dword_entries;
# print "};\n";

printf("Size of the array is 0x%08X\n", $#dword_entries * 4);

sub match_digits {
    my $text = shift;
    my @digits;
    # print "Text - $text\n";
    while ( $text =~ /0x([[:xdigit:]]+),*/g ) {
        # print $1, "\n";
        push @digits, $1;
    }

    return \@digits;
}

