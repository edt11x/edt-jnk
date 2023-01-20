use GD;

# create a new image
$im = new GD::Image(100, 100);

# allocate some colors
$white = $im->colorAllocate(255, 255, 255);
$black = $im->colorAllocate(0, 0, 0);
$red = $im->colorAllocate(255, 0, 0);
$blue = $im->colorAllocate(0, 0, 255);

# make the background transparent and interlaced
$im->transparent($white);
$im->interlaced('true');

# put a black frame aorund the picture
$im->rectangle(0, 0, 99, 99, $black);

# draw a blue oval
$im->arc(50, 50, 95, 75, 0, 360, $blue);

$im->fill(50, 50, $red);

# make sure we are writing to a binary stream
binmode STDOUT;

# convert the image to a PNG and print it on standard output
print $im->png;

exit 0;
