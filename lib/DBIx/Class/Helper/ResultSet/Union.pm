package DBIx::Class::Helper::ResultSet::Union;
our $VERSION = '2.00000_2';

use strict;
use warnings;

# ABSTRACT: Do unions with DBIx::Class

# cribbed from perlfaq4
sub _compare_arrays {
   my ($self, $first, $second) = @_;

   no warnings; # silence spurious -w undef complaints
   return 0 unless @$first == @$second;
   for (my $i = 0; $i < @$first; $i++) {
      return 0 if $first->[$i] ne $second->[$i];
   }
   return 1;
}

sub union {
   my ( $self, $other) = @_;

   $other = [$other] if ref $other ne 'ARRAY';

   push @{$other}, $self;

   my @sql;
   my @params;

   my $as = $self->_resolved_attrs->{as};

   for (@{$other}) {
      $self->throw_exception('ResultClass of queries passed to union do not match!')
         unless ref $self->_result_class eq ref $_->_result_class;

      my $attrs = $_->_resolved_attrs;

      $self->throw_exception('ResultSets do not all have the same selected columns!')
         unless $self->_compare_arrays($as, $attrs->{as});

      my ($sql, $bind) = $self->result_source->storage->_select_args_to_query(
         $attrs->{from}, $attrs->{select}, $attrs->{where}, $attrs
      );

      push @sql, $sql;
      push @params, @{$bind};
   }

   my $query = q<(> . join(' UNION ', @sql). q<)>;

   return $self->result_source->resultset->search(undef, {
      from => [{
         me             => \[ $query, @params ],
         -alias         => $self->current_source_alias,
         -source_handle => $self->result_source->handle,
      }]
   });
}

1;


__END__
=pod

=head1 NAME

DBIx::Class::Helper::ResultSet::Union - Do unions with DBIx::Class

=head1 VERSION

version 2.00000_2

=head1 SYNOPSIS

 package MyApp::Schema::ResultSet::Foo;

 __PACKAGE__->load_components(qw{Helper::ResultSet::Union});

 ...

 1;

And then elsewhere, like in a controller:

 my $rs1 = $rs->search({ foo => 'bar' });
 my $rs2 = $rs->search({ baz => 'biff' });
 for ($rs1->union($rs2)->all) { ... }

=head1 DESCRIPTION

This component allows you to create unions with your ResultSets.  See
L<DBIx::Class::Helper::ResultSet/NOTE> for a nice way to apply it to your
entire schema.

=head1 METHODS

=head2 union

Takes a single ResultSet or an ArrayRef of ResultSets as the parameter.

Component throws exceptions if ResultSets have different ResultClasses or
different "Columns Specs."

=head1 AUTHOR

  Arthur Axel "fREW" Schmidt <frioux+cpan@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Arthur Axel "fREW" Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

