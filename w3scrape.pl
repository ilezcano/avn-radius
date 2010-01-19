#!/usr/bin/perl -w
#
use DateTime;
use DateTime::Format::Flexible;
use strict;

#Fields: date time c-ip cs-username s-ip s-port cs-method cs-uri-stem cs-uri-query sc-status cs(User-Agent) 

# Format of date is mm/dd/yyyy hh:mm:ss

my $rawdate = $ARGV[1];

my $dt = returndateobject($rawdate);

open(ACCFILE, $ARGV[0]);

while (<ACCFILE>)
	{
	next if /^\D/;
	my @line = split(/\s/, $_);
	my $linedt = DateTime::Format::Flexible->parse_datetime("$line[0] $line[1]");
	my $difftime = $dt - $linedt;
	print "$linedt " . $difftime->in_units('minutes') . "\n";
#	last unless (DateTime->compare($dt, $linedt) == 1);
#
#	if ($line[5] =~ /[sS]top/)
#		{
#		if (exists $current{$line[6]}) { delete $current{$line[6]}}
#		}
#	elsif ($line[5] =~ /[sS]tart/)
#		{
#		$current{$line[6]} = [ $line[2], $line[1], $line[6], $line[14] ];
#		}
	} 

close(ACCFILE);

#foreach my $arrayref (values %current)
#	{
#	local $, = ", ";
#	local $\ = "\n";
#	print @$arrayref;
#	}


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
