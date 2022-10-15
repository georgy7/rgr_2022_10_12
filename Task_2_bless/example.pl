use v5.10;
use strict;
use warnings;

use FindBin;
use lib $FindBin::Bin;

use BlackKnight;
use Giant;


sub show_status {
    print "\n";
    foreach (@_) {
        my @conditions = ();
        while (my($k, $v) = each %{$_->{conditions}}) {
            push @conditions, "$k => $v"
        }
        printf "  %40s: %.5f%% (%s)\n", $_, (100 * $_->health), join(', ', @conditions)
    }
    print "\n";
}


my $knight = BlackKnight->new();
my $other = BlackKnight->new();


print "\n\n";
say 'A knight vs another';
say "-------------------\n";

{
    $knight->poke($other);
    show_status($knight, $other);

    $knight->saddle();
    show_status($knight, $other);

    $knight->poke($other);
    show_status($knight, $other);
    $knight->poke($other);
    show_status($knight, $other);

    say 'Trying to resuscitate himself...';

    $other->recover(1);
    show_status($knight, $other);
    $other->recover();
    show_status($knight, $other);
}


print "\n\n";
say 'A knight vs a warhorse';
say "----------------------\n";

{
    $other = BlackKnight->new();
    say 'Start.';
    show_status($knight, $other, $other->{horse});

    $knight->poke($other->{horse});
    show_status($knight, $other, $other->{horse});
}


print "\n\n";
say 'Knight vs knight who knows how to heal';
say "--------------------------------------\n";

{
    $other = BlackKnight->new();

    $knight->poke($other);
    show_status($knight, $other);

    $knight->poke($other);
    show_status($knight, $other);

    say 'Healing...';

    $other->recover(1);
    show_status($knight, $other);
    $other->recover(1);
    show_status($knight, $other);
    $other->recover();
    show_status($knight, $other);
}


print "\n\n";
say 'Getting a condition';
say "-------------------\n";

{
    show_status($knight);

    $knight->be_affected('sdfsdf', 0.2);
    show_status($knight);

    $knight->be_affected('sdfsdf', 0.1);
    show_status($knight);

    $knight->be_affected('sdfsdf', 200);
    show_status($knight);
}


print "\n\n";
say 'A knight vs a giant';
say "-------------------\n";

{
    my $giant = Giant->new();

    $knight->poke($giant);
    show_status($knight, $giant);

    $knight->poke($giant);
    show_status($knight, $giant);

    $giant->bewitch($knight);
    show_status($knight, $giant);

    $giant->hit($knight);
    show_status($knight, $giant);

    $knight->poke($giant);
    show_status($knight, $giant);

    $knight->poke($giant);
    show_status($knight, $giant);

    $giant->bewitch($knight);
    show_status($knight, $giant);

    $giant->hit($knight);
    show_status($knight, $giant);

    $knight->poke($giant);
    show_status($knight, $giant);

    $knight->poke($giant);
    show_status($knight, $giant);
}
