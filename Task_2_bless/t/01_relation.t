use v5.10;
use strict;
use warnings;

use Test::More tests => 4;
use List::Util qw(uniq);

use_ok('Units::Relation');

subtest 'unique values' => sub {
    my @values = (
        Units::Relation->SELF,
        Units::Relation->ALLY,
        Units::Relation->ENEMY
    );

    my @unique = uniq @values;
    ok(scalar(@values) == scalar(@unique));
};

subtest 'allies are not enemies' => sub {
    my $value = Units::Relation->ALLY;
    ok(!($value & Units::Relation->ENEMY));
};

subtest 'self is neutral' => sub {
    # Предполагается, что если вы хотите показать разумное к себе отношение,
    # вы должны явно декларировать SELF|ALLY, а не полагаться на то,
    # что SELF уже включает в себя ALLY.

    my $value = Units::Relation->SELF;
    ok(!($value & Units::Relation->ALLY));
    ok(!($value & Units::Relation->ENEMY));
};
