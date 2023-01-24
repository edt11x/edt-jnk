
use strict;
use Tk;

my $size = 200;
my $edge = 10;
my $center = $edge / 2 + $size / 2;
my $firstDone = 0;
my $thisLine;

my $mw        = MainWindow->new;
my $cv        = $mw->Canvas(width => $size + $edge, height => $size + $edge)->pack();
my $thisAngle = 0.0;

while (1) {

    $cv->create('oval',  $edge / 2, $edge / 2,  $size + $edge / 2, $size + $edge / 2, fill => 'SeaGreen4');
    $cv->create('line',  $edge / 2, $center, $size + $edge / 2, $center,  fill => 'green3');
    $cv->create('line', $center, $edge / 2,  $center,  $size + $edge / 2, fill => 'green3');
    foreach (0..180) {
        if ($firstDone) {
	    $cv->delete($thisLine);
	}
        $thisAngle = $_ / 180.0 * 2 * 3.1415926;
        $thisLine = $cv->create('line', $center, $center, $center + sin($thisAngle) * $size / 2, $center - cos($thisAngle) * $size / 2, 
    	fill => 'green3');
        $mw->update;
	$firstDone = 1;
    }
}
exit 0;
