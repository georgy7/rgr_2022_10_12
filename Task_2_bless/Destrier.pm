use v5.10;
use strict;
use warnings;

package Destrier;
use parent 'Combatant';

# Рыцарский боевой конь.
# Пока непонятно, требуется ли ему некоторое автономное от рыцаря поведение.

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(10_000_000_000_000);
    return $self;
}

1;
