package Maximus::Controller::Module;
use IO::File;
use JSON::Any;
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
	
	foreach my $modscope($c->model('DB::Modscope')->all) {
		my $scope = $modscope->name;
		
		foreach my $module($modscope->modules) {
			my $modname = $module->name;
			$sources->{$scope}->{$modname}->{desc} = $module->desc;
			my $versions = $sources->{$scope}->{$modname}->{versions} = {};
			
			foreach my $version($module->module_versions) {
				my @deps;
				foreach my $dependantVersion($version->module_dependency_module_version_ids) {
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

=cut
sub download :Local :Args(3) {
	my($self, $c, $modscope, $module, $version) = @_;
	die('Sorry! No downloading yet!');
	#my $fh = IO::File->new_tmpfile;
	#$file->print($fh);
	
	#$c->res->header('Content-Disposition', qq[attachment; filename="$filename"]);
	#$c->res->header('ETag', $file->info->{md5});
	#$c->res->header('Content-Length', $file->info->{length});
	#$c->res->content_type('application/x-zip');
	#$c->res->body($fh);
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

