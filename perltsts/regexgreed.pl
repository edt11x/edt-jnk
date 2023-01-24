#!/usr/bin/env perl
#
$_ = 'http://www.perl.org/index.html';
if (m#^http://([^/]+)(.*)#)
{
    print "host = $1\n";
    print "path = $2\n";
}
$_ = 'ftp://ftp.uu.net/pub/';
if (m#^ftp://([^/]+)(.*)#) {
    print "host = $1\n";
    print "path = $2\n";
}

