package Maximus::Controller::Module;
use Data::SearchEngine::Query;
use Digest::MD5 qw(md5_hex);
use IO::File;
use JSON::Any;
use Maximus::Form::Module::Search;
use Maximus::Task::Module::Upload;
use Maximus::SearchEngine::Module;
use version;
use XML::Simple;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    $c->response->redirect($c->uri_for('modscopes'));
}

sub search : Local {
    my ($self, $c, $query_str, $page) = @_;

    $page ||= 1;

    my $form   = Maximus::Form::Module::Search->new;
    my $params = $c->req->parameters;
    $params->{query} ||= $query_str;
    $form->process($params)
      if defined($params->{query}) && length($params->{query}) > 0;
    $c->stash(form => $form);

    $c->response->redirect($c->uri_for('search', $params->{query}, $page))
      && $c->detach
      if $c->request->method eq 'POST'
          && $form->validated;

    if (defined($params->{query}) && length($params->{query}) > 0) {
        my $se =
          Maximus::SearchEngine::Module->new(
            schema => $c->model('DB')->schema);
        my $query = Data::SearchEngine::Query->new(
            count => 15,
            page  => int($page),
            query => $params->{query},
        );
        $c->stash->{search_results} = $se->search($query);
    }
}

sub modscopes : Local {
    my ($self, $c) = @_;
    $c->forward('search');
    my @modscopes =
      $c->model('DB::Modscope')->search(undef, {order_by => 'name',});
    $c->stash->{modscopes} = \@modscopes;
}

sub modscope : Path : Args(1) {
    my ($self, $c, $scope) = @_;
    my $modscope = $c->model('DB::Modscope')->find({name => $scope});
    $c->detach('/default') unless $modscope;

    $c->stash->{modscope} = $modscope;
    my @modules =
      $modscope->search_related('modules', undef, {order_by => 'name'});
    $c->stash->{modules} = \@modules;
}

sub module : Path : Args(2) {
    my ($self, $c, $scope, $modname) = @_;

    my $rs = $c->model('DB::Module')->search(
        {   'modscope.name' => $scope,
            'me.name'       => $modname,
        },
        {   join     => 'modscope',
            prefetch => 'modscope',
        }
    );

    $c->detach('/default') unless $rs->count == 1;

    my $module = $rs->first;
    my %versions;
    my @module_versions = $module->search_related(
        'module_versions',
        undef,
        {   columns  => [qw/id version/],
            prefetch => 'module_dependencies',
        }
    );

    foreach my $version (@module_versions) {
        my @deps;
        foreach my $dependantVersion ($version->module_dependencies) {
            push @deps,
              sprintf('%s.%s',
                $dependantVersion->modscope, $dependantVersion->modname);
        }

        my $v = $version->version;
        $versions{$v} = {
            deps => \@deps,
            url => $c->uri_for('download', ($scope, $modname, $v))->as_string,
        };
    }

    @{$c->stash->{sortedVersions}} = sort {
        local ($a, $b) = ($a, $b);
        $a = 999 if $a eq 'dev';
        $b = 999 if $b eq 'dev';
        $a =~ s/[^\d\.]//g;
        $b =~ s/[^\d\.]//g;
        version->declare($b) <=> version->declare($a);
    } keys %versions;

    $c->stash->{module}   = $module;
    $c->stash->{versions} = \%versions;
    $c->stash->{authors} =
      [map { $_->username } $module->modscope->get_authors];
}

