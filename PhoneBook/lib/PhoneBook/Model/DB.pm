package PhoneBook::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'PhoneBook::Schema',

    connect_info => [
        'dbi:SQLite:db/phonebook-schema.db', '', '',
        {
            sqlite_unicode => 1,
        }
    ]
);

1;
