use strict;
use Test::More tests => 2;

use Canonical;

my $cn = Canonical->new;

ok $cn->agent eq 'CanonicalURI Crawler/' . $Canonical::VERSION . ' (http://ashula.info/drops/canonical)', 'default user agent';

$cn->agent( 'canonical' );
ok $cn->agent eq 'canonical', 'ua = canonical';




