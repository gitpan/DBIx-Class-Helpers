#!perl

use strict;
use warnings;

use lib 't/lib';
use Test::More;
use Test::Deep;

use TestSchema;
my $schema = TestSchema->deploy_or_connect();
$schema->prepopulate;

my $first = $schema->resultset('Bar')->search(undef, { order_by => 'id' })->first;

is($first->foo_id, 1, 'foo_id starts as 1');
is($first->get_storage_value('foo_id'), 1, 'foo_id storage value starts as 1');
$first->foo_id(2);
is($first->foo_id, 2, 'foo_id changes to 2');
is($first->get_storage_value('foo_id'), 1, 'foo_id storage value is still 1');
$first->update;
is($first->get_storage_value('foo_id'), 2, 'foo_id storage value is updated to 2');

done_testing;
