#!/usr/bin/env perl
use lib "./lib";
use local::lib;
use Mojolicious::Lite;
use Config::Any;
use Maximus::Schema;
use Mojo::Util 'md5_sum';

# Set process name
$0 = "Maximus Mojo";

helper 'cfg' => sub {
    my $suffix = $ENV{MAXIMUS_CONFIG_LOCAL_SUFFIX};
    my $file = sprintf('maximus%s.conf', $suffix ? '_' . $suffix : '');
    return Config::Any->load_files(
        {   files           => [$file],
            use_ext         => 1,
            flatten_to_hash => 1,
        }
    )->{$file};
};

helper 'db' => sub {
    return Maximus::Schema->connect(
        shift->cfg->{'Model::DB'}->{connect_info});
};

get '/module/download/:scope/:module/#version' => sub {
    my $self     = shift;
    my $modscope = $self->stash('scope');
    my $module   = $self->stash('module');
    my $version  = $self->stash('version');

    my @search = (
        {   'modscope.name'           => $modscope,
            'me.name'                 => $module,
            'module_versions.version' => $version,
        },
        {join => [qw /modscope module_versions/],}
    );
    my $rs  = $self->db->resultset('Module')->search(@search);
    my $row = $rs->first;

    # Not found
    return $self->render_not_found unless $row;

    my $version_rs = $row->search_related(
        'module_versions',
        {version => $version},
        {columns => [qw/id remote_location/]}
    );
    my $version_row = $version_rs->first();
    return $self->render_not_found unless $version_row;

    # Redirect to remote location if available
    return $self->redirect_to($version_row->remote_location)
      if $version_row->remote_location;

    # Fetch archive data
    $version_row = $version_row->get_from_storage({columns => [qw/archive/]});

    my $filename = sprintf('%s-%s-%s.zip', $modscope, $module, $version);
    my $headers = $self->res->headers;
    $headers->add('Content-Disposition',
        qq[attachment; filename="$filename"]);
    $headers->add('ETag', md5_sum($version_row->archive));
    $self->render_data($version_row->archive, format => 'zip');
};

app->start;

=head1 NAME

maximus_mojo.pl - Mojolicious::Lite app

=head1 SYNOPSIS

maximus_mojo.pl [options]

=head1 DESCRIPTION

This L<Mojolicious::Lite> app can be used to run a lightweight service for
serving module packages from the database.

=head1 HELPERS

=head2 cfg

Loads the C<maximus.conf> file using L<Config::Any>. Which file to load can be
modified by setting the C<MAXIMUS_CONFIG_LOCAL_SUFFIX> environment variable.

=head2 db

Helper for setting up the database connection. Returns a L<Maximus::Schema>
object.

=head1 ROUTES

=head2 /module/download/:scope/:modules/#version

Serve module file from database or remote_location if it has been set. Route
matches that of the Catalyst application.

=head1 ENVIRONMENT

Set C<MAXIMUS_CONFIG_LOCAL_SUFFIX> to specify which config file to be
additonally loaded. Set it to C<testing> to load C<maximus_testing.conf>.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Lite>

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

