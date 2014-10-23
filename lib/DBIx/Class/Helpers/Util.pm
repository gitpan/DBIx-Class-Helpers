package DBIx::Class::Helpers::Util;
{
  $DBIx::Class::Helpers::Util::VERSION = '2.016006';
}

use strict;
use warnings;

# ABSTRACT: Helper utilities for DBIx::Class components

use Sub::Exporter::Progressive -setup => {
    exports => [
      qw(
         get_namespace_parts is_load_namespaces is_not_load_namespaces
         assert_similar_namespaces order_by_visitor
      ),
    ],
  };

sub get_namespace_parts {
   my $package = shift;

   if ($package =~ m/(^[\w:]+::Result)::([\w:]+)$/) {
      return ($1, $2);
   } else {
      die "$package doesn't look like ".'$namespace::Result::$resultclass';
   }
}

sub is_load_namespaces {
   my $namespace = shift;
   $namespace =~ /^[\w:]+::Result::[\w:]+$/;
}

sub is_not_load_namespaces {
   my $namespace = shift;
      $namespace =~ /^([\w:]+)::[\w]+$/ and
      $1           !~ /::Result/;
}

sub assert_similar_namespaces {
   my $ns1 = shift;
   my $ns2 = shift;

   die "Namespaces $ns1 and $ns2 are dissimilar"
      unless is_load_namespaces($ns1) and is_load_namespaces($ns2) or
             is_not_load_namespaces($ns1) and is_not_load_namespaces($ns2);
}

sub _order_by_visitor_HASHREF {
   my ($hash, $callback) = @_;

   my %ret;
   # there should only be one k/v pair, but DBIC checks for that and I'm not
   # going to reimplement said check here.
   for my $k (keys %$hash) {
      my $v = $hash->{$k};

      if (my $v_ref = ref $v) {
         if ($v_ref eq 'ARRAY' ) {
            $ret{$k} = [ map $callback->($_), @$v ]
         } else {
            die 'this should never happen'
         }
      } else {
         $ret{$k} = ($callback->($v));
      }
   }

   \%ret
}

sub order_by_visitor {
   my ($order, $callback) = @_;

   if (my $top_ref = ref $order) {
      if ($top_ref eq 'HASH') {
         return _order_by_visitor_HASHREF($order, $callback)
      } elsif ($top_ref eq 'ARRAY') {
         return [
            map {
               if (my $ref = ref $_) {
                  if ($ref eq 'HASH') {
                     _order_by_visitor_HASHREF($_, $callback)
                  } else {
                     die 'this should never happen'
                  }
               } else {
                  $callback->($_)
               }
            } @$order
         ];
      }
   } else {
      return $callback->($order)
   }
}

1;

__END__

=pod

=head1 NAME

DBIx::Class::Helpers::Util - Helper utilities for DBIx::Class components

=head1 VERSION

version 2.016006

=head1 SYNOPSIS

 use DBIx::Class::Helpers::Util ':all';

 my ($namespace, $class) = get_namespace_parts('MyApp:Schema::Person');
 is $namespace, 'MyApp::Schema';
 is $class, 'Person';

 if (is_load_namespaces('MyApp::Schema::Result::Person')) {
   print 'correctly structured project';
 }

 if (is_not_load_namespaces('MyApp::Schema::Person')) {
   print 'incorrectly structured project';
 }

 if (assert_similar_namespaces('MyApp::Schema::Person', 'FooApp::Schema::People')) {
   print 'both projects are structured similarly';
 }

 if (assert_similar_namespaces('MyApp::Schema::Result::Person', 'FooApp::Schema::Result::People')) {
   print 'both projects are structured similarly';
 }

 # in a resultset

 sub search {
    my ($self, $search, $attrs) = @_;

    $attrs->{order_by} = order_by_visitor($attrs->{order_by}, sub {
       my $field = shift;

       return 'foo_bar' if $field eq 'foo.bar';
       return $field;
    }) if $attrs && $attrs->{order_by};
 }

=head1 DESCRIPTION

A collection of various helper utilities for L<DBIx::Class> stuff.  Probably
only useful for components.

=head1 EXPORTS

=head2 order_by_visitor

This function allows you to easily transform C<order_by> clauses. See
L</SYNOPSIS> for example.

=head2 get_namespace_parts

Returns the namespace and class name of a package.  See L</SYNOPSIS> for example.

=head2 is_load_namespaces

Returns true if a package is structured in a way that would work for
load_namespaces.  See L</SYNOPSIS> for example.

=head2 is_not_load_namespaces

Returns true if a package is structured in a way that would not work for
load_namespaces.  See L</SYNOPSIS> for example.

=head2 assert_similar_namespaces

Dies if both packages are structured in the same way.  The same means both are
load_namespaces or both are not.  See L</SYNOPSIS> for example.

=head1 AUTHOR

Arthur Axel "fREW" Schmidt <frioux+cpan@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Arthur Axel "fREW" Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
