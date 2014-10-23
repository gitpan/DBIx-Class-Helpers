package TestSchema::Result::Gnarly_Station;
our $VERSION = '2.003002';
use parent 'DBIx::Class';
use strict;
use warnings;

__PACKAGE__->load_components(qw{Helper::Row::JoinTable Core});

my $config = {
   left_class          => 'Gnarly',
   left_method         => 'gnarly',
   left_method_plural  => 'gnarlies',
   right_class         => 'Station',
   right_method        => 'station',
   right_method_plural => 'stations',
   self_method         => 'gnarly_stations',
};

__PACKAGE__->join_table($config);
__PACKAGE__->generate_has_manys($config);
__PACKAGE__->generate_many_to_manys($config);
1;
