
@thisList = ();
$lastTime = time;
foreach (1..10000) {
   @thisList = (@thisList, $_);
}
$thisTime = time;
print "Array assignment took ", $thisTime - $lastTime, " seconds.\n";

@thisList = ();
$lastTime = time;
foreach (1..10000) {
   push(@thisList, $_);
}
$thisTime = time;
print "Array assignment took ", $thisTime - $lastTime, " seconds.\n";
