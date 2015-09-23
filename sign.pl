#!/usr/bin/perl -w
use strict;
use CGI;
use CGI::Carp 'fatalsToBrowser';
use DateTime;
use Digest::SHA qw(hmac_sha256_hex);
use Data::Dumper;

my $cgi = new CGI;

sub sign
{
	my ( $endpoint, $force_ts ) = @_;

	$force_ts = $force_ts || 0;

	# Replace these values.
	my $API_KEY = 'this-is-my-key';
	my $API_SECRET = 'this-is-my-secret';
	my $ts = undef;

	if($force_ts) {
		$ts = $force_ts;
	} else {
		my $now = DateTime->from_epoch( epoch => time() );
		$now->set_time_zone( 'UTC' );
		$ts = $now->ymd('-') . 'T' . $now->hms(':');
	}

	my $data = $endpoint . '|' . $ts;
	my $hm = hmac_sha256_hex($data, $API_SECRET);
    return ($hm, $ts);
}

print $cgi->header();
print Dumper(sign('/example/endpoint', '2014-06-03T17:48:47.774453'));
