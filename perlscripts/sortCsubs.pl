#!/usr/bin/env perl
use strict;
use warnings;

sub parseFile {
my ($thisFile)    = @_;
my @nonBlankLines = ();
my @blankLines = ();
my @subLines = ();
my $subName;
my %hashOfArrays = ();
my $braceCount = 0;

    open(FILE, "$thisFile") || die("no file $thisFile : $!");
    while (<FILE>) {
        chomp;
        my $line = $_;
        if (defined($subName)) { # if we are inside a name subroutine
            push(@subLines, $line);
            if ($line =~ /^\s*{\s*$/) { # opening brace, deal with the subroutine
                $braceCount++;
            }
            elsif ($line =~ /^\s*}\s*$/) { # closing brace, deal with the subroutine
                $braceCount--;
                if ($braceCount == 0) {
                    # print $_ . "\n" for (@blankLines, @nonBlankLines, @subLines);
                    $hashOfArrays{$subName} = [ @blankLines, @nonBlankLines, @subLines ];
                    @blankLines = ();
                    @nonBlankLines = ();
                    @subLines = ();
                    $subName = undef;
                }
            }
        } elsif (/^(\w+\s+)+\*?\s*([\w_]+)\s*\(.*\)\s*$/) { # found a subroutine
            $subName = $2;
            push(@subLines, $line);
        } elsif (/^\s*$/) { # blank line
            if (@nonBlankLines) {
                print $_ . "\n" for (@blankLines, @nonBlankLines);
                @blankLines = ();
                @nonBlankLines = ();
            }
            push(@blankLines, $line);
        } else {
            # print $_ . "\n" for (@blankLines);
            # @blankLines = ();
            push(@nonBlankLines, $line);
        }
    }
    for my $key (sort keys %hashOfArrays) {
        print $_ . "\n" for (@{$hashOfArrays{$key}});
    }
    print $_ . "\n" for (@blankLines, @nonBlankLines); # print any block we are holding
    close(FILE);
}

my @args = splice(@ARGV, 0);
foreach my $arg (@args)
{
    &parseFile($arg);
}
