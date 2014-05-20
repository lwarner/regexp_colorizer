#!/usr/bin/perl -w

use strict;
use Digest::MD5 qw(md5);



sub color_ids {
    my @color_strings = ();
    for my $foreground ( 31 .. 37 ) {
	for my $background ( 40 .. 47 ) {
	    push(@color_strings, "[0;$background;${foreground}m");
	}
    }
    return @color_strings;
}
my @color_ids = &color_ids;

sub numberize {
	unpack('L', md5($_[0]));
}

sub colorize {
    my $uuid = $_[0];
    my $index = &numberize($uuid) % @color_ids;
    my $color_code = $color_ids[$index];
    my $set_color = "$color_code";
    my $reset_color = "\033[0m";
    return "$set_color$_[0]$reset_color";
}


sub main  {
    while (<>) {
	if (/(^.*)([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12})(.*$)/)  {
	    my ($start, $uuidstring, $end) = ($1, $2, $3);
	    print $start, &colorize($uuidstring), $end, "\n";
	} else {
	    print;
	}
    }
}

&main;
