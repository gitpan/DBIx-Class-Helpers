package DBIx::Class::Helper::Schema::DidYouMean;
$DBIx::Class::Helper::Schema::DidYouMean::VERSION = '2.024001';
# ABSTRACT: Nice error messages when you misspell the name of a ResultSet

use strict;
use warnings;

use Text::Brew 'distance';
use Try::Tiny;
use namespace::clean;

sub source {
   my ($self, @rest) = @_;

   my $method = $self->next::can;

   try {
      $self->$method(@rest)
   } catch {
      if (m/Can't find source for (.+?) at/) {
         my @presentsources = map {
           (distance($_, $1))[0] < 3 ? " * $_ <-- Possible Match\n" : "   $_\n";
         } sort $self->storage->schema->sources;

         die <<"ERR";
$_
The ResultSet "$1" is not part of your schema.

To help you debug this issue, here's a list of the actual sources that the
schema knows about:

 @presentsources
ERR
      }
      die $_;
   }
}

1;

__END__

=pod

=head1 NAME

DBIx::Class::Helper::Schema::DidYouMean - Nice error messages when you misspell the name of a ResultSet

=head1 SYNOPSIS

 package MyApp::Schema;

 __PACKAGE__->load_components('Helper::Schema::DidYouMean');

Elsewhere:

 $schema->resultset('Usre')->search(...)->...

And a nice exception gets thrown:

 The ResultSet "Usre" is not part of your schema.
 
 To help you debug this issue, here's a list of the actual sources that the
 schema knows about:
 
     Account
     Permission
     Role
   * User <-- Possible Match

=head1 DESCRIPTION

This helper captures errors thrown when you use the C<resultset> method on your
schema and typo the source name.  It tries to highlight the best guess as to
which you meant to type.

=head1 AUTHOR

Arthur Axel "fREW" Schmidt <frioux+cpan@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Arthur Axel "fREW" Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