sub sources : Chained('/') : PathPart('module/sources') : CaptureArgs(0) {
    my ($self, $c) = @_;
    my $sources = {};

    unless (($sources = $c->cache->get('sources_list'))
        && ($c->stash->{sortedVersions} = $c->cache->get('sources_list_sv')))
    {
        my @modscope_rs = $c->model('DB::Modscope')->search(
            undef,
            {   order_by => {-desc => 'me.name',},
                prefetch => 'modules',
            }
        );

        foreach my $modscope (@modscope_rs) {
            my $scope = $modscope->name;

            foreach my $module ($modscope->modules) {
                my $modname = $module->name;
                $sources->{$scope}->{$modname}->{desc} = $module->desc;

              # Don't fetch `archive` because it contains the raw archive data
              # and is expected to be a big resultset
                my @module_versions = $module->search_related(
                    'module_versions',
                    undef,
                    {   columns  => [qw/id module_id version/],
                        prefetch => 'module_dependencies',
                    }
                );

                foreach my $version (@module_versions) {
                    my @deps;
                    foreach
                      my $dependantVersion ($version->module_dependencies)
                    {
                        push @deps,
                          sprintf('%s.%s',
                            $dependantVersion->modscope,
                            $dependantVersion->modname);
                    }

                    my $v = $version->version;
                    $sources->{$scope}->{$modname}->{versions}->{$v} = {
                        deps => \@deps,
                        url => $c->uri_for('download', ($scope, $modname, $v))
                          ->as_string,
                    };
                }

                @{$c->stash->{sortedVersions}->{$scope}->{$modname}} = sort {
                    local ($a, $b) = ($a, $b);
                    $a = 999
                      if $a eq 'dev';
                    $b = 999 if $b eq 'dev';
                    $a =~ s/[^\d\.]//g;
                    $b =~ s/[^\d\.]//g;
                    version->declare($a) <=> version->declare($b);
                } keys %{$sources->{$scope}->{$modname}->{versions}};
            }
        }

        $c->cache->set('sources_list',    $sources);
        $c->cache->set('sources_list_sv', $c->stash->{sortedVersions});
    }

    $c->stash->{sources} = $sources || {};
}

sub sources_json : Chained('sources') : PathPart('json') : Args(0) {
    my ($self, $c) = @_;

    $c->res->content_type('application/json');
    $c->res->body(JSON::Any->objToJson($c->stash->{sources}));
}

sub sources_xml : Chained('sources') : PathPart('xml') : Args(0) {
    my ($self, $c) = @_;

    $c->res->content_type('text/xml');
    $c->res->body(XMLout($c->stash->{sources}));
}

sub download : Local : Args(3) {
    my ($self, $c, $modscope, $module, $version) = @_;

    my @search = (
        {   'modscope.name'           => $modscope,
            'me.name'                 => $module,
            'module_versions.version' => $version,
        },
        {join => [qw /modscope module_versions/],}
    );

    my $rs  = $c->model('DB::Module')->search(@search);
    my $row = $rs->first;
    $c->detach('/error_404') unless $row;

    my $version_rs = $row->search_related(
        'module_versions',
        {version => $version},
        {columns => [qw/id remote_location/]}
    );
    my $version_row = $version_rs->first();
    $c->detach('/error_404') unless $version_row;
    $c->res->redirect($version_row->remote_location) and $c->detach
      if $version_row->remote_location;

    # Refetch so we can access the id and archive columns
    $version_row =
      $version_row->get_from_storage({columns => [qw/id archive/]});

  # Persistently store module. Which will be processed later by the job server
    $c->log->warn('Unable to queue Maximus::Task::Module::Upload')
      unless Maximus::Task::Module::Upload->new(queue => 1)
          ->run($version_row->id);

    my $fh = IO::File->new_tmpfile;
    $fh->print($version_row->archive) or die($!);
    $fh->seek(0, 0);

    my $filename = sprintf('%s-%s-%s.zip', $modscope, $module, $version);
    $c->res->header('Content-Disposition',
        qq[attachment; filename="$filename"]);
    $c->res->header('ETag',           md5_hex($version_row->archive));
    $c->res->header('Content-Length', length($version_row->archive));
    $c->res->content_type('application/x-zip');
    $c->res->body($fh);
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Controller::Module - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller for Modules;

=head1 METHODS

=head2 index

=head2 search

Search for modules.

=head2 modscopes

Display all modscopes

=head2 modscope

Display all modules for the given modscope

=head2 module

Display information about a module

=head2 sources

Retrieve sources file

=head2 sources_json

Sources file in JSON

=head2 sources_xml

Sources file in XML

=head2 download

Download archive based on modscope, module name and version

=head1 AUTHOR

Christiaan Kras

=head1 LICENSE

Copyright (c) 2010-2012 Christiaan Kras

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
