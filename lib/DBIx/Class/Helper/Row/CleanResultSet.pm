package DBIx::Class::Helper::Row::CleanResultSet;
$DBIx::Class::Helper::Row::CleanResultSet::VERSION = '2.023002';
use strict;
use warnings;

# ABSTRACT: Shortcut for C<< ->resultset >>

sub clean_rs { return shift->result_source->resultset }

1;

__END__

=pod

=head1 NAME

DBIx::Class::Helper::Row::CleanResultSet - Shortcut for C<< ->resultset >>

=head1 SYNOPSIS

In result class:

 __PACKAGE__->load_components('Helper::Row::CleanResultSet');

Elsewhere:

 $row->clean_rs->$some_rs_method

similar to:

 $row->result_source->resultset->$some_rs_method

=head1 DESCRIPTION

Sometimes you need to be able to access the ResultSet containing all rows.

=head1 METHODS

=head2 clean_rs

 $row->clean_rs

=head1 AUTHOR

Arthur Axel "fREW" Schmidt <frioux+cpan@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Arthur Axel "fREW" Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
