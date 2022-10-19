use strict;
use warnings;
use utf8;
use DBIx::Class::Migration::RunScript;

migrate {

    my $book_rs = shift->schema->resultset('Book');

    $book_rs->create({ created => 1666145637 });

};
