#!perl

use strict;
use warnings;

use lib qw{lib ../lib};
use WebService::Rollbar::Notifier;

my $roll = WebService::Rollbar::Notifier->new(
    access_token => $ENV{TEST_ROLLBAR_ACCESS_TOKEN} || 'dc851d5abb5c41edad589c336d49004e',
    callback => undef,
);

my $res = $roll->debug("Testing example stuff!", { foo => 'bar',
    caller => scalar(caller()),
    meow => {
        mew => {
            bars => [qw/1 2 3 4 5 /],
        },
    },
});

use JSON::MaybeXS;
use Data::Dumper;
print Dumper [ decode_json $res ];