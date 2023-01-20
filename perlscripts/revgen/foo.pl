$this = "asdf\nasfd\nasfd\n";
@pieces = split("\n", $this);
$count = 0;
foreach (@pieces) {
    print $count, ": ", $_, "\n";
    $count++;
}
