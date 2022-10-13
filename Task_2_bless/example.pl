use v5.10;
use strict;
use warnings;

use FindBin;
use lib $FindBin::Bin;

use BlackKnight;
use Giant;

my $knight = BlackKnight->new();
my $other = BlackKnight->new();

say 'A knight vs another.';

$knight->poke($other);
say 'K: ' . $knight->health . ', O: ' . $other->health;

$knight->saddle();
say 'K: ' . $knight->health . ', O: ' . $other->health;

$knight->poke($other);
say 'K: ' . $knight->health . ', O: ' . $other->health;
$knight->poke($other);
say 'K: ' . $knight->health . ', O: ' . $other->health;

say 'Trying to heal himself...';

$other->recover(1);
say 'K: ' . $knight->health . ', O: ' . $other->health;
$other->recover();
say 'K: ' . $knight->health . ', O: ' . $other->health;

say '---------';

say 'A knight vs a warhorse.';

$other = BlackKnight->new();
say 'K: ' . $knight->health . ', O: ' . $other->health . ', OH: ' . $other->{horse}->health;

$knight->poke($other->{horse});
say 'K: ' . $knight->health . ', O: ' . $other->health . ', OH: ' . $other->{horse}->health;

say '---------';

$other = BlackKnight->new();

$knight->poke($other);
say 'K: ' . $knight->health . ', O: ' . $other->health;

$knight->poke($other);
say 'K: ' . $knight->health . ', O: ' . $other->health;

say 'Healing...';

$other->recover(1);
say 'K: ' . $knight->health . ', O: ' . $other->health;
$other->recover(1);
say 'K: ' . $knight->health . ', O: ' . $other->health;
$other->recover();
say 'K: ' . $knight->health . ', O: ' . $other->health;

say '---------';

say $knight->has_condition('sdfsdf');

$knight->be_affected('sdfsdf', 0.2);
say $knight->has_condition('sdfsdf');

$knight->be_affected('sdfsdf', 0.1);
say $knight->has_condition('sdfsdf');

$knight->be_affected('sdfsdf', 200);
say $knight->has_condition('sdfsdf');

say '---------';
say 'A knight vs a giant.';

my $giant = Giant->new();

$knight->poke($giant);
say 'K: ' . $knight->health . ' (' . $knight->has_condition('bewitched') . ')' . ', G: ' . $giant->health;

$knight->poke($giant);
say 'K: ' . $knight->health . ' (' . $knight->has_condition('bewitched') . ')' . ', G: ' . $giant->health;

$giant->bewitch($knight);
say 'K: ' . $knight->health . ' (' . $knight->has_condition('bewitched') . ')' . ', G: ' . $giant->health;

$giant->hit($knight);
say 'K: ' . $knight->health . ' (' . $knight->has_condition('bewitched') . ')' . ', G: ' . $giant->health;

$knight->poke($giant);
say 'K: ' . $knight->health . ' (' . $knight->has_condition('bewitched') . ')' . ', G: ' . $giant->health;

$knight->poke($giant);
say 'K: ' . $knight->health . ' (' . $knight->has_condition('bewitched') . ')' . ', G: ' . $giant->health;

$giant->bewitch($knight);
say 'K: ' . $knight->health . ' (' . $knight->has_condition('bewitched') . ')' . ', G: ' . $giant->health;

$giant->hit($knight);
say 'K: ' . $knight->health . ' (' . $knight->has_condition('bewitched') . ')' . ', G: ' . $giant->health;

$knight->poke($giant);
say 'K: ' . $knight->health . ' (' . $knight->has_condition('bewitched') . ')' . ', G: ' . $giant->health;

$knight->poke($giant);
say 'K: ' . $knight->health . ' (' . $knight->has_condition('bewitched') . ')' . ', G: ' . $giant->health;

