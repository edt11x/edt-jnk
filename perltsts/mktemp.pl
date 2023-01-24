
use File::Temp qw/ tempfile tempdir /;
$dir = tempdir( DIR => '.');
print "$dir";
