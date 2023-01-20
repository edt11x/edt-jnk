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
use File::Basename;
use File::Copy;
use File::Spec;
use Win32::Clipboard;
use Win32::NetResource;

use strict;
use warnings;
use lib 'r:/tools/PerlScripts/lib';
use Scalar::MoreUtils qw(define);

my $results = "";


sub generateWikiImage {
    my ($thisFile) = @_;
    my $baseFile = basename($thisFile);
    my $imageFile = "R:/design/images/" . $baseFile;
    if (! -e $imageFile) {
        copy($thisFile, $imageFile) or die("Can not copy file : $!");
    }
    # system("svn add $imageFile") or die("Can not svn add file : $!");
    system("svn add $imageFile");
    $results .= "<html><img src=\"images/$baseFile\" width=\"98%\" height=\"98%\"/></html>";
}

my $CLIP = Win32::Clipboard();

if (defined($ARGV[0])) {
    &generateWikiImage("$ARGV[0]");
} else {
    &generateWikiImage($CLIP->GetText()); # assume the clipboard has it
}

print "\n", $results;
$CLIP->Set($results);

exit 0;

__END__
:endofperl
