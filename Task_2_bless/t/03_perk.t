use v5.10;
use strict;
use warnings;

use Test::More tests => 2;

use_ok('Behaviour::Perk');

subtest 'a useless perk' => sub {
    my $perk = Behaviour::Perk->new(name => 'Useless', scope => 0, batch => 0, max_distance => 100, price => 1);
    ok(UNIVERSAL::isa($perk, 'Behaviour::Perk'));
};
