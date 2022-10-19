use utf8;
package PhoneBook::Schema::Result::BookRecord;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table('book_record');

__PACKAGE__->add_columns(
    'book_record_id' => { data_type => 'integer' },
    'book_id' => { data_type => 'integer', is_nullable => 0 },
    'name' => {
        data_type => 'varchar',
        is_nullable => 0,
    },
    'phone' => {
        data_type => 'varchar',
        is_nullable => 0,
        size => 20,
    });

__PACKAGE__->set_primary_key('book_record_id');

__PACKAGE__->belongs_to(book => 'PhoneBook::Schema::Result::Book', 'book_id');

1;
