
use Tk;

$top = MainWindow->new();
$top->title ("Simple");

$l = $top->Label(text  => 'Hello World',
		anchor => 'n',
		relief => 'groove',
		width  => 10, height => 3);
		  
$l->pack(-side => 'left', -fill => 'y', -expand => 'y');
$canvas = $top->Canvas(width => 200, height => 100)->pack();
$top->Label(
    -image => $canvas->Photo('image1a' -file => Tk->findINC('earthris.gif')),
                  -borderwidth => 2,
                  -relief      => 'sunken',
                  -width       => 100,
                  -height      => 100
                  )->pack();
$canvas->create('line', 1, 1, 100, 100, fill => 'yellow');
$canvas->create('line', 1, 100, 100, 1, fill => 'yellow');

#   my $right_bitmap = $right->Label(
#       -image       => $TOP->Photo(-file => Tk->findINC('Xcamel.gif')),
#       -borderwidth => 2,
#       -relief      => 'sunken',
#   )->pack(@pl);

MainLoop();

