#!/usr/bin/perl
use strict;
use warnings;

use Net::IRR;
use Net::Whois::IANA;
use Data::Dumper;
use Mail::Sendmail;
$|=0;


my $desiredASSet;

if(defined $ENV{'REMOTE_ADDR'}){
    #called in html context 
    print "Content-Type: text/plain\n\n";
    use CGI;
    my $cgi = CGI->new;
    if(!defined $cgi->param('desiredASSet') || $cgi->param('desiredASSet') !~/^AS/){
        print "No AS-SET specified!";
        exit;
    }
    $desiredASSet = $cgi->param('desiredASSet');
}
else{
    #called from shell 
    if(!defined $ARGV[0] || $ARGV[0] !~/^AS/){
        die "Usage: $0 as_set";
    }
    $desiredASSet = $ARGV[0];
}

my $host = 'whois.radb.net';
my $irr = Net::IRR->connect(host => $host) or die "Cant connect. $!";
my $ipString = '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}';

my %prefixes;


print ">>> ASes in $desiredASSet:\n";
foreach my $as ($irr->get_as_set("$desiredASSet", 1)){
    print "$as\n";
}
