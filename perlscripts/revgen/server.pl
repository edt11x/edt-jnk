use IO::Socket;

sub shuffleFiles {
   unlink("serve100.txt");

    for ($i = 100; $i > 1; $i--) {
        $nextFile = "serve" . ($i - 2) . ".txt";
        $thisFile = "serve" . ($i - 1) . ".txt";
        $thatFile = "serve" . $i . ".txt";
        if (($i <= 2) || (-e $nextFile))
        {
            if (-e $thisFile) {
                rename($thisFile, $thatFile);
            }
        }
    }
    rename("server.txt", "serve1.txt");
}
print "Starting TCP Lab Console Server.\n";
$sock = new IO::Socket::INET(LocalHost => 'thompe',
                            LocalPort => 1200,
                            Proto     => 'tcp',
                            Listen    => 5,
                            Reuse     => 1
                            );
print "Socket is connected.\n";
die "no sock" unless $sock;
print "Waiting on a connection.\n";
while ($new_sock = $sock->accept()) {
    print "Connection is established.\n";
    &shuffleFiles();
    open(FILE, ">>server.txt") || die("Could not open server save file\n");
    print "Trace File is Open\n";
    while (defined ($buf = <$new_sock>)) {
       print $buf;
       s/\r//g;
       print FILE $buf;
    }
    close(FILE);
}
close ($sock);
print "All Done.\n";
