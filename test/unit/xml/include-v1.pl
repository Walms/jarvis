#!/usr/bin/perl
#
use strict;
use warnings;

use XML::Smart;

my $MAIN = 
"<xml><jarvis>
  <app>
    <plugin name='plugin1'/>
    <plugin name='plugin2'/>

    <router>
      <route name='route1'/>
      <route name='route2'/>
    </router>
  </app>
</jarvis></xml>";

my $INCLUDE = 
"<xml><jarvis>
  <app>
    <plugin name='plugin3'/>
    <plugin name='plugin4'/>

    <router>
      <route name='route3'/>
      <route name='route4'/>
    </router>
  </app>
</jarvis></xml>";

my $main = XML::Smart->new ($MAIN);
my $include = XML::Smart->new ($INCLUDE);

my $axml = $main->{xml}{jarvis}{app};
if ($axml->{plugin}) {
    foreach my $plugin (@{ $axml->{plugin} }) {
        print "MAIN (plugin): " . $plugin->{name}->content . "\n";
    }
}
if ($axml->{router} && $axml->{router}{route}) {
    foreach my $route (@{ $axml->{router}{route} }) {
        print "MAIN (route): " . $route->{name}->content . "\n";
    }
}

$axml = $include->{xml}{jarvis}{app};
if ($axml->{plugin}) {
    foreach my $plugin (@{ $axml->{plugin} }) {
        print "INCLUDE (plugin): " . $plugin->{name}->content . "\n";
        push (@{ $main->{xml}{jarvis}{app}{plugin} }, { name => $plugin->{name}->content } );
    }
}
if ($axml->{router} && $axml->{router}{route}) {
    foreach my $route (@{ $axml->{router}{route} }) {
        print "INCLUDE (route): " . $route->{name}->content . "\n";
        push (@{ $main->{xml}{jarvis}{app}{router}{route} }, { name => $route->{name}->content } );
    }
}

$axml = $main->{xml}{jarvis}{app};
if ($axml->{plugin}) {
    foreach my $plugin (@{ $axml->{plugin} }) {
        print "MAIN (plugin): " . $plugin->{name}->content . "\n";
    }
}
if ($axml->{router} && $axml->{router}{route}) {
    foreach my $route (@{ $axml->{router}{route} }) {
        print "MAIN (route): " . $route->{name}->content . "\n";
    }
}

1;