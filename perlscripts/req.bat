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
#! /usr/bin/perl -w
#line 15

use strict;

my $line = "";
my @pieces = ();
my %defines = ();


sub abort {
    print "Abort requirements at line : $line\n";
    exit(1);
}


print "Requirements.\n";
my $totalFiles = scalar(@ARGV);
foreach my $file (@ARGV)
{
	if (-d $file) {
		warn "$0: ${file}: Is a directory\n";
		next;
    }
    open(FILE, "$file") || die("Bad file $file");
    while (<FILE>) {
        $line = $_;
        if ($line =~ /\swill\s/)
        {
            print "Bad word, I do not like -- will --\n";
            &abort();
        }
        elsif ($line =~ /\sshall\s.*\sshall\s/)
        {
            print "Multiple --shalls--, break up the requirement.\n";
            &abort();
        }          
        elsif ($line =~ /\sshall\s/)
        {
            if ($line =~ /^\s*\w+\s+shall/)
            {
                # Requirements is a definition.
                my($thisDefine, $thisDefinition) = $line =~ /^\s*(\w+)\s+shall\s+(.*)$/;
                print "+defined -- $thisDefine\n";
                if (defined($defines{$thisDefine})) {
                    print "This define is alreay defined : $thisDefine\n";
                    &abort();
                }
                $defines{$thisDefine} = $thisDefinition;
            }
            else
            {
                print "Could not decompose line with shall in it.\n";
                &abort();
            }                
        }
        else
        {
            print "Not a requirement : $line\n";
            &abort();
        }
    }
}
__END__
:endofperl
