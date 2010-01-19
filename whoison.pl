#!/usr/bin/perl -w

use DateTime;
use strict;

# Format of date is mm/dd/yyyy hh:mm:ss

my $rawdate = $ARGV[1];

my $dt = returndateobject($rawdate);

open(ACCFILE, $ARGV[0]);

while (<ACCFILE>)
	{
	next if /^\D/;
	my @line = split(/,/, $_);
	my $linedt = returndateobject("$line[0] $line[1]");
	next if ( DateTime->compare($linedt, $dt));
	} 

close(ACCFILE);

sub returndateobject
	{
	(my $mon, my $day, my $year) = $_[0] =~ m#^(\d+)/(\d+)/(\d{4})#;
	(my $hour, my $minute, my $sec) = $_[0] =~ /\s(\d+):(\d+):(\d+)$/;

	return DateTime->new( year=> $year,
			month=> $mon,
			day => $day,
			hour => $hour,
			minute => $minute,
			second => $sec
			);
	}
