package DBIx::Class::Helper::ResultSet::ResultClassDWIM;
$DBIx::Class::Helper::ResultSet::ResultClassDWIM::VERSION = '2.023002';
# ABSTRACT: result_class => '::HRI' == WIN

use strict;
use warnings;

sub result_class {
   my ($self, $result_class) = @_;

   return $self->next::method unless defined $result_class;

   if (!ref $result_class) {
      if ($result_class eq '::HRI') {
         $result_class = 'DBIx::Class::ResultClass::HashRefInflator'
      } else {
         $result_class =~ s/^::/DBIx::Class::ResultClass::/;
      }
   }

   $self->next::method($result_class);
}

1;

__END__

=pod

=head1 NAME

DBIx::Class::Helper::ResultSet::ResultClassDWIM - result_class => '::HRI' == WIN

=head1 SYNOPSIS

 package MyApp::Schema::ResultSet::Foo;

 __PACKAGE__->load_components(qw{Helper::ResultSet::ResultClassDWIM});

 ...

 1;

And then elsewhere:

 my $data = $schema->resultset('Foo')->search({
      name => 'frew'
   }, {
      result_class => '::HRI'
   })->all;

=head1 DESCRIPTION

This component allows you to prefix your C<result_class> with C<::> to indicate
that it should use the default namespace, namely, C<DBIx::Class::ResultClass::>.

C<::HRI> has been hardcoded to work.  Of course C<::HashRefInflator> would
also work fine.

See L<DBIx::Class::Helper::ResultSet/NOTE> for a nice way to apply it to your
entire schema.

=head1 AUTHOR

Arthur Axel "fREW" Schmidt <frioux+cpan@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Arthur Axel "fREW" Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
