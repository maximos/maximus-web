package Maximus::Controller::Module;
use Digest::MD5 qw(md5_hex);
use IO::File;
use JSON::Any;
use version;
use XML::Simple;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Maximus::Controller::Module - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller for Modules;

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->redirect($c->uri_for('modscopes'));
}

=head2 modscopes

Display all modscopes
=cut
sub modscopes :Local {
	my($self, $c) = @_;
	my @modscopes = $c->model('DB::Modscope')->search(undef, {
		order_by => 'name',
	});
	$c->stash->{modscopes} = \@modscopes;
}

=head2 modscope

Display all modules for the given modscope
=cut
sub modscope :Path :Args(1) {
	my($self, $c, $scope) = @_;
	my $modscope = $c->model('DB::Modscope')->find({name => $scope});
	$c->detach('/default') unless $modscope;
	
	$c->stash->{modscope} = $modscope;
	my @modules = $modscope->search_related('modules', undef, {order_by => 'name'});
	$c->stash->{modules} = \@modules;
}

=head2 module

Display information about a module
=cut
sub module :Path :Args(2) {
	my($self, $c, $scope, $modname) = @_;

	my $rs = $c->model('DB::Module')->search(
		{
			'modscope.name' => $scope,
			'me.name' => $modname,
		},
		{
			join => 'modscope',
			prefetch => 'modscope',
		}
	);
	
	$c->detach('/default') unless $rs->count == 1;
	
	my $module = $rs->first;
	my %versions;
	my @module_versions = $module->search_related('module_versions', undef, {
		columns => [qw/id version/],
		prefetch => 'module_dependencies',
	});

	foreach my $version(@module_versions) {
		my @deps;
		foreach my $dependantVersion($version->module_dependencies) {
			push @deps, sprintf('%s.%s', $dependantVersion->modscope, $dependantVersion->modname);
		}
		
		my $v = $version->version;
		$versions{$v} = {
			deps => \@deps,
			url => $c->uri_for('download', ($scope, $modname, $v))->as_string,
		};
	}
	
	@{$c->stash->{sortedVersions}} = sort {
		version->declare($b) <=> version->declare($a)
	} keys %versions;

	$c->stash->{module} = $module;
	$c->stash->{versions} = \%versions;
}

=head2 sources

Retrieve sources file
=cut
sub sources :Chained('/') :PathPart('module/sources') :CaptureArgs(0) {
	my($self, $c) = @_;
	my $sources = {};

	unless(($sources = $c->cache->get('sources_list')) && ($c->stash->{sortedVersions} = $c->cache->get('sources_list_sv'))) {
		my @modscope_rs = $c->model('DB::Modscope')->search(undef, {
			order_by => {
				-desc => 'me.name',
			},
			prefetch => 'modules',
		});
	
		foreach my $modscope(@modscope_rs) {
			my $scope = $modscope->name;
			
			foreach my $module($modscope->modules) {
				my $modname = $module->name;
				$sources->{$scope}->{$modname}->{desc} = $module->desc;
				
				# Don't fetch `archive` because it contains the raw archive data
				# and is expected to be a big resultset
				my @module_versions = $module->search_related('module_versions', undef, {
					columns => [qw/id module_id version/],
					prefetch => 'module_dependencies',
				});
	
				foreach my $version(@module_versions) {
					my @deps;
					foreach my $dependantVersion($version->module_dependencies) {
						push @deps, sprintf('%s.%s', $dependantVersion->modscope, $dependantVersion->modname);
					}
					
					my $v = $version->version;
					$sources->{$scope}->{$modname}->{versions}->{$v} = {
						deps => \@deps,
						url => $c->uri_for('download', ($scope, $modname, $v))->as_string,
					};
				}
				
				@{$c->stash->{sortedVersions}->{$scope}->{$modname}} = sort {
					version->declare($a) <=> version->declare($b)
				} keys %{$sources->{$scope}->{$modname}->{versions}};
			}
		}
		
		$c->cache->set('sources_list', $sources);
		$c->cache->set('sources_list_sv', $c->stash->{sortedVersions});
	}

	$c->stash->{sources} = $sources || {};
}

=head2 /module/sources/json

Sources file in JSON
=cut
sub sources_json :Chained('sources') :PathPart('json') :Args(0) {
	my($self, $c) = @_;
	
	$c->res->content_type('application/json');
	$c->res->body(
		JSON::Any->objToJson($c->stash->{sources})
	);
}

=head2 /module/sources/xml

Sources file in XML
=cut
sub sources_xml :Chained('sources') :PathPart('xml') :Args(0) {
	my($self, $c) = @_;
	
	$c->res->content_type('text/xml');
	$c->res->body(
		XMLout($c->stash->{sources})
	);
}

=head2 download

Download archive based on modscope, module name and version
=cut
sub download :Local :Args(3) {
	my($self, $c, $modscope, $module, $version) = @_;
	
	my @search = (
		{
			'modscope.name' => $modscope,
			'me.name' => $module,
			'module_versions.version' => $version,
		},
		{
			join => [qw /modscope module_versions/ ],
			'+columns' => ['module_versions.remote_location'],
		}
	);
	
	my $rs = $c->model('DB::Module')->search($search[0], $search[1]);
	
	my $row = $rs->first;
	$c->detach('/default') unless $row;

	my $location = $row->get_column('remote_location');
	$c->res->redirect($location) and $c->detach if $location;

	# Refetch row to retrieve archive data if no remote_location exists
	$search[1]->{'+columns'} = ['module_versions.archive'];
	$row = $c->model('DB::Module')->search($search[0], $search[1])->first;

	my $fh = IO::File->new_tmpfile;
	$fh->print($row->get_column('archive')) or die($!);
	$fh->seek(0,0);

	my $filename = sprintf('%s-%s-%s.zip', $modscope, $module, $version);
	$c->res->header('Content-Disposition', qq[attachment; filename="$filename"]);
	$c->res->header('ETag', md5_hex($row->get_column('archive')));
	$c->res->header('Content-Length', length($row->get_column('archive')));
	$c->res->content_type('application/x-zip');
	$c->res->body($fh);
}

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

__PACKAGE__->meta->make_immutable;

