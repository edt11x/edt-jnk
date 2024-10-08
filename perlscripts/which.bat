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
# $Id: which,v 1.1.1.1 2001/06/06 08:55:22 sdague Exp $
#
# $Log: which,v $
# Revision 1.1.1.1  2001/06/06 08:55:22  sdague
# initial import
#
# Revision 1.1  2001/05/14 00:49:40  sdague
# added more files
#
# Revision 1.1  1999/02/25 04:57:21  abigail
# Initial revision
#

use strict;

my ($VERSION) = '$Revision: 1.1.1.1 $' =~ /([.\d]+)/;

my $opt_a = 0;

if (@ARGV) {
    if ($ARGV [0] eq '-a') {
        $opt_a = 1;
    }
    if ($ARGV [0] eq '--version') {
        $0 =~ s{.*/}{};
        print "$0 (Perl bin utils) $VERSION\n";
        exit;
    }
    if ($ARGV [0] eq '--help') {
        $0 =~ s{.*/}{};
        print <<EOF;
Usage: $0 [OPTION] [COMMAND [COMMAND [COMMAND ... ]]]

For each command, report the full path to this command, if any.

Options:
       --version:  Print version number, then exit.
       --help:     Print usage, then exit.
       --:         Stop parsing options.
EOF
        exit;
    }
    if ($ARGV [0] eq '--') {
        shift;
    }
}

# set up defaults.
my @PATH = ();
my $PATHVAR = 'PATH';
my $path_sep = ':';
my $file_sep = '/';
my @PATHEXT = ();

my $Is_DOSish = ($^O eq 'MSWin32') ||
                ($^O eq 'dos') ||
                ($^O eq 'os2') ;

if ($Is_DOSish) {
    $path_sep = ';';
}
if ($^O eq 'MacOS') {
    $path_sep = '\,';
    $PATHVAR = 'Commands';
    # since $ENV{Commands} contains a trailing ':'
    # we don't need it here:
    $file_sep = '';
}

# Split the path.
if (defined($ENV{$PATHVAR})) {
    @PATH = split /$path_sep/ => $ENV{$PATHVAR};
}
# Add OS dependent elements.
if ($^O eq 'VMS') {
    my $i = 0;
    my $path_element = undef;
    while (defined($path_element = $ENV{"DCL\$PATH;$i"})) {
        push(@PATH, $path_element);
        $i++;
    }
    # PATH may be a search list too
    $i = 0;
    $path_element = undef;
    while (defined($path_element = $ENV{"PATH;$i"})) {
        push(@PATH, $path_element);
        $i++;
    }
    # PATH and DCL$PATH are likely to use native dirspecs.
    $file_sep = '';
}

# trailing file types (NT/VMS)
if (defined($ENV{PATHEXT})) {
    @PATHEXT = split /$path_sep/ => $ENV{PATHEXT};
}
if ($^O eq 'VMS') { @PATHEXT = qw(.exe .com); }

COMMAND:
foreach my $command (@ARGV) {
    if ($^O eq 'VMS') {
        my $symbol = `SHOW SYMBOL $command`; # line feed returned
        if (!$?) {
            print "$symbol";
            next COMMAND unless $opt_a;
        }
    }
    if ($^O eq 'MacOS') {
        my @aliases = split /$path_sep/ => $ENV{Aliases};
        foreach my $alias (@aliases) {
            if (lc($alias) eq lc($command)) {
                # MPW-Perl cannot resolve using `Alias $alias`
                print "Alias $alias\n";
                next COMMAND unless $opt_a;
            }
        }
    }
    foreach my $dir (@PATH) {
        if ($^O eq 'MacOS') {
            if (-e "$dir$file_sep$command") {
                print "$dir$file_sep$command\n";
                next COMMAND unless $opt_a;
            }
        }
        else {
            if (-x "$dir$file_sep$command") {
                print "$dir$file_sep$command\n";
                next COMMAND unless $opt_a;
            }
        }
        if (@PATHEXT) {
            foreach my $ext (@PATHEXT) {
                if (-x "$dir$file_sep$command$ext") {
                    print "$dir$file_sep$command$ext\n";
                    next COMMAND unless $opt_a;
                }
            }
        }
    }
}

__END__


=head1 NAME

which -- report full paths of commands.

=head1 SYNOPSIS

which [option] [commands]

=head1 DESCRIPTION

I<which> prints the full paths to the commands given as arguments,
depending on the I<$PATH> environment variable.  Nothing is printed if
the command is not found.

=head2 OPTIONS

I<which> accepts the following options:

=over 4

=item --help

Print out a short help message, then exit.

=item --version

Print out its version number, then exit.

=item -a

Print out all instances of command on I<$PATH> not just the first.

=item --

Stop parsing for options. Useful if you want to find where in your path
the commands I<--help>, I<-a>, and I<--version> are found.
Use I<which -- --> to find the path to I<-->.

=back

=head1 ENVIRONMENT

The environment variable I<$PATH> (also I<DCL$PATH> under DCL; or
I<$Commands> under MPW) is used to find the list of directories
to check for commands.  The variable I<%PATHEXT%> is examined for
command extensions if it exists.

=head1 BUGS

I<which> has no known bugs.

=head1 COMPATABILITY

Traditionally, I<which> also parses ones F<~/.cshrc> file to look for
aliases, and reporting the alias when applicable. This version of
I<which> does not do that, because there are more shells than I<csh>.

I<which> will examine aliases under MPW (Mac) and symbols under DCL
(VMS).

=head1 REVISION HISTORY

    $Log: which,v $
    Revision 1.1.1.1  2001/06/06 08:55:22  sdague
    initial import

    Revision 1.1  2001/05/14 00:49:40  sdague
    added more files

    Revision 1.1  1999/02/25 04:57:21  abigail
    Initial revision

=head1 AUTHOR

The Perl implementation of I<which> was written by Abigail, I<abigail@fnx.com>.
Portability enhancements by Peter Prymmer.

=head1 COPYRIGHT and LICENSE

This program is copyright by Abigail 1999.

This program is free and open software. You may use, modify, distribute
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others to do the same.

=cut



__END__
:endofperl
