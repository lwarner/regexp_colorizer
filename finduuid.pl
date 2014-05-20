#!/usr/bin/perl -w

use strict;

my @color_ids = ( 31 .. 37 );

sub colorize {
        my $index = int(rand(scalar(@color_ids)));
        print "\n\n\@color_ids is ".scalar(@color_ids)."\n\$index is '$index'\n\n";
        my $color_code = $color_ids[$index];
	my $set_color = "\033[${color_code}m";
	my $reset_color = "\033[0m";
	return "->$set_color$_[0]$reset_color<-";
}


sub main  {
	while (<>) {
	    if (/(^.*)([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12})(.*$)/)  {
		   my ($start, $uuidstring, $end) = ($1, $2, $3);
		   print $start, "\n";
		   print &colorize($uuidstring), "\n";
		   print $end, "\n";
		}
	}
}

&main;
