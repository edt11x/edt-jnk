package GlobArgv;
use strict;

@ARGV = map { glob } @ARGV;
1;

__END__

=head1 NAME

GlobArgv - Enables Win32 One-Liners to Use Filename Wildcards

=head1 SYNOPSIS

perl -MGlobArgv -ne "print if /pattern/" *.csv
perl -MGlobArgv -i.bak -pe "s/old/new/i" *.txt single.log

=head1 DESCRIPTION

Quick and dirty package to expand filenames containing
wildcards passed as command line arguments. Win32 shells
(CMD, 4NT) do not resolve wildcards by default.

A module is used to force the expansion of command line arguments
before the implicit "while (<>)" loop.

=head1 BUGS AND LIMITATIONS

Very simple minded -- assumes everything on the command line
is a filename that wants to be expanded.

=head1 AUTHOR

Keith S. Kiyohara, <kkiyohara@hotmail.com>

=cut


