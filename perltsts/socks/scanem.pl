#!/usr/local/bin/perl -w

use strict;

use Net::SOCKS;

my($i)           = 0;
my($j)           = 0;
my($sock)        = "";
my($f)           = "";
my($thisAddress) = "";

for ($i=2; $i < 4; $i++) {
    for ($j = 65; $j < 256; $j++) {
        $thisAddress = "170.126." . ($i + 216) . "." . $j;

        print "Attempting to connect to user2.infinet.com at port 23 using the socks\n";
        print "server at $thisAddress port 1080\n";

        $sock = new Net::SOCKS(socks_addr => "$thisAddress",
                        socks_port => 1080,
                        #user_id => 'the_user',
                        #user_password => 'the_password',
                        #force_nonanonymous => 1, 
                        protocol_version => 5);
        $f= $sock->connect(peer_addr => '206.103.240.10', peer_port => 23);
        print "connect status: ",
                Net::SOCKS::status_message($sock->param('status_num')), "\n";
        if ($sock->param('status_num') == SOCKS_OKAY) {
            print "Success\n";
            exit 0;
        }
        $sock->close();
    }
}

