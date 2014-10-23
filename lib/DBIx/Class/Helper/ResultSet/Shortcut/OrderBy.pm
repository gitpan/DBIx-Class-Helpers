package DBIx::Class::Helper::ResultSet::Shortcut::OrderBy;
{
  $DBIx::Class::Helper::ResultSet::Shortcut::OrderBy::VERSION = '2.017000';
}

use strict;
use warnings;

sub order_by { shift->search(undef, { order_by => shift }) }

1;

__END__

=pod

=head1 NAME

DBIx::Class::Helper::ResultSet::Shortcut::OrderBy

=head1 VERSION

version 2.017000

=head1 AUTHOR

Arthur Axel "fREW" Schmidt <frioux+cpan@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Arthur Axel "fREW" Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
