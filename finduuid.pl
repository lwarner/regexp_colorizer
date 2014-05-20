#!/usr/bin/perl -w

use strict;
use Digest::MD5 qw(md5);

my $uuidregex="[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}";

sub color_ids {
    my @color_strings = ();
    for my $foreground ( 31 .. 37, 90..97, 39 ) {
	for my $background ( 40 .. 47, 100 .. 107, 49 ) {
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

# passed a string with one or more uuids, 
# returns an array of two strings
#   string up to and including uuid
#   remaining string
sub uuid_substring {
    my $substring = $_[0];
    $substring =~ /(^.*?)($uuidregex)(.*$)/;
    my ($start, $uuidstring, $end) = ($1, $2, $3);
    ($start.&colorize($uuidstring), $end);
}


sub main  {
    while (<>) {
	if (/(^.*)($uuidregex)(.*$)/)  {
	    #my ($start, $uuidstring, $end) = ($1, $2, $3);
	    my @count = $_ =~ m/$uuidregex/g;
	    my $substring = $_;
	    for my $index (@count) {
		(my $formatted, $substring) = &uuid_substring($substring);
		print $formatted
	    }
	    print scalar @count; print "\n";
	    #print $start, &colorize($uuidstring), $end, "\n";
	} else {
	    print;
	}
    }
}

&main;
