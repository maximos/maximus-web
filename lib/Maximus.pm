package Maximus;
use 5.12.0;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.90;
use Catalyst qw/
  ConfigLoader
  Compress::Gzip
  Authentication
  Authorization::Roles
  Assets
  Cache
  RequireSSL
  Static::Simple
  Session
  Session::Store::DBIC
  Session::State::Cookie
  StackTrace
  PageCache
  /;
use Log::Log4perl::Catalyst;
use Template::Stash;

extends 'Catalyst';

our $VERSION = '1.004000';
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
    name         => 'Maximus',
    default_view => 'TT',
    salt         => 'default-salt',
    timestamp    => time(),
    email        => {from => 'Maximus localhost@root',},

    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    'Plugin::Assets'                            => {
        minify      => 'minifier-xs',
        path        => '/static',
        output_path => 'assets/',
    },
    'Plugin::Cache' => {
        backend => {
            class              => 'Cache::FileCache',
            namespace          => 'Maximus',
            default_expires_in => 3600,
        },
    },
    'Plugin::PageCache' => {
        disable_index    => 0,
        set_http_headers => 1,
        expires          => 3600,
        auto_cache       => ['/module/sources/.+', '/timeline/(atom|rss)'],
    },
    'Plugin::Session' => {
        dbic_class => 'DB::Session',
        expires    => 3600,
    },
    'Plugin::Authentication' => {
        default_realm => 'website',
        realms        => {
            website => {
                credential => {
                    class              => 'Password',
                    password_field     => 'password',
                    password_type      => 'hashed',
                    password_hash_type => 'SHA-1',
                },
                store => {
                    class         => 'DBIx::Class',
                    user_model    => 'DB::User',
                    role_relation => 'roles',
                    role_field    => 'role',
                },
            },
        },
    },
    'require_ssl' => {remain_in_ssl => 0,},
);

# Setup logger
__PACKAGE__->log(
    Log::Log4perl::Catalyst->new(Maximus->path_to('/') . '/log.conf'));

# Add as_list VMethod to Template
$Template::Stash::LIST_OPS->{as_list} = sub {
    return ref($_[0]) eq 'ARRAY' ? shift : [shift];
};

# Start the application
__PACKAGE__->setup();

=head1 NAME

Maximus - Catalyst based application

=head1 SYNOPSIS

    script/maximus_server.pl

=head1 DESCRIPTION

Maximus is the webinterface and module manager backend for BlitzMax.

=head1 SEE ALSO

L<Maximus::Controller::Root>, L<maximus_serverl>, L<maximus_create>,
L<maximus_fastcgi>, L<maximus_mojo>, L<maximus_sql_ddl>,
L<maximus_sql_upgrade>, L<maximus_task>, L<maximus_test>, L<maximus_workerl>,
L<Catalyst>

=head1 AUTHOR

Christiaan Kras

=head1 LICENSE

Copyright (c) 2010-2013 Christiaan Kras

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
