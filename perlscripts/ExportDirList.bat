@perl -w -S -x %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
@goto endofperl
#!perl
#
# Get a list of the directories for exporting for deployment
#
use File::Find;
use File::stat;
use Win32::File;

sub wanted {
    $thisFile = $File::Find::name;
    # we do not want .svn files
    if (($thisFile !~ /\/\.svn/) && ($thisFile ne ".")) {
        $thisFile =~ s/\//\\/g;
        Win32::File::GetAttributes($_, $attr) or die "No Attributes on file $thisFile";
        if (($attr > 0) && ($attr & DIRECTORY)) {
            print "mkdir $where\\$thisFile", "\n";
        }
   }
}

$where = $ARGV[0];

if ((!defined($where)) || ($where eq ""))
{
    print "I need some path to continue.\n";
    print "ExportDirList destination_directory_to_export_to\n";
    exit(1);
} 

find(\&wanted, '.');
__END__
:endofperl
