use v5.10;
use strict;
use warnings;

package Units::Giant;
use parent 'Units::Combatant';

use Behaviour::Perks;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(120, 10, [ Behaviour::Perks->BEWITCH ]);
    return $self;
}

sub attack {
    my ($self, $enemy) = @_;
    $self->hit($enemy);
}

# Нанести урон дубиной.
sub hit {
    my ($self, $enemy) = @_;
    if ($self->is_alive && $enemy->is_alive) {
        say "$self hit the enemy with a club.";
        $enemy->change_health(-20);
    }
}

1;
