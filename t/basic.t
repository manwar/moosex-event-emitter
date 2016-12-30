#!/usr/bin/env perl

package Person {
	use Moose;

	with 'MooseX::EventEmitter';

	sub save {
		my $self = shift();

		$self->emit( 'save', time() );
	}

	__PACKAGE__->meta()->make_immutable();
}

package main {
	use strict;
	use warnings;

	use Test::More;
	use Test::Moose;

	require_ok( 'Person' );

	my $person = Person->new();
	isa_ok( $person, 'Person' );
	can_ok( $person, qw( save ) );

	does_ok( $person, 'MooseX::EventEmitter' );
	can_ok( $person, qw( on emit unsubscribe ) );

	# --- Subscribe
	my $saved_at = undef;
	my $callback = sub {
		my ( $self, $time ) = @_;
		$saved_at = $time;
	};

	$person->on( save => $callback );
	$person->save();

	isnt( $saved_at, undef, 'Saving time exists' );
	ok( $saved_at <= time(), 'Current time is higher than save time' );

	# --- Unsubscribe
	undef( $saved_at );

	$person->unsubscribe( save => $callback );
	$person->save();

	is( $saved_at, undef, 'Saving time does not exist' );

	done_testing();
}
