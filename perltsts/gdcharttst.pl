#! perl

use CGI ':standard';
use GD::Graph::bars;

my @data = (["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ], 
    [23, 5, 2, 20, 11, 33, 7, 31, 77, 18, 65, 52]);

my $mygraph = GD::Graph::bars->new(500, 300);

$mygraph->set(
    x_label => 'Month',
    y_label => 'Number of Hits',
    title => 'Number of Hits in Each Month') or warn $mygraph->error;

my $myimage = $mygraph->plot(\@data) or die $mygraph->error;

binmode STDOUT;

print $myimage->png;

exit 0;
