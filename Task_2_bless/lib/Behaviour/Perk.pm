use v5.10;
use strict;
use warnings;

package Behaviour::Perk;

use Carp qw(croak);
use List::Util qw(min max);
use Scalar::Util qw(looks_like_number);
use POSIX qw(round);
use Readonly;

# Умение — это совокупность мгновенных и длящихся воздействий на участников сражений.
# Это заклинания в основном. Я пока не включаю сюда обычные атаки (возможно, зря).
# Scope проверяется через пересечение (если флаги считать множествами, они должны хотя бы частично пересечься).
#
# %param: name*, scope*, batch*, price*, max_distance, hp_change, condition_changes
sub new {
    my $class = shift;
    my %param = @_;
    croak 'Name must be non-empty string.' unless length($param{name});
    croak 'Scope should be a Relation flag (int >= 0).' unless round($param{scope}) >= 0;
    croak 'Batch must be equal to 0 or 1.' unless (0 == $param{batch}) || (1 == $param{batch});
    croak 'Price must be a positive integer (action points).' unless round($param{price}) > 0;

    my $filtered = {};
    $filtered->{name} = $param{name};
    $filtered->{scope} = round($param{scope});
    $filtered->{batch} = $param{batch};
    $filtered->{price} = round($param{price});

    if (exists $param{max_distance}) {
        croak 'Max distance must be a positive number (meters).' unless $param{max_distance} > 0;
        $filtered->{max_distance} = $param{max_distance};
    } else {
        $filtered->{max_distance} = 1000;
    }

    {
        my @hp_bounds = (0, 0);

        if (exists $param{hp_change}) {
            @hp_bounds = @{$param{hp_change}};
            croak 'Array hp_change must have two values.' unless scalar(@hp_bounds) == 2;
            croak 'hp_change[0] must be a number.' unless looks_like_number($hp_bounds[0]);
            croak 'hp_change[1] must be a number.' unless looks_like_number($hp_bounds[1]);
            @hp_bounds = (round(min(@hp_bounds)), round(max(@hp_bounds)));
        }

        Readonly::Array my @ro_hp_bounds => @hp_bounds;
        $filtered->{hp_change} = \@ro_hp_bounds;
    }

    {
        my %changes = ();

        if (exists $param{condition_changes}) {
            %changes = %{$param{condition_changes}};
            while (my($k, $v) = each %changes) {
                croak 'Condition name must be a non-empty string.' unless length($k);
                croak 'Condition change value must be a number.' unless looks_like_number($v);
            }
        }

        Readonly::Hash my %ro_changes => %changes;
        $filtered->{condition_changes} = \%ro_changes;
    }

    bless $filtered, $class;
}

# В принципе, можно было и не добавлять аксессоры.
# Публичный доступ к этим полям нужен в основном для UI и ИИ.
sub name { shift->{name} }
sub scope { shift->{scope} }
sub batch { shift->{batch} }
sub max_distance { shift->{max_distance} }
sub price { shift->{price} }
sub hp_change { shift->{hp_change} }
sub condition_changes { shift->{condition_changes} }

# Может ли быть применён этот навык в данной ситуации?
sub fits {
    my ($self, $distance, $relation) = @_;
    ($relation & $self->scope) && ($distance <= $self->max_distance);
}

# Применяет к одному или нескольким участникам, переданных списком. Возвращает стоимость операции.
# Если estimate вычисляется в true, просто возвращает необходимое число очков действия.
# Юниты, к которым применяется действие, должны быть предварительно отфильтрованы и переданы списком.
# @param: combanants, estimate
sub apply {
    my ($self, $combanants, $estimate) = @_;

    my $cost = 0;
    foreach (@$combanants) {
        croak "It must be a Combatant." unless UNIVERSAL::isa($_, 'Units::Combatant');

        next unless $_->is_alive;

        if (!$estimate) {
            my $hp_change = $self->hp_change->[0];
            my $spread = $self->hp_change->[1] - $self->hp_change->[0];

            if ($spread) {
                $hp_change += int(rand(1 + $spread));
            }

            $_->change_health($hp_change);

            while (my($condition, $condition_change) = each %{$self->condition_changes}) {
                $_->be_affected($condition, $condition_change);
            }
        }

        if (0 == $cost) {
            $cost = $self->price;
        } elsif (!$self->batch) {
            $cost += $self->price;
        }
    }

    $cost
}

1;
