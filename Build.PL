#!/usr/bin/env perl

use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
	module_name => 'MooseX::EventEmitter',

	dist_author => 'Tudor Marghidanu',
	dist_abstract => 'Event emitter for Moose',

	meta_merge => {
		resources => {
			repository => 'https://github.com/marghidanu/moosex-event-emitter'
		},

		x_contributors => [
			'Tudor Marghidanu <tudor@marghidanu.com>',
		],
	},

	license => 'artistic_2',

	# NOTE: Keep list sorted!
	requires => {
		'Moose' => undef,
		'Test::More' => undef,
		'Test::Pod::Coverage' => undef,
		'Test::Pod' => undef,
	},

	optional => { },
);

$builder->create_build_script();
