use v5.10;
use strict;
use warnings;

package Behaviour::Perks;

use Behaviour::Perk;
use Units::Relation;

use constant {
    REGENERATE => Behaviour::Perk->new(
        name => 'Лечиться',
        scope => Units::Relation->SELF,
        batch => 0,
        price => 7,
        hp_change => [5, 15]
    ),
    BEWITCH => Behaviour::Perk->new(
        name => 'Околдовать',
        scope => Units::Relation->ENEMY,
        batch => 0,
        price => 4,
        hp_change => [-1, -3],
        condition_changes => {
            bewitched => 0.25
        }
    ),
};

1;
