package MooseX::EventEmitter {
	use Moose::Role;

	our $VERSION = '0.1';

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
to L<MooseX::Event>. which more knobs if you need that.

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

=head1

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=head1 SEE ALSO

=over 4

=item *

L<MooseX::Event>

=item *

L<Mojo::EventEmitter>

=back

=cut
