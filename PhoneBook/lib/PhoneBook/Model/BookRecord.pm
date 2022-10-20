package PhoneBook::Model::BookRecord;
use Moose;
use namespace::autoclean;
use Carp qw(croak);

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

    # Вообще, наверно, правильнее было бы затереть название таблицы в идентификаторе,
    # чтобы он назывался просто id на фронтенде.
    $records_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
    my @list = $records_rs->all();
    \@list;
}

sub validate_fields {
    my ($self, $fields) = @_;

    # Также, неясно, как валидировать, чтобы вываливалась ошибка 400, а не 500.
    # Вполне же логично делать валидацию не только в контроллере.
    # Или так не принято?

    $fields->{phone} =~ s/^\s+|\s+$//;

    croak 'The name is too large.'          if length($fields->{name}) > 255;
    croak 'The phone number is too large.'  if length($fields->{phone}) > 20;

    croak 'Bad phone number format' unless $fields->{phone} =~ /^\+?(\d+|\-|\(|\)| )+$/;
}

sub create {
    my ($self, $c, $fields) = @_;
    $self->validate_fields($fields);

    my $row = $c->model('DB::BookRecord')->create({
        book_id => $fields->{book_id},
        name => $fields->{name},
        phone => $fields->{phone},
    });

    $row->book_record_id;
}

sub update {
    my ($self, $c, $id, $fields) = @_;
    $self->validate_fields($fields);

    my $record = $c->model('DB::BookRecord')->find({book_record_id => $id});
    croak 'The record must exist.' unless $record;

    if ($record) {
        $record->name($fields->{name});
        $record->phone($fields->{phone});
        $record->update();
    }
}

sub delete {
    my ($self, $c, $id) = @_;
    my $record = $c->model('DB::BookRecord')->find({book_record_id => $id});
    if ($record) {
        $record->delete();
    }
}

__PACKAGE__->meta->make_immutable;

1;
