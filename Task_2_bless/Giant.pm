use v5.10;
use strict;
use warnings;

package Giant;
use parent 'Combatant';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(120);
    return $self;
}

# Нанести урон дубиной.
sub hit {
    my ($self, $enemy) = @_;
    if ($self->is_alive && $enemy->is_alive) {
        $enemy->take_damage(20);
    }
}

# Околдовать.
sub bewitch {
    my ($self, $enemy) = @_;
    if ($self->is_alive && $enemy->is_alive) {
        $enemy->be_affected('bewitched', 0.25);
    }
}

1;
