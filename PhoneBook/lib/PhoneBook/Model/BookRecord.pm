package PhoneBook::Model::BookRecord;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Model';

=head1 DESCRIPTION

Сервис работы с записями в телефонных книгах.

=encoding utf8
=cut

# Возвращает ссылку на массив хэшей.
sub find_by_book_id {

    # Я пока не могу понять, как заинджектить стандартные модели
    # в свои сервисы, чтобы не нужно было так колхозить, передавая сюда контроллер.
    my ($self, $c, $book_id) = @_;

    my $records_rs = $c->model('DB::BookRecord')->search({
        book_id => $book_id
    }, {
        order_by => [ 'name' ]
    });

    $records_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    my @list = $records_rs->all();
    \@list;
}

__PACKAGE__->meta->make_immutable;

1;
