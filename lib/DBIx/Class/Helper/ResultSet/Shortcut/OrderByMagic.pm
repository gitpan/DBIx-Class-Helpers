package DBIx::Class::Helper::ResultSet::Shortcut::OrderByMagic;

use strict;
use warnings;

our $VERSION = '2.018001'; # VERSION

use base 'DBIx::Class::Helper::ResultSet::Shortcut::OrderBy';

sub order_by {
    my ($self, @order) = @_;

    ## pass thru if we have a HashRef format
    if (@order && ref($order[0]) eq 'HASH') {
        return $self->next::method($order[0]);
    }

    my @clauses;
    foreach (@order) {
        foreach my $col (split(/\s*,\s*/)) {
            my $dir = 'asc';
            if (substr($col, 0, 1) eq '!') {
                $col = substr($col, 1); # take everything after '!'
                $dir = 'desc';
            }
            push @clauses, { "-$dir" => join('.', $self->current_source_alias, $col) };
        }
    }

    return $self->next::method(\@clauses);
}

1;

__END__

=pod

=head1 NAME

DBIx::Class::Helper::ResultSet::Shortcut::OrderByMagic

=head1 VERSION

version 2.018001

=head1 AUTHOR

Arthur Axel "fREW" Schmidt <frioux+cpan@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Arthur Axel "fREW" Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
