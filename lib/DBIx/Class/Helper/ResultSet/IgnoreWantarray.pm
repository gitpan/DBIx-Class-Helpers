package DBIx::Class::Helper::ResultSet::IgnoreWantarray;
$DBIx::Class::Helper::ResultSet::IgnoreWantarray::VERSION = '2.024001';
use strict;
use warnings;

# ABSTRACT: Get rid of search context issues

sub search {
   $_[0]->throw_exception ('->search is *not* a mutator, calling it in void context makes no sense')
      if !defined wantarray && (caller)[0] !~ /^\QDBIx::Class::/;

   shift->search_rs(@_);
}

1;

__END__

=pod

=head1 NAME

DBIx::Class::Helper::ResultSet::IgnoreWantarray - Get rid of search context issues

=head1 SYNOPSIS

 package MyApp::Schema::ResultSet::Foo;

 __PACKAGE__->load_components(qw{Helper::ResultSet::IgnoreWantarray});

 ...

 1;

And then else where, like in a controller:

 my $rs = $self->paginate(
   $schema->resultset('Foo')->search({
      name => 'frew'
   })
 );

=head1 DESCRIPTION

This component makes search always return a ResultSet, instead of
returning an array of your database in array context. See
L<DBIx::Class::Helper::ResultSet/NOTE> for a nice way to apply it to your
entire schema.

=head1 METHODS

=head2 search

Override of the default search method to force it to return a ResultSet.

=head1 AUTHOR

Arthur Axel "fREW" Schmidt <frioux+cpan@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Arthur Axel "fREW" Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
