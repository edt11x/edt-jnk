	#my $raw_image_file = $ARGV[0];
	my $raw_image_file = "tsd_replay.bmp";

	open (RAW, $raw_image_file);
	binmode(RAW);
	open (BMP, ">new_".$raw_image_file);
	binmode(RAW);

	add_header();
	copy_image();
	
	close (RAW);
	close (BMP);
	print "done\n";
	

sub add_header {
	#  0 2 signature, must be 4D42 hex
	print BMP pack('H2','42');
	print BMP pack('H2','4D');
	#  2 4 size of BMP file in bytes (unreliable)
	print BMP pack('H2','42');
	print BMP pack('H2','00');
	print BMP pack('H2','23');
	print BMP pack('H2','00');
	#  6 2 reserved, must be zero
	#  8 2 reserved, must be zero
	print BMP pack('H4','0000');
	# 10 4 offset to start of image data in bytes
	print BMP pack('H4','0000');
	print BMP pack('H2','42');
	print BMP pack('H2','00');
	# 14 4 size of BITMAPINFOHEADER structure, must be 40
	print BMP pack('H4','0000');
	print BMP pack('H2','28');
	print BMP pack('H2','00');
	# 18 4 image width in pixels
	print BMP pack('H4','0000');
	print BMP pack('H2','80');
	print BMP pack('H2','02');
	# 22 4 image height in pixels
	print BMP pack('H4','0000');
	print BMP pack('H2','80');
	print BMP pack('H2','03');
	# 26 2 number of planes in the image, must be 1
	print BMP pack('H4','0000');
	print BMP pack('H2','01');
	print BMP pack('H2','00');
	# 28 2 number of bits per pixel (1, 4, 8, or 24)
	print BMP pack('H2','20');
	print BMP pack('H2','00');
	# 30 4 compression type (0=none, 1=RLE-8, 2=RLE-4)
	print BMP pack('H4','0300');
	print BMP pack('H4','0000');
	# 34 4 size of image data in bytes (including padding)
	print BMP pack('H2','00');
	print BMP pack('H2','00');
	print BMP pack('H2','23');
	print BMP pack('H2','00');
	#  6 2 reserved, must be zero
	# 38 4 horizontal resolution in pixels per meter (unreliable)
	print BMP pack('H4','B80B');
	print BMP pack('H4','0000');
	# 42 4 vertical resolution in pixels per meter (unreliable)
	print BMP pack('H4','B80B');
	print BMP pack('H4','0000');
	# 46 4 number of colors in image, or zero
	print BMP pack('H4','0000');
	print BMP pack('H4','0000');

	print BMP pack('H4','0000');
	print BMP pack('H4','0000');
	
#	print BMP pack('H4','0000');
#	print BMP pack('H4','FF00');
	
#	print BMP pack('H4','00FF');
#	print BMP pack('H4','0000');
	
#	print BMP pack('H4','FF00');
#	print BMP pack('H4','0000');

print BMP pack('H4','FF00');
print BMP pack('H4','0000');
print BMP pack('H4','00FF');
print BMP pack('H4','0000');
print BMP pack('H4','0000');
print BMP pack('H4','FF00');


}
 
sub copy_image {

	my $template = "C C C C";
	my $pixel_size =  length ( pack( $template, () ) );
	while (read ( RAW, $pixel, $pixel_size ) ) {
		print BMP $pixel;
	} 	
	
}

