use strict;
use Test::More tests => 2;

use Canonical;

ok my $cn = Canonical->new, 'new';
isa_ok $cn, 'Canonical', 'is canonical';


