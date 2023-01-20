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
#!perl -w
#line 15
use Getopt::Long;
use File::Spec;
use Win32::Clipboard;
use Win32::NetResource;

use strict;
use warnings;
use lib 'r:/tools/PerlScripts/lib';
use Scalar::MoreUtils qw(define);

my $results = "";


sub generateUNCPath {
    my ($thisFile) = @_;
    my $absPath = File::Spec->rel2abs($thisFile);
    my $uncPath = $absPath;

    # See if we can find the drive letter
    my @pieces = split(':', $uncPath);

    if (defined($pieces[0]))
    {
        if (defined($pieces[1]))
        {
            my $drive = $pieces[0] . ':';
            my $ret;
            if (Win32::NetResource::GetUNCName($ret, $drive))
            {
                $uncPath = $ret . $pieces[1];
            }
        }
    }
    return $uncPath;
}

sub generateWikiFile {
    my ($thisFile) = @_;
    my $absPath = File::Spec->rel2abs($thisFile);
    my $wikiPath = generateUNCPath($absPath);

    # [[\\Edmund\projects\jsf-pcd\Lockheed Requirements, Documents\RFP Acronyms\JSF RFP ACRONYMS.xls|file://///Edmund/projects/jsf-pcd/Lockheed Requirements, Documents/RFP Acronyms/JSF RFP ACRONYMS.xls]] 
    $results .= "{{unc |" . $wikiPath . "|" . $absPath . "}}\n";
}

my $CLIP = Win32::Clipboard();

if (defined($ARGV[0])) {
    &generateWikiFile("$ARGV[0]");
} else {
    &generateWikiFile($CLIP->GetText()); # assume the clipboard has it
}

print "\n", $results;
$CLIP->Set($results);

exit 0;

__END__
:endofperl
