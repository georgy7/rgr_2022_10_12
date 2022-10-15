use v5.10;
use strict;
use warnings;

package Combatant;

# Участник сражения — не обязательно воин:
# это может быть оруженосец, животное и т.п.

use List::Util qw(min max);

sub new {
    my ($class, $hp) = @_;
    bless {
        max_hp => $hp,
        hp => $hp,
        conditions => {}
    }, $class;
}

# Живой ли юнит.
sub is_alive {
    my $self = shift;
    return $self->{hp} > 0;
}

# Число от нуля до единицы, где 1 означает стопроцентное здоровье.
sub health {
    my $self = shift;
    return $self->{hp} / $self->{max_hp};
}

# Получить урон. Принимает количество очков здоровья, которые нужно отнять.
sub take_damage {
    my ($self, $damage) = @_;
    if ($damage >= $self->{hp}) {
        $self->pass_away;
    } elsif ($damage > 0) {
        $self->{hp} -= $damage;
    }
}

# Скончаться.
sub pass_away {
    my $self = shift;
    $self->{hp} = 0;
    say "$self died.";
}

# Исцелиться — восстановить свои очки здоровья. Метод не воскрешает.
# Если не указать количество очков, восстанавливает полное здоровье.
sub recover {
    my ($self, $points) = @_;
    if ($self->is_alive) {
        if ($points && $points > 0) {
            $self->{hp} = min($self->{max_hp}, $self->{hp} + $points);
        } else {
            $self->{hp} = $self->{max_hp};
        }
    }
}

# Получить некоторое состояние (длящееся воздействие). Сюда входят наложения заклинаний, отравления и т.п.
# Степень воздействия прибавляется к текущему состоянию. Максимальная интенсивность равна единице.
sub be_affected {
    my ($self, $name, $degree) = @_;

    my $last_value = 0;
    if (exists $self->{conditions}->{$name}) {
        $last_value = $self->{conditions}->{$name};
    }

    $self->{conditions}->{$name} = min(max(0, $last_value + $degree), 1);
}

# Возвращает степень выраженности состояния.
sub has_condition {
    my ($self, $name) = @_;
    if (exists $self->{conditions}->{$name}) {
        return $self->{conditions}->{$name};
    }
}

1;
