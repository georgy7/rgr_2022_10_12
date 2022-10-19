use utf8;
package PhoneBook::Schema::Result::Book;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table('book');

__PACKAGE__->add_columns(
    'book_id' => {
        data_type => 'integer',
    },
    'created' => {
        data_type => 'timestamp',
        is_nullable => 0,
    });

__PACKAGE__->set_primary_key('book_id');

1;
