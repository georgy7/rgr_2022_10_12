use v5.10;
use strict;
use warnings;

package Units::BlackKnight;
use parent 'Units::Combatant';

use Units::Destrier;
use Behaviour::Perks;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(44, 12, [ Behaviour::Perks->REGENERATE ]);
    $self->{horse} = Units::Destrier->new();
    $self->{riding} = 0;
    return $self;
}

sub attack {
    my ($self, $enemy) = @_;
    if ($self->is_riding) {
        $self->poke($enemy);
    } else {
        $self->strike($enemy);
    }
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
        say "$self saddled.";
        $self->{riding} = 1;
    }
}

# Нанести урон копьём.
sub poke {
    my ($self, $enemy) = @_;
    if ($self->is_alive && $enemy->is_alive) {
        say "$self plunged the spear.";
        if ($self->is_riding) {
            $enemy->change_health(-20);
        } else {
            $enemy->change_health(-4);
        }
    }
}

# Нанести урон мечом.
# Какой рыцарь без меча?
sub strike {
    my ($self, $enemy) = @_;
    if ($self->is_alive && $enemy->is_alive) {
        say "$self struck with the sword.";
        $enemy->change_health(-12);
    }
}

1;
