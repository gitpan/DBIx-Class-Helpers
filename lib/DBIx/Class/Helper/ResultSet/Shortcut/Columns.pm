package DBIx::Class::Helper::ResultSet::Shortcut::Columns;
$DBIx::Class::Helper::ResultSet::Shortcut::Columns::VERSION = '2.019003';
use strict;
use warnings;

sub columns { shift->search(undef, { columns => shift }) }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

DBIx::Class::Helper::ResultSet::Shortcut::Columns

=head1 VERSION

version 2.019003

=head1 AUTHOR

Arthur Axel "fREW" Schmidt <frioux+cpan@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Arthur Axel "fREW" Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
