package PhoneBook::Controller::Book;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 DESCRIPTION

Контроллер телефонной книги.
Через него же можно получить JSON со списком записей этой книги.

=cut


sub book : GET Path('') Chained CaptureArgs(1) {
    my ( $self, $c, $book_id ) = @_;

    if ($c->model('Book')->has_id($c, $book_id)) {
        $c->stash->{book_id} = $book_id;
        $c->stash->{template} = 'book/index.tt';
    } else {
        $c->response->status(404);
        $c->response->body("The book is not found.");
    }
}

sub records : GET Chained(book) {
    my ($self, $c) = @_;
    my $book_id = $c->stash->{book_id};

    if ($book_id) {
        $c->stash(result => $c->model('BookRecord')->find_by_book_id($c, $book_id));
    } else {
        $c->stash(result => [], error => 1);
    }

    delete $c->stash->{template};
    $c->forward('PhoneBook::View::JSON');
}

__PACKAGE__->meta->make_immutable;

1;
