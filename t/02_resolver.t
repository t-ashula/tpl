use strict;
use Test::More tests => 8;
use Test::Exception;

use Canonical;

my $cn = Canonical->new;

sub test_redirect {
  my ($s, $l, $m) = @_;
  is $cn->canonical( $s ), $l, "$m";
}

test_redirect 'http://goo.gl/e', 'http://www.google.com/', 'goo.gl/e -> www.google.com' ;
is $cn->canonical( url => 'http://goo.gl/e' ), 'http://www.google.com/', '{ url => goo.gl/e } -> www.google.com';

test_redirect 'https://bit.ly/aa', 'http://www.jewishhigh.com', 'https is supported/ https://bit.ly/aa -> www.jewishhigh.com';
test_redirect 'http://t.co/jpXmjiV', 'http://buzztter.com/ja', 't.co';

test_redirect 'http://www.google.com', 'http://www.google.com', 'no redirect';

throws_ok { $cn->canonical(); } qr/no arguments error/, 'no args error';
throws_ok { $cn->canonical( 'foobar:hoge' ); } qr/not supported scheme/, 'https? only';
throws_ok { $cn->canonical( q => 'a' ); } qr/no url found/, 'url required';

