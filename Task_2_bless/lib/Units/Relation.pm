use v5.10;
use strict;
use warnings;

package Units::Relation;

# Отношение одного юнита к другому.
# В норме отношение к себе будет равно SELF|ALLY.

use constant {
    SELF    => 0b0000_0001, # Один и тот же юнит.
    ALLY    => 0b0000_0010, # Союзник.
    ENEMY   => 0b0000_0100, # Враг.
};

1;
