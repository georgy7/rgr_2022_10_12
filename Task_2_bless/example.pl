use v5.10;
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Units::BlackKnight;
use Units::Giant;
use Behaviour::Perks;


sub show_status {
    print "\n";
    foreach (@_) {
        my @conditions = ();
        while (my($k, $v) = each %{$_->{conditions}}) {
            push @conditions, "$k => $v"
        }
        printf "  %40s: %.2f%% (%s)\n", $_, (100 * $_->health), join(', ', @conditions)
    }
    print "\n";
}


my $knight = Units::BlackKnight->new();
my $other = Units::BlackKnight->new();


$knight->team(1);
$other->team(2);


print "\n\n";
say 'A knight vs another';
say "-------------------\n";

{
    $knight->attack($other);
    show_status($knight, $other);

    $knight->saddle();
    show_status($knight, $other);

    $knight->attack($other);
    show_status($knight, $other);
    $knight->attack($other);
    show_status($knight, $other);

    say 'Trying to resuscitate himself...';

    $other->use_perk(0, Behaviour::Perks->REGENERATE, ($other, 0));
    show_status($knight, $other);
    $other->use_perk(0, Behaviour::Perks->REGENERATE, ($other, 0));
    show_status($knight, $other);
}


print "\n\n";
say 'A knight vs a warhorse';
say "----------------------\n";

{
    $other = Units::BlackKnight->new();
    $other->team(2);

    say 'Start.';
    show_status($knight, $other, $other->{horse});

    $knight->attack($other->{horse});
    show_status($knight, $other, $other->{horse});
}


print "\n\n";
say 'Knight vs knight who knows how to heal';
say "--------------------------------------\n";

{
    $other = Units::BlackKnight->new();
    $other->team(2);

    $knight->attack($other);
    show_status($knight, $other);

    $knight->attack($other);
    show_status($knight, $other);

    say 'Healing...';

    $other->use_perk(0, Behaviour::Perks->REGENERATE, ($other, 0));
    show_status($knight, $other);
    $other->use_perk(0, Behaviour::Perks->REGENERATE, ($other, 0));
    show_status($knight, $other);
    $other->use_perk(0, Behaviour::Perks->REGENERATE, ($other, 0));
    show_status($knight, $other);
}


print "\n\n";
say 'Getting a condition';
say "-------------------\n";

{
    show_status($knight);

    $knight->be_affected('poisoned', 0.2);
    show_status($knight);

    $knight->be_affected('poisoned', 0.1);
    show_status($knight);

    $knight->be_affected('poisoned', 200);
    show_status($knight);
}


print "\n\n";
say 'A knight vs a giant';
say "-------------------\n";

{
    my $giant = Units::Giant->new();
    $giant->team(2);

    $knight->attack($giant);
    show_status($knight, $giant);

    $knight->attack($giant);
    show_status($knight, $giant);

    $giant->use_perk(0, Behaviour::Perks->BEWITCH, ($knight, 2.5));
    show_status($knight, $giant);

    $giant->attack($knight);
    show_status($knight, $giant);

    $knight->attack($giant);
    show_status($knight, $giant);

    $knight->attack($giant);
    show_status($knight, $giant);

    $giant->use_perk(0, Behaviour::Perks->BEWITCH, ($knight, 3.5));
    show_status($knight, $giant);

    $giant->attack($knight);
    show_status($knight, $giant);

    $knight->attack($giant);
    show_status($knight, $giant);

    $knight->attack($giant);
    show_status($knight, $giant);
}
