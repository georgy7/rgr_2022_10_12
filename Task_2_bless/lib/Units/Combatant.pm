use v5.10;
use strict;
use warnings;

package Units::Combatant;

use Carp qw(croak);
use List::Util qw(min max pairs);
use Scalar::Util qw(looks_like_number blessed);
use Readonly;

use Units::Relation;

# Участник сражения — не обязательно воин: это может быть оруженосец, животное и т.п.

sub new {
    my ($class, $health_points, $action_points, $perks) = @_;
    croak "Health points must be a number." unless looks_like_number($health_points);
    croak "Action points must be a number." unless looks_like_number($action_points);

    Readonly::Array my @ro_perks => @$perks;

    bless {
        max_health_points => $health_points,
        health_points => $health_points,

        max_action_points => $action_points,
        action_points => $action_points,

        perks => \@ro_perks,

        team => 0,
        conditions => {}
    }, $class;
}

# Номер команды (стороны конфликта). Ноль означает нейтральную сторону. Вначале все юниты нейтральные.
sub team {
    my ($self, $new) = @_;
    my $last = $self->{team};
    if (defined $new) {
        croak "Team must be a number." unless looks_like_number($new);
        $self->{team} = $new;
    }
    $last;
}

# Книга заклинаний/навыков.
sub perks {
    my $self = shift;
    $self->{perks};
}

# Очки жизни еще выше нуля.
sub is_alive {
    my $self = shift;
    $self->{health_points} > 0;
}

# Число от нуля до единицы, где 1 означает стопроцентное здоровье.
sub health {
    my $self = shift;
    $self->{health_points} / $self->{max_health_points};
}

# Как данный участник видит другого участника.
sub identify {
    my ($self, $combanant) = @_;
    croak "The other must be a Combatant." unless UNIVERSAL::isa($combanant, 'Units::Combatant');

    if ($self == $combanant) {
        return Units::Relation->SELF | Units::Relation->ALLY;
    } elsif ($self->{team} && $combanant->{team}) {

        if ($self->{team} == $combanant->{team}) {
            return Units::Relation->ALLY;
        } else {
            return Units::Relation->ENEMY;
        }

    } else {
        return 0;   # Никакое, нейтральное отношение.
    }
}


# Стандартная атака данного персонажа в его текущем положении. Метод должен быть переопределён у боевых персонажей.
# Расстояние до противника указывается в метрах. Флаг estimate означает, что атака не выполняется, а результат
# показывает, какой она будет, если её осуществить (это полезно для демонстрации подсказок в UI и для игрового ИИ),
# при этом предсказание поля status не гарантируется.
#
# TODO поменять порядок аргументов
#
# %param: enemy*, distance*, estimate
# TODO returns: ActionResult или, в случае невозможности действия, ничего.
sub attack { }

# Применить навык. Причём, некоторые навыки можно применять только на врагах, некоторые только на союзниках,
# некоторые (batch=1) вообще действуют глобально: можно, например, передать всех врагов или всех союзников
# по цене одного применения.
#
# Важно: combatants — массив пар из ссылок на юниты и расстояний до них.
# Они автоматически отфильтруются. Действие будет засчитано, если подходит хотя бы один юнит из списка.
#
# @param: estimate*, perk*, combatants...
# returns: ActionResult или, в случае невозможности действия, ничего.
sub use_perk {
    my $self = shift;
    my $estimate = shift;
    my $perk = shift;
    my @combatants = @_;

    croak "This unit doesn't, how to do that." unless grep { $_ == $perk } @{$self->perks};
    croak 'Estimate flag must be equal to 0 or 1.' unless (0 == $estimate) || (1 == $estimate);

    my @filtered = ();

    foreach my $pair ( pairs @combatants ) {
        my ($unit, $distance) = @$pair;
        my $relation = $self->identify($unit);
        if ($perk->fits($distance, $relation)) {
            push @filtered, $unit;
        }
    }

    if (scalar @filtered) {
        my $cost = $perk->apply(\@filtered, $estimate);
        my $perk_name = $perk->{name};
        say "$self have used perk $perk_name"
        # TODO return Behaviour::ActionResult->new()
    }
}

# Получить урон (аргумент ниже нуля) или восстановить здоровье (аргумент выше нуля).
# Принимает количество очков здоровья. Работает только у живых.
sub change_health {
    my ($self, $difference) = @_;
    if ($self->is_alive) {

        if ($difference < 0) {
            my $damage = -$difference;

            if ($damage >= $self->{health_points}) {
                $self->pass_away;
            } else {
                $self->{health_points} -= $damage;
            }

        } elsif ($difference > 0) {
            my $calculated = $self->{health_points} + $difference;
            $self->{health_points} = min($calculated, $self->{max_health_points});
        }
    }
}

# Скончаться.
sub pass_away {
    my $self = shift;
    $self->{health_points} = 0;
    say "$self died.";
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
