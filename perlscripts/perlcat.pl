use lib 'r:/tools/PerlScripts/lib';
use File::Glob ':glob';
use Win32::Autoglob;
use File::Cat;

cat($_, \*STDOUT) for (@ARGV);

