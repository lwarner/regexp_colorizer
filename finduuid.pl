#!/usr/bin/perl -w

use strict;
use Digest::MD5 qw(md5);

my $uuidregex="[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}";

sub color_ids {
    # @bad_combos = ( "$background$foreground", ... )
    my @bad_combos = ( "4030", "4090", "4131", "4135", "4191", "4232", "4233",
	"4294", "4239", "4332", "4333", "4339", "4434", "4531", "4535", "4591",
	"4636", "4737", "4797", "10030", "10090", "10131", "10135", "10191",
	"10292", "10393", "10395", "10432", "10494", "10439", "10593", "10595",
	"10696", "10737", "10797", "4930", "4990" );
    my @color_strings = ();
    for my $foreground ( 30 .. 37, 90..97, 39 ) {
	for my $background ( 40 .. 47, 100 .. 107, 49 ) {
	    next if grep(/$background$foreground/, @bad_combos);
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
	    my @count = $_ =~ m/$uuidregex/g;
	    my $substring = $_;
	    for my $index (@count) {
		(my $formatted, $substring) = &uuid_substring($substring);
		print $formatted
	    }
	    print $substring."\n";
	} else {
	    print;
	}
    }
}

&main;
