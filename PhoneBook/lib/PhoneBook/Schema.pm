use utf8;
package PhoneBook::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2022-10-18 20:59:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Z7Va4QxJQ1Y90K3NNBceVw

our $VERSION = 1;

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
