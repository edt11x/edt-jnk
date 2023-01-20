#!/usr/bin/env perl
#
# Usage perl rmSvnDirsHere.pl .
use strict;
use warnings;

use File::Find;
use File::Path;
use File::Spec::Functions qw( catfile );

find(\&rm_dot_svn, $_) for @ARGV;

sub rm_dot_svn {
    # print "Name : ", $File::Find::name, ' and  $_ : ', $_, "\n";
    return unless -d $_;
    print "Name : ", $File::Find::name, " is a directory\n";
    print 'Checking $_ : ', $_, "\n";
    return if /^\.svn\z/;
    print "rmtree(catfile ", $_, ", .svn)\n";
    rmtree(catfile $_, '.svn');
    return;
}
