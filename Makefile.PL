use inc::Module::Install;
name 'Canonical';
all_from 'lib/Canonical.pm';

requires 'LWP::Protocol::https';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
