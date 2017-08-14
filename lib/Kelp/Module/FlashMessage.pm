use strict;
use warnings;
package Kelp::Module::FlashMessage;

our $VERSION = 0.05;

use parent 'Kelp::Module';

sub build {
	my ( $self, %args ) = @_;
	my $key = $args{'key'} || 'km::flash';

	$self->register(
		flash_message => sub { 
			my ($self, $value) = @_;
			if( @_ == 1 ) { 
				$value = delete $self->req->env->{'psgix.session'}->{$key};
			}
			elsif( @_ >= 2 ) {
				$self->req->env->{'psgix.session'}->{$key} = $value;
			}
			return $value;
		},

		flash_message_present => sub { 
			my $self = shift;
			return exists $self->req->env->{'psgix.session'}->{$key};
		}
	);
}

1;

__END__

=pod

=head1 NAME

Kelp::Module::FlashMessage - Kelp flash message support

=head1 VERSION

version 0.01

=head1 SYNOPSIS

Module configuration:

    # conf/config.pl
    {
        modules      => ['FlashMessage'],
        modules_init => {
            'FlashMessage' => {
               key => 'flash_custom_key' 
               # optional custom key name, the default is 'km::flash'
               # it will be used to store the flash message into the session
            },
        }
    }

Usage (from a route)

   package MyApp;
   use Kelp::Base 'Kelp';

   sub some_route {
      my $self = shift;
      $self->flash_message('my flash message' );
      return $self->template('my_template', {
               'fmp' => sub { $self->flash_message_present },
               'fm'  => sub { $self->flash_message }
             });	
   }

And finally, the template that consumes the flash message (Text::Xslate example):

   : if $fmp()  {
   Message: <: $fm() :>
   : }

   : if $fmp()  {
   Message (should you see this? - no!)
   There isn't flash message after you consume it
   : }

=head1 REQUIREMENTS

It needs the Plack::Middleware::Session to work properly. See the adding
middleware section in the main Kelp documentation.


=head1 REGISTERED METHODS

This module registers two methods into the application: 

=over 3

=item C<flash_message> 

get/sets the flash message. When you get the flash
message value, it is deleted.

=item C<flash_message_present> 

returns a true value if the flash message
is present. It may be called many times without clear the message 

=back


=head1 AUTHOR

Miguel Prz, <niceperl at gmail.com>

=head1 BUGS

Please report any bugs or feature requests through
the web interface at L<https://rt.cpan.org/Public/Dist/Display.html?Name=Kelp-Module-FlashMessage>. 
I will be notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Kelp::Module::FlashMessage


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Kelp-Module-FlashMessage>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Kelp-Module-FlashMessage>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Kelp-Module-FlashMessage>

=item * Search CPAN

L<http://search.cpan.org/dist/Kelp-Module-FlashMessage/>

=back


=head1 ACKNOWLEDGEMENTS

To Stefan Geneshky, the creator of great Kelp web framework

=head1 COPYRIGHT & LICENSE

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
