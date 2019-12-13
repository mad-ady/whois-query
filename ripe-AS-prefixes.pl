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
    if(!defined $cgi->param('desiredASSet')){
        print "No AS specified!";
        exit;
    }
    $desiredASSet = $cgi->param('desiredASSet');
}
else{
    #called from shell 
    if(!defined $ARGV[0]){
        die "Usage: $0 as_set";
    }
    $desiredASSet = $ARGV[0];
}

my $host = 'whois.radb.net';
my $irr = Net::IRR->connect(host => $host) or die "Cant connect. $!";
my $ipString = '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}';

my %prefixes;


print ">>> Prefixes in $desiredASSet:\n";
foreach my $route ($irr->get_routes_by_origin("$desiredASSet")){
    $prefixes{$route}=1;
    print $route."\n";
}
