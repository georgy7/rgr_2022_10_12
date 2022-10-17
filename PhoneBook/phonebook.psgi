use strict;
use warnings;

use PhoneBook;

my $app = PhoneBook->apply_default_middlewares(PhoneBook->psgi_app);
$app;

