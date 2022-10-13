use v5.10;
use strict;
use warnings;
use Destrier;

package BlackKnight;
use parent 'Combatant';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(44);
    $self->{horse} = Destrier->new();
    $self->{riding} = 0;
    return $self;
}

# Верхом.
sub is_riding {
    my $self = shift;
    return $self->{horse}->is_alive && $self->{riding};
}

# Оседлать коня.
sub saddle {
    my $self = shift;
    if ($self->is_alive && $self->{horse}->is_alive && !$self->is_riding) {
        # Вероятно, нужно либо подозвать к себе коня, либо подойти к нему. Зависит от того, что это за жанр вообще.
        $self->{riding} = 1;
    }
}

# Нанести урон копьём.
sub poke {
    my ($self, $enemy) = @_;
    if ($self->is_alive && $enemy->is_alive) {
        if ($self->is_riding) {
            $enemy->take_damage(20);
        } else {
            $enemy->take_damage(4);
        }
    }
}

1;
