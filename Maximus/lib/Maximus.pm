package Maximus;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;
use Catalyst qw/
    -Debug
    ConfigLoader
	Authentication
	Authorization::Roles
    Static::Simple
	Session
	Session::Store::DBIC
	Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in maximus.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Maximus',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
	'Plugin::Session' => {
		dbic_class => 'DB::Session',
		explires => 3600,
	},
	'Plugin::Authentication' => {
		default_realm => 'website',
		realms => {
			website => {
				credential => {
					class => 'Password',
					password_field => 'password',
					password_type => 'hashed',
					password_hash_type => 'SHA-1',
				},
				store => {
					class => 'DBIx::Class',
					user_model => 'DB::User',
					role_relation => 'roles',
					role_field => 'role',
				},
			},
		},
	},
);

# Start the application
__PACKAGE__->setup();


=head1 NAME

Maximus - Catalyst based application

=head1 SYNOPSIS

    script/maximus_server.pl

=head1 DESCRIPTION

Maximus is the webinterface and module manager backend for BlitzMax.

=head1 SEE ALSO

L<Maximus::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Christiaan Kras

=head1 LICENSE

Copyright (c) 2010 Christiaan Kras

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=cut

1;
