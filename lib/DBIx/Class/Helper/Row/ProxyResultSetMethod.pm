package DBIx::Class::Helper::Row::ProxyResultSetMethod;
{
  $DBIx::Class::Helper::Row::ProxyResultSetMethod::VERSION = '2.016003';
}

use strict;
use warnings;

# ABSTRACT: Efficiently reuse ResultSet methods from results

use base 'DBIx::Class::Helper::Row::SelfResultSet';
use Sub::Name ();

use DBIx::Class::Candy::Exports;

export_methods [qw( proxy_resultset_method )];

sub proxy_resultset_method {
   my ($self, $name, $attr) = @_;

   my $rs_method   = $attr->{resultset_method} || "with_$name";
   my $slot        = $attr->{slot} || $name;

   no strict 'refs';
   my $method = $self . '::' . $name;
   *{$method} = Sub::Name::subname $method, sub {
      use strict 'refs';

      # boo.  The accessor checks that there's an actual column defined, so we
      # skip it so we can cache results.
      $_[0]->{_column_data}{$slot} = $_[0]->self_rs
         ->search(undef, { columns => [] })
         ->$rs_method
         ->get_column($slot)
         ->next unless $_[0]->has_column_loaded($slot);
      return $_[0]->get_column($slot)
   }
}

1;

__END__

=pod

=head1 NAME

DBIx::Class::Helper::Row::ProxyResultSetMethod - Efficiently reuse ResultSet methods from results

=head1 VERSION

version 2.016003

=head1 SYNOPSIS

ResultSet:

 package MyApp::Schema::ResultSet::Foo;

 use base 'DBIx::Class::ResultSet';

 __PACKAGE__->load_components(qw(
    Helper::ResultSet::CorrelateRelationship
 ));

 ...;

 sub with_friend_count {
    shift->search(undef, {
       '+columns' => {
          'friend_count' => $self->correlate('friends')->count_rs->as_query,
       },
    })
 }

Result:

 package MyApp::Schema::Result::Foo;

 use base 'DBIx::Class::Core';

 __PACKAGE__->load_components(qw( Helper::Row::ProxyResultSetMethod ));

 __PACKAGE__->proxy_resultset_method('friend_count');

or with L<DBIx::Class::Candy>:

 package MyApp::Schema::Result::Foo;

 use DBIx::Class::Candy -components => ['Helper::Row::ProxyResultSetMethod'];

 proxy_resultset_method 'friend_count';

Elsewhere:

 my $row = $foo_rs->first;
 say $row->friend_count . ' friends';

=head1 DESCRIPTION

This module makes reusing resultset methods from a result trivially easy.  You
should be using it.

=head1 METHODS

=head2 proxy_resultset_method

 __PACKAGE__->proxy_resultset_method( $name => {
    slot             => $slot,
    resultset_method => $rs_method
 });

C<proxy_resultset_method>'s first argument is the name of the method to
generate and is required.  The other two arguments, C<$slot>, and
C<$resultset_method> are optional.  If unspecified C<$slot> will default to
C<$name> and C<$resultset_method> will default to C<"with_$name">.  C<$slot>
is the column that the data being retrieved is stored as in the ResultSet
method being proxied to.  C<$resultset_method> is (duh) the ResultSet method
being proxied to.

=head1 CANDY EXPORTS

If used in conjunction with L<DBIx::Class::Candy> this component will export:

=over

=item proxy_resultset_method

=back

=head1 DEDICATION

This module is dedicated to Ray Bradbury, who wrote Something Wicked This Way
Comes, Dandelion Wine, and numerous short stories, plays, etc etc.  Read this
author's books.

=head1 AUTHOR

Arthur Axel "fREW" Schmidt <frioux+cpan@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Arthur Axel "fREW" Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
