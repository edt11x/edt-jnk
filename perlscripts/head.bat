@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#!/usr/local/bin/perl -w
#line 15

#
# $Id: head,v 1.1.1.1 2001/06/06 08:54:01 sdague Exp $
#
# $Log: head,v $
# Revision 1.1.1.1  2001/06/06 08:54:01  sdague
# initial import
#
# Revision 1.1  2001/05/14 00:49:39  sdague
# added more files
#
# Revision 1.4  1999/03/02 17:37:26  abigail
# Added __DIE__ handler. Simplified dying on illegal count arguments.
#
# Revision 1.3  1999/03/02 17:28:39  abigail
# Provided support for reading from STDIN if no arguments are given.
#
# Revision 1.2  1999/02/26 18:39:59  abigail
# Fixed usage message.
#
# Revision 1.1  1999/02/26 18:38:59  abigail
# Initial revision
#
#

use strict;
use Getopt::Std;

my ($VERSION) = '$Revision: 1.1.1.1 $' =~ /([.\d]+)/;

END {
    close STDOUT || die "can't close stdout: $!\n";
    $? = 1 if $? == 255;  # from die
}

my $warnings = 0;
# Print a usage message on a unknown option.
# Requires my patch to Getopt::Std of 25 Feb 1999.
$SIG {__WARN__} = sub {
    if (substr ($_ [0], 0, 14) eq "Unknown option") {die "Usage"};
    require File::Basename;
    $0 = File::Basename::basename ($0);
    $warnings = 1;
    warn "$0: @_";
};

$SIG {__DIE__} = sub {
    require File::Basename;
    $0 = File::Basename::basename ($0);
    if (substr ($_ [0], 0,  5) eq "Usage") {
        die <<EOF;
$0 (Perl bin utils) $VERSION
$0 [-n count] [files ...]
EOF
    }
    die "$0: @_";
};

# Get the options.
getopts ('n:', \my %options);

my $count = defined $options {n} ? $options {n} : 10;

die "invalid number `$count'\n" if $count =~ /\D/;

@ARGV = '-' unless @ARGV;

foreach my $file (@ARGV) {
    local *FILE;
    open FILE, $file or do {
        $0 =~ s{.*/}{};
        warn "$0: $file: $!\n";
        next;
    };
    print "==> ${$file eq '-' ? \'standard input' : \$file} <==\n" if @ARGV > 1;
    my $c = $count;
    while ($c -- && defined ($_ = <FILE>)) {print}
    close FILE;
}

__END__


=head1 NAME

head -- print the first lines of a file.

=head1 SYNOPSIS

head [-n count] [files ...]

=head1 DESCRIPTION

I<head> prints the first I<count> lines from each file. If the I<-n> is
not given, the first 10 lines will be printed. If no files are given,
the first lines of standard input will be printed.

=head2 OPTIONS

I<head> accepts the following options:

=over 4

=item -n count

Print I<count> lines instead of the default 10.

=back

=head1 ENVIRONMENT

The working of I<head> is not influenced by any environment variables.

=head1 BUGS

I<head> has no known bugs.

=head1 STANDARDS

This I<head> implementation is compliant with the B<IEEE Std1003.2-1992>
specification, also known as B<POSIX.2>.

This I<head> implementation is compatible with the B<OpenBSD> implementation.

=head1 REVISION HISTORY

    $Log: head,v $
    Revision 1.1.1.1  2001/06/06 08:54:01  sdague
    initial import

    Revision 1.1  2001/05/14 00:49:39  sdague
    added more files

    Revision 1.4  1999/03/02 17:37:26  abigail
    Added __DIE__ handler. Simplified dying on illegal count arguments.

    Revision 1.3  1999/03/02 17:28:39  abigail
    Provided support for reading from STDIN if no arguments are given.

    Revision 1.2  1999/02/26 18:39:59  abigail
    Fixed usage message.

    Revision 1.1  1999/02/26 18:38:59  abigail
    Initial revision

=head1 AUTHOR

The Perl implementation of I<head> was written by Abigail, I<abigail@fnx.com>.

=head1 COPYRIGHT and LICENSE

This program is copyright by Abigail 1999.

This program is free and open software. You may use, copy, modify, distribute
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others to do the same.

=cut


__END__
:endofperl
