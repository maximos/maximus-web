#!/usr/bin/env perl
use lib "./lib";
use local::lib;
use Mojolicious::Lite;
use Config::Any;
use Maximus::Schema;
use Mojo::Util 'md5_sum';

# Helper for loading the config file
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

# Helper for setting up the database connection
helper 'db' => sub {
    return Maximus::Schema->connect(
        shift->cfg->{'Model::DB'}->{connect_info});
};

# Serve module file from database or remote_location
# Route matches that of the Catalyst application
# TODO: Optimize by using DBI directly instead of DBIx::Class?
get '/module/download/:scope/:module/:version' => sub {
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
