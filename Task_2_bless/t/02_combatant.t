use v5.10;
use strict;
use warnings;

use Test::More tests => 4;

use_ok('Units::Combatant');
use Units::Relation;

# Хоть это и базовый класс, его всё же можно инстанцировать.
# Стандартное поведение: нейтральный небоевой юнит.

subtest 'not abstract' => sub {
    my $value = Units::Combatant->new(50, 12);
    ok(UNIVERSAL::isa($value, 'Units::Combatant'));
    is($value->team, 0);

    ok($value->is_alive);
    ok(abs(1.0 - $value->health) < 1e-6);
};

subtest 'identification' => sub {
    my $lora = Units::Combatant->new(100, 12);
    my $derek = Units::Combatant->new(100, 12);
    my $richard = Units::Combatant->new(100, 12);
    my $sarah = Units::Combatant->new(100, 12);

    $richard->team(1);
    $sarah->team(1);

    is(1, $sarah->team());

    ok($lora->identify($lora)       & Units::Relation->SELF, 'self-identification of Lora');
    ok($derek->identify($derek)     & Units::Relation->SELF, 'self-identification of Derek');
    ok($richard->identify($richard) & Units::Relation->SELF, 'self-identification of Richard');
    ok($sarah->identify($sarah)     & Units::Relation->SELF, 'self-identification of Sarah');

    ok($lora->identify($lora)       & Units::Relation->ALLY, 'Lora is sane.');
    ok($derek->identify($derek)     & Units::Relation->ALLY, 'Derek is sane.');
    ok($richard->identify($richard) & Units::Relation->ALLY, 'Richard is sane.');
    ok($sarah->identify($sarah)     & Units::Relation->ALLY, 'Sarah is sane.');

    is(0, $lora->identify($derek),   'Lora, Derek: neutral');
    is(0, $lora->identify($richard), 'Lora, Richard: neutral');

    ok($richard->identify($sarah) & Units::Relation->ALLY, "Sarah is Richard's ally.");
    ok($sarah->identify($richard) & Units::Relation->ALLY, "Richard is Sarah's ally.");

    ok(!($richard->identify($sarah) & Units::Relation->SELF), "Sarah is not Richard.");
    ok(!($sarah->identify($richard) & Units::Relation->SELF), "Richard is not Sarah.");

    ok(!($richard->identify($sarah) & Units::Relation->ENEMY), "Sarah is not Richard's enemy.");
    ok(!($sarah->identify($richard) & Units::Relation->ENEMY), "Richard is not Sarah's enemy.");

    $sarah->team(2);

    ok($richard->identify($sarah) & Units::Relation->ENEMY, "Sarah is Richard's enemy.");
    ok($sarah->identify($richard) & Units::Relation->ENEMY, "Richard is Sarah's enemy.");

    ok(!($richard->identify($sarah) & Units::Relation->SELF), "Sarah is not Richard (2).");
    ok(!($sarah->identify($richard) & Units::Relation->SELF), "Richard is not Sarah (2).");

    ok(!($richard->identify($sarah) & Units::Relation->ALLY), "Sarah is not Richard's ally.");
    ok(!($sarah->identify($richard) & Units::Relation->ALLY), "Richard is not Sarah's ally.");

    $sarah->team(0);

    is(0, $richard->identify($sarah), 'Richard, Sarah: neutral');

    is(0, $sarah->team());
};

subtest 'perks() returns a readonly array' => sub {
    my $gifted = Units::Combatant->new(50, 12, ['MockPerk1']);
    my $inept = Units::Combatant->new(50, 12);

    ok($gifted->perks);
    ok($inept->perks);

    is(scalar(@{$gifted->perks}), 1);
    is(scalar(@{$inept->perks}), 0);

    eval {
        push(@{$gifted->perks}, 'MockPerk2');
    };

    eval {
        push(@{$inept->perks}, 'MockPerk2');
    };

    is(scalar(@{$gifted->perks}), 1);
    is(scalar(@{$inept->perks}), 0);
};
