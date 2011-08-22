#! perl

use strict;
use warnings;
use Test::More;
use Statistics::R;

plan tests => 7;


my $R;
my $warn = 0;
{
    local $SIG{ __WARN__ } = sub { $warn++; };
    $R = Statistics::R->new();
}

SKIP: {
    skip 'No R binary', 10 if $warn;

    ok $R;

    ok $R->startR;

    is $R->run(
            q`postscript("file.ps" , horizontal=FALSE , width=500 , height=500 , pointsize=1)`
        ), '';

    is $R->run( q`plot(c(1, 5, 10), type = "l")` ), '';

    ok $R->run( qq`x = 123 \n print(x)` ) =~ /^\[\d+\]\s+123\s*$/;

    ok $R->run( qq`x = 456 \n print(x)` ) =~ /^\[\d+\]\s+456\s*$/;

    ok $R->stopR();
}

