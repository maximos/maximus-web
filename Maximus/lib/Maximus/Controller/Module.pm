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

    $c->response->redirect($c->uri_for('sources/list'));
}

=head2 list

Show HTML presentation of all modules
=cut
sub list :Chained('sources') :PathPart :Args(0) {	
}

=head2 sources

Retrieve sources file
=cut
sub sources :Chained('/') :PathPart('module/sources') :CaptureArgs(0) {
	my($self, $c) = @_;
	my $sources = {};
	
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
			my $versions = $sources->{$scope}->{$modname}->{versions} = {};
			
			# Don't fetch `archive` because it contains the raw archive data and
			# is expected to be a big resultset
			my @module_versions = $module->search_related('module_versions', undef, {
				'columns' => [qw/id module_id version remote_location/]
			});
			foreach my $version(@module_versions) {
				my @deps;
				foreach my $dependantVersion($version->module_dependency_dependant_module_versions) {
					my $version = $dependantVersion->dependant_module_version;
					my $module = $version->module;
					my $modscope = $module->modscope;
					my $dep = sprintf('%s.%s/%s', $modscope->name, $module->name, $version->version);
					push @deps, $dep;
				}
				
				my $v = $version->version;
				$versions->{$v} = {
					deps => \@deps,
					url => $c->uri_for('download', ($scope, $modname, $v))->as_string,
				};
			}
			
			$versions = sort { version->parse($a) <=> version->parse($b) } $versions;
		}
	}

	$c->stash->{sources} = $sources;
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
	
	my $rs = $c->model('DB::Module')->search(
		{
			'modscope.name' => $modscope,
			'me.name' => $module,
			'module_versions.version' => $version,
		},
		{
			join => [qw /modscope module_versions/ ],
			'+columns' => ['module_versions.archive'],
		}
	);
	
	my $row = $rs->first;
	$c->detach('/default') unless $row;

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

