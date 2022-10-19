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

    # Model возвращает DBIx::Class::ResultSet.
    my $book = $c->model('DB::Book')->find($book_id);

    if ($book) {

        # Чтобы передать в chained-метод.
        $c->stash->{resultset} = $book;

        $c->stash->{id} = $book_id;
        $c->stash->{template} = 'book/index.tt';
    } else {
        $c->response->status(404);
        $c->response->body("The book is not found.");
    }
}

sub records : GET Chained(book) {
    my ( $self, $c ) = @_;

    my $book = $c->stash->{resultset};

    if ($book) {

        my $records_rs = $c->model('DB::BookRecord')->search({
            book_id => $book->book_id
        }, {
            order_by => [ 'name' ]
        });

        $records_rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
        my @list = $records_rs->all();

        %{$c->stash} = ();
        $c->stash(result => \@list);
        $c->forward('PhoneBook::View::JSON');

    } else {
        $c->response->status(404);
        $c->response->body("The book is not found. *");
    }
}

__PACKAGE__->meta->make_immutable;

1;
