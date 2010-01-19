#!/usr/bin/perl -w

use DateTime;
use strict;

# Header is:
# Date,Time,User-Name,Group-Name,Calling-Station-Id,Acct-Status-Type,Acct-Session-Id,Acct-Session-Time,Service-Type,Framed-Protocol,Acct-Input-Octets,Acct-Output-Octets,Acct-Input-Packets,Acct-Output-Packets,Framed-IP-Address,NAS-Port,NAS-IP-Address

# Format of date is mm/dd/yyyy hh:mm:ss

my %current;
my $rawdate = $ARGV[1];

my $dt = returndateobject($rawdate);

open(ACCFILE, $ARGV[0]);

while (<ACCFILE>)
	{
	next if /^\D/;
	my @line = split(/,/, $_);
	my $linedt = returndateobject("$line[0] $line[1]");
	last unless (DateTime->compare($dt, $linedt) == 1);

	if ($line[5] =~ /[sS]top/)
		{
		if (exists $current{$line[6]}) { delete $current{$line[6]}}
		}
	elsif ($line[5] =~ /[sS]tart/)
		{
		$current{$line[6]} = [ $line[2], $line[1], $line[6] ];
		}
	} 

close(ACCFILE);

foreach my $arrayref (values %current)
	{
	local $, = ", ";
	local $\ = "\n";
	print @$arrayref;
	}


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
