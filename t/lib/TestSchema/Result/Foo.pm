package TestSchema::Result::Foo;
our $VERSION = '2.002001';

use strict;
use warnings;

use parent 'ParentSchema::Result::Foo';

__PACKAGE__->load_components(qw{Helper::Row::NumifyGet Helper::Row::SubClass Core});

__PACKAGE__->subclass;

1;
