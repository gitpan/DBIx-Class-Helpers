package DBIx::Class::Helper::Row::ProxyResultSetUpdate;
$DBIx::Class::Helper::Row::ProxyResultSetUpdate::VERSION = '2.021001';
# ABSTRACT: Efficiently reuse ResultSet updates from results

use base 'DBIx::Class::Helper::Row::SelfResultSet';

sub update {
  my ($self, $upd) = @_;

  $self->set_inflated_columns($upd) if $upd;

  my %to_update = $self->get_dirty_columns
    or return $self;

  $self->throw_exception( "Not in database" ) unless $self->in_storage;

  # copied directly from DBIx::Class::Row except for this line
  my $rows = $self->self_rs->update(\%to_update);
  if ($rows == 0) {
    $self->throw_exception( "Can't update ${self}: row not found" );
  } elsif ($rows > 1) {
    $self->throw_exception("Can't update ${self}: updated more than one row");
  }
  $self->{_dirty_columns} = {};
  $self->{related_resultsets} = {};
  delete $self->{_column_data_in_storage};
  return $self;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

DBIx::Class::Helper::Row::ProxyResultSetUpdate - Efficiently reuse ResultSet updates from results

=head1 VERSION

version 2.021001

=head1 SYNOPSIS

ResultSet:

 package MyApp::Schema::ResultSet::Foo;

 use base 'DBIx::Class::ResultSet';

 sub update {
    my ($self, $data) = @_;

    die 'you fool!' if $data->{name} eq 'fool';

    return $self->next::method($data);
 }

Result:

 package MyApp::Schema::Result::Foo;

 use base 'DBIx::Class::Core';

 __PACKAGE__->load_components(qw( Helper::Row::ProxyResultSetUpdate ));

 ...

or with L<DBIx::Class::Candy>:

 package MyApp::Schema::Result::Foo;

 use DBIx::Class::Candy -components => ['Helper::Row::ProxyResultSetMethod'];

 ...

=head1 DESCRIPTION

This module makes reusing resultset updates from a result trivially easy.
Often the only way that people share update methods is by overriding update
in their resultset to use L<DBIx::Class::ResultSet/update_all>.  Unfortunately,
that can end up being wildly inefficient.  Instead, if you can write your
update in terms of the resultset, you can make your code much faster and more
efficient.

=head1 AUTHOR

Arthur Axel "fREW" Schmidt <frioux+cpan@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Arthur Axel "fREW" Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
