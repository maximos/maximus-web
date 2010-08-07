package Maximus::Class::Module::Source::SCM::Subversion;
use Moose;
use Carp qw/confess/;
use namespace::autoclean;

with 'Maximus::Role::Module::Source';
with 'Maximus::Role::Module::Source::SCM';

=head1 NAME

Maximus::Class::Module::Source::SCM::Subversion - Handles module sources inside
a Subversion repository

=head1 SYNOPSIS

	use Maximus::Class::Module::Source::SCM::Subversion;
	my $source = Maximus::Class::Module::Source::SCM::Subversion->new;

=head1 DESCRIPTION

Subversion support for retrieving the modules sources.

=head1 ATTRIBUTES

=head2 repository

Location of remote Git repository. Must be publicly readable
=cut
has 'repository' => (is => 'ro', isa => 'Str', required => 1);

=head2 trunk

Path to trunk. If the repository hosts more modules then set it to the module
path, e.g. trunk/my.mod
=cut
has 'trunk' => (is => 'rw', isa => 'Str', default => 'trunk');

=head2 tags

Path to tags. If the repository hosts more modules then set I<tags_filter> to
filter the listing.
=cut
has 'tags' => (is => 'rw', isa => 'Str', default => 'tags');

=head2 tags_filter

If the repository hosts more modules then set this to filter the listing.
e.g.: C<^my\.mod-(.+)> if this module uses tags in the style of I<my.mod-0.01>
or I<my.mod-0.3.0>. You MUST add a capture so the version string can be fetched.
=cut
has 'tags_filter' => (is => 'rw', isa => 'Str', default => '');

=head1 METHODS

=head2 init_repo

Initialize repository. Either clones or pulls to update
=cut
sub init_repo {
	my $self = shift;
	confess 'version is required' unless $self->version;
	
	my $url;
	if($self->version eq 'dev') {
		$url = join('/', ($self->repository, $self->trunk));
	}
	else {
		my %versions = $self->get_versions;
		confess('Specified version doesn\'t exist in repository')
		  unless exists($versions{$self->version});
		
		$url = join('/', (
			$self->repository,
			$self->tags,
			$versions{$self->version})
		);
	}
	
	my $cmd = join(' ', (
		'svn export --force',
		$url,
		$self->tmpDir)
	);
	`$cmd`;
}

=head2 prepare

Fetch files for I<version> and sort them inside the temporary directory
=cut
sub prepare {
	my($self, $mod) = @_;
	$self->init_repo;	
	$self->findAndMoveRootDir($mod);
	$self->validate($mod);
}

=head2 get_versions

Returns all versions
=cut
sub get_versions {
	my($self) = @_;
	my %tags;
	
	if(length($self->tags) > 0) {
		my $cmd = 'svn list ' . join('/', ($self->repository, $self->tags));
		my @ls = `$cmd`;
		
		if(length($self->tags_filter) > 0) {
			my $regex = $self->tags_filter;
			%tags = map { 
				chomp;
				my $k = $_;
				$k =~ s/$regex\/$/$1/;
				$k => $_
			} grep {/$regex/} @ls;
		}
	}

	return %tags;
}

=head2 get_latest_revision

Retrieve latest revision of trunk
=cut
sub get_latest_revision {
	my($self) = @_;
	my $cmd = 'svn info ' . join('/', ($self->repository, $self->trunk));
	my @info = `$cmd`;
	my @revision = map {
		$_ =~ s/[^\d]+//g;
		$_ = int($_);
	} grep { $_ =~ /^Revision: \d*/ } @info;
	return $revision[0];
}

=head2 auto_discover

Discover available modules from the repository
=cut
around 'auto_discover' => sub {
	my($orig, $self) = @_;
	my $old_version = $self->version;
	$self->version('dev');
	$self->init_repo;
	$self->version( $old_version );
	return $self->$orig(@_, $self->tmpDir);
};

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

1;
