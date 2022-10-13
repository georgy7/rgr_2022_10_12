use strict;
use warnings;
use feature qw(say);
use utf8;

binmode(STDOUT, ':utf8');

sub test {
    my($input) = @_;
    my $date;
    my $time;

    if ($input =~ /^(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2})$/a) {
        ($date, $time) = ($1, $2);
        say $date;
        say $time;
    }

    if ($input =~ /^(?<date>\d{4}-\d{2}-\d{2}) (?<time>\d{2}:\d{2}:\d{2})$/a) {
        say $+{date};
        say $+{time};
    }

    if ($input =~ /(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2})/a) {
        ($date, $time) = ($1, $2);
        say $date;
        say $time;
    }

    say '--------';
}

test '2016-04-11 20:59:03';
test '2016-04-11 20:59:0٣';
test 'qwerty 2016-04-11 20:59:03 zxcvbn';
