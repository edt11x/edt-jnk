#! perl
# Calculate OTP Cheap Hash Values
use strict;
use warnings;
use integer;

use Getopt::Long;

my $NUM_BITS = 32;
my $ALL_BITS = -1;
my $help = 0;
my $man = 0;
my $test = 0;
my $find;

GetOptions("help|?"      => \$help,
           "find=s"      => \$find,
           "test"        => \$test,
           "man"         => \$man) or pod2usage(2);
pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

sub sr { # shift right, zero fill
    my ($p, $q) = @_;
    return ($p >> $q) & ~($ALL_BITS << ($NUM_BITS - $q));
}

sub otp_cheap_hash32 {
    my $key = $_[0];
    $key = ~$key + ($key << 15);  # key = (key << 15) - key - 1;
    $key = $key ^ sr($key,12);
    $key = $key + ($key << 2);
    $key = $key ^ sr($key,4);
    $key = $key * 2057;           # key = (key + (key << 3)) + (key << 11);
    $key = $key ^ sr($key,16);
    return $key;
}

sub parseArguments {
    printf "Hash of %s is 0x%08X\n", $_, otp_cheap_hash32(hex($_)) for @_;
}

if ($test) {
    for (my $i = 0xFE000000; $i < 0xFFFFFFFF; $i++) {
        printf("0x%08X - 0x%08X\n", $i, otp_cheap_hash32($i));
    }
} elsif (defined($find)) {
    my $findThis = hex($find);
    my $found = 0;
    for (my $i = 0; $i < 0xFFFFFFFF; $i++) {
        if ($findThis == otp_cheap_hash($i)) {
            printf "Match found at 0x%08X\n", $i;
            $found = 1;
        }
    }
    printf "No match for 0x%08X\n", $findThis if ($found != 1);
} else {
    parseArguments(@ARGV);
}
exit 0;

__END__

=head1 NAME

otpCheapHash.pl - Calculate OTP Cheap Hash Values

=head1 SYNOPSIS

otpCheapHash.pl 

    Options:
      --help        brief help message
      --man         manual page

=head1 OPTIONS

=over 8

=item B<help>

Print a brief help message and exit.

=item B<man>

Print the manual page and exit.

=back

=head1 DESCRIPTION

This program calculates the OTP Cheap Hash values from the command lines.

=cut

