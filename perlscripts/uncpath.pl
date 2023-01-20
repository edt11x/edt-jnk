#!perl -w
use Getopt::Long;
use File::Spec;
use Win32::Clipboard;
use Win32::NetResource;

use strict;

my $results = "";

sub generateWikiFile {
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
    $results = $uncPath;
}

defined($ARGV[0]) || die("Must have at least one file for wikiFile\n");

# my @fileList = glob "@ARGV";
# 
# foreach (@fileList) {
#     &generateWikiFile($_);
# }

&generateWikiFile("$ARGV[0]");

my $CLIP = Win32::Clipboard();

print "\n", $results;
$CLIP->Set($results);

exit 0;
