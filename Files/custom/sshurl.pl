#!/usr/bin/perl
use strict;
my $url = join " ",@ARGV;
my ($proto,$userhostport,$pwd) = split '/+',$url,3;
my ($userhost,$port) = split ':', $userhostport;
$userhost= 'root@'.$userhost if not $userhost =~ m/@/;
$pwd =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
#print join "\t", map {"'$_'"} ($userhost, $pwd, $port);
$ENV{SSHPASS}=$pwd;
my @port=();
if ($port=~m/^\d+$/) {
  @port=('-p', $port);
}
exec("/usr/bin/zsh","/home/".$ENV{USER}."/custom/myssh.sh", @port, $userhost);
