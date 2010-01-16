package TestSchema::Result::Gnarly;
our $VERSION = '2.00102';
use parent 'DBIx::Class';
use strict;
use warnings;

__PACKAGE__->load_components('Core');

__PACKAGE__->table('Gnarly');

__PACKAGE__->add_columns(qw/ id name /);

__PACKAGE__->set_primary_key('id');


1;
