#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Deep;

plan tests => 3;

use Data::Dumper;
use JSON::MaybeXS;
use WebService::Rollbar::Notifier;

my $rollbar = WebService::Rollbar::Notifier->new(
    access_token => 'dc851d5abb5c41edad589c336d49004e',
    callback => undef, # block to read response
);

isa_ok $rollbar, 'WebService::Rollbar::Notifier';
can_ok $rollbar, qw/
    access_token  environment  code_version
    critical error warning info debug notify
    callback
/;

my $res = $rollbar->info(
    'v1.001003 Running test 01-notify.t',
    {
        perl_version => $^V,
    },
);

my $sample = {
    'result' => {
        'id' => undef,
        'uuid' => re('^\w+$'),
    },
    'err' => 0,
};

    unless ( $res->success ) {
    diag 'Failed to successfully send request. About to fail. Dumping '
        . 'what we received for debugging purposes: '
        . Dumper $res;
}

my $answer = eval { decode_json($res->res->body) };
if ( $@ ) {
    diag 'We failed to decode JSON response, which was: ['
        . $res->res->body . "]\n"
        . "The exception we received is $@";
}

cmp_deeply $answer, $sample, 'Response data looks sane';
