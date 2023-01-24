
use strict;
use Tk;

my $mw = MainWindow->new;
my $lb = $mw->Listbox("width" => 20, "height" => 20)->pack();

$lb->insert('end', 'test', 'test2', 'test3');
$mw->update;
$lb->insert('end', 'test', 'test2', 'test3');
foreach (1..100) {
   $lb->insert('end', $_);
   $mw->update;
}

MainLoop();
