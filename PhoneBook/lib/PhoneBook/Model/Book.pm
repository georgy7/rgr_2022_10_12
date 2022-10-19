package PhoneBook::Model::Book;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Model';

=head1 DESCRIPTION

Сервис работы с телефонными книгами.

=encoding utf8
=cut


# Есть ли такой идентификатор в базе.
sub has_id {

    # Я пока не могу понять, как заинджектить стандартные модели
    # в свои сервисы, чтобы не нужно было так колхозить, передавая сюда контроллер.
    my ($self, $c, $book_id) = @_;

    !!($c->model('DB::Book')->find($book_id));
}

__PACKAGE__->meta->make_immutable;

1;
