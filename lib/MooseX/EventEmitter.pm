package MooseX::EventEmitter {
	use Moose::Role;

	our $VERSION = '0.2';

	has '_events' => (
		is => 'ro',
		isa => 'HashRef[ArrayRef[CodeRef]]',
		default => sub { {} },
		traits => [ qw( Hash ) ],
		handles => {
			_get_events => 'get',
			_set_events => 'set',
			_has_events => 'defined',
			_delete_events => 'delete',
		}
	);

	sub emit {
		my ( $self, $name, @args ) = @_;

		$self->$_( @args )
			foreach( @{ $self->_get_events( $name ) || [] } );
	}

	sub on {
		my ( $self, $name, $callback ) = @_;

		$self->_set_events( $name => [] )
			unless( $self->_has_events( $name ) );

		push( @{ $self->_get_events( $name ) },
			$callback
		);
	}

	sub unsubscribe {
		my ( $self, $name, $callback ) = @_;

		if( $callback ) {
			$self->_set_events( $name,
				[ grep { $_ != $callback } @{ $self->_get_events( $name ) } ]
			);
		} else {
			$self->_delete_events( $name );
		}
	}

	no Moose::Role;
}

1;

__END__

=pod

=head1 NAME

MooseX::EventEmitter - Moose Event emitter

=head1 SYNOPSIS

	package Person {
		use Moose;

		with 'MooseX::EventEmitter';

		...

		sub save {
			my $self = shift();

			...

			$self->emit( 'saved', time() );
		}

		__PACKAGE__->meta()->make_immutable();
	}

	package main {
		use Person;

		my $person = Person->new( { ... } );

		$person->on( saved => sub {
				my ( $self, $saved_at ) = @_;

				printf( "Person saved at %d\n", $saved_at );
			}
		);

		$person->unsubscribe();
	}

=head1 DESCRIPTION

This was inspired by L<Mojo::EventEmitter> but adapted for Moose. Mojolicious has it's own
object system, I wanted to make this a L<Moose> "native" component. It's a lighter alternative
to L<MooseX::Event>. which has more knobs if you need that.

=head1 METHODS

=head2 on

	$object->on( event_name => sub { ... } );

Adds and subscriber to a named event.

=head2 emit

	$object->emit( 'event_name', $arg1, $arg2 );

Calls all subscribers to a given event and passes the arguments to each callback.

=head2 unsubscribe

	$object->unsubscribe( 'event_name' )
	$object->unsubscribe( 'event_name', $callback );

Removed a subscriber or all subscribers for the named event.

=head1 AUTHOR

Tudor Marghidanu <tudor@marghidanu.com>

=head1 LICENSE

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=head1 SEE ALSO

=over 4

=item *

L<MooseX::Event>

=item *

L<Mojo::EventEmitter>

=back

=head1 LICENSE

This program  is  free software; you can redistribute it and / or modify it under
the  terms  of the the Artistic License (2.0). You may obtain a  copy of the full
license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any  use,  modification, and distribution of the Standard or Modified Versions is
governed by this Artistic License.By using, modifying or distributing the Package,
you accept this license. Do not use, modify, or distribute the Package, if you do
not accept this license.

If your Modified Version has been derived from a Modified Version made by someone
other than you,you are nevertheless required to ensure that your Modified Version
 complies with the requirements of this license.

This  license  does  not grant you the right to use any trademark,  service mark,
tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge patent license
to make,  have made, use,  offer to sell, sell, import and otherwise transfer the
Package with respect to any patent claims licensable by the Copyright Holder that
are  necessarily  infringed  by  the  Package. If you institute patent litigation
(including  a  cross-claim  or  counterclaim) against any party alleging that the
Package constitutes direct or contributory patent infringement,then this Artistic
License to you shall terminate on the date that such litigation is filed.

Disclaimer  of  Warranty:  THE  PACKAGE  IS  PROVIDED BY THE COPYRIGHT HOLDER AND
CONTRIBUTORS  "AS IS'  AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES. THE IMPLIED
WARRANTIES    OF   MERCHANTABILITY,   FITNESS   FOR   A   PARTICULAR  PURPOSE, OR
NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY YOUR LOCAL LAW. UNLESS
REQUIRED BY LAW, NO COPYRIGHT HOLDER OR CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL,  OR CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE
OF THE PACKAGE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut
