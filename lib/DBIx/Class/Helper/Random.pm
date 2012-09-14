package DBIx::Class::Helper::Random;
{
  $DBIx::Class::Helper::Random::VERSION = '2.015001';
}

use parent 'DBIx::Class::Helper::ResultSet::Random';
use Carp::Clan;
carp 'This module is deprecated!  Please use the namespaced version instead!' if $VERSION >= 3;
croak 'This module is deprecated!  Please use the namespaced version instead!' if $VERSION >= 4;

# ABSTRACT: (DEPRECATED) Get random rows from a ResultSet

1;

__END__

=pod

=head1 NAME

DBIx::Class::Helper::Random - (DEPRECATED) Get random rows from a ResultSet

=head1 VERSION

version 2.015001

=head1 DESCRIPTION

This component has been suplanted by
L<DBIx::Class::Helper::ResultSet::Random>.  In the next major version
(3) we will begin issuing a warning on it's use.  In the major version after
that (4) we will remove it entirely.

=head1 AUTHOR

Arthur Axel "fREW" Schmidt <frioux+cpan@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Arthur Axel "fREW" Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
