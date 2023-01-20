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
    if ($thisFile !~ /\/\.svn/) {
        Win32::File::GetAttributes($_, $attr) or die "No Attributes on file $thisFile";
        if (($attr > 0) && ($attr & DIRECTORY))
        {
            print $thisFile, "\n";
        }
   }
}

find(\&wanted, '.');
__END__
:endofperl
