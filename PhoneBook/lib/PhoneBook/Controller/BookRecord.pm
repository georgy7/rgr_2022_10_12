package PhoneBook::Controller::BookRecord;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 DESCRIPTION

Контроллер записей телефонной книги.

=encoding utf8
=cut


sub save : POST Path('') {
    my ( $self, $c ) = @_;
    my $record_id = $c->req->params->{id};
    my $book_id = $c->req->params->{book_id};

    if ($record_id) {
        $c->model('BookRecord')->update($c, $record_id, $c->req->params);
    } elsif ($book_id) {
        if ($c->model('Book')->has_id($c, $book_id)) {
            $record_id = $c->model('BookRecord')->create($c, $c->req->params);
        }
    }

    $c->stash(id => $record_id);
    $c->forward('PhoneBook::View::JSON');
}

sub delete : DELETE Path('') {
    my ( $self, $c ) = @_;
    my $record_id = $c->req->params->{id};

    if ($record_id) {
        # При наличии авторизации, здесь бы была нужна проверка,
        # принадлежит ли книга, в которой находится запись, пользователю.
        $c->model('BookRecord')->delete($c, $record_id);
        $c->response->body('OK');
    } else {
        $c->response->status(404);
        $c->response->body("The book is not found.");
    }
}

__PACKAGE__->meta->make_immutable;

1;
