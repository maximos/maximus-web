package Maximus::Class::Module::Source::SCM::Git;
use Moose;
use namespace::autoclean;

with 'Maximus::Role::Module::Source';
with 'Maximus::Role::Module::Source::SCM';

use Cwd;
use File::Copy::Recursive qw(dircopy);
use Path::Class;

our $GIT = $^O eq 'MSWin32' ? '"C:\Program Files\Git\cmd\git.cmd"' : '/usr/bin/env git';

=head1 NAME

Maximus::Class::Module::Source::SCM::Git - Handles module sources inside a Git
repository

=head1 SYNOPSIS

	use Maximus::Class::Module::Source::SCM::Git;
	my $source = Maximus::Class::Module::Source::SCM::Git->new;

=head1 DESCRIPTION

Git support for retrieving the modules sources.

=head1 ATTRIBUTES

=head2 repository

Location of remote Git repository. Must be publicly readable
=cut
has 'repository' => (is => 'ro', isa => 'Str', required => 1);

=head2 local_repository

Location of the local copy of the Git repository
=cut
has 'local_repository' => (is => 'ro', isa => 'Str', required => 1);

=head2 mod_path

Specific path to a module in a modscope hosted repository
=cut
has 'mod_path' => (is => 'ro', isa => 'Str', default => '');

=head2 tags_filter

If the repository hosts more modules then set this to filter the listing.
e.g.: C<^v(.+)> if this module uses tags in the style of I<v0.01> or I<v0.3.0>.
You MUST add a capture so the version string can be fetched.
=cut
has 'tags_filter' => (is => 'ro', isa => 'Str', default => '');

=head1 METHODS

=head2 prepare

Fetch files for I<version> and store them inside the temporary directory
=cut
sub prepare {
	my($self, $mod) = @_;
	confess 'version is required' unless $self->version;

	my $cmd;
	my $cwd = getcwd;
	chdir $self->local_repository;
	
	my $localrepo = Path::Class::Dir->new($self->local_repository, '.git');
	unless(-d $localrepo->absolute) {
		$cmd = sprintf('%s clone %s %s', $GIT, $self->repository, $self->local_repository);
	}
	else {
		$cmd = sprintf('%s pull origin master', $GIT);
	}
	`$cmd`;
	
	my $hash;
	if($self->version eq 'dev') {
		$hash = 'HEAD';
	}
	else {
		my %versions = $self->get_versions;
		confess('Specified version '.$self->version.' doesn\'t exist in repository')
		  unless exists($versions{$self->version});
		$hash = $versions{$self->version};
	}

	my $branch = 'work-'.$self->version;
	$cmd = sprintf('%s checkout -f -b %s %s', $GIT, $branch, $hash);
	`$cmd`;
	
	my $path = Path::Class::Dir->new($self->local_repository, $self->mod_path);
	dircopy($path->absolute->stringify, $self->tmpDir) or confess($!);
	
	my @cleanup = (
		sprintf('%s checkout master', $GIT),
		sprintf('%s branch -d %s', $GIT, $branch),
		sprintf('%s gc', $GIT),
	);
	foreach(@cleanup) {
		`$_`;
	}

	chdir $cwd;
	
	$self->findAndMoveRootDir($mod);
	$self->validate($mod);
}

=head2 get_versions

Returns all versions
=cut
sub get_versions {
	my($self) = @_;
	my %tags;
	
	my $cmd = sprintf('%s ls-remote --tags %s', $GIT, $self->repository);
	my @tags = `$cmd`;

	foreach(@tags) {
		my($sha1,$noise,$version) = unpack('A40 A11 A*', $_);
		$tags{$version} = $sha1;
	}
	
	%tags = map { $_ => $tags{$_} } grep { $_ !~ /\^\{\}$/ } keys %tags;
	
	if(length($self->tags_filter) > 0) {
		my $regex = $self->tags_filter;
		%tags = map { 
			my $k = $_;
			$k =~ s/$regex$/$1/;
			$k => $tags{$_};
		} grep {/$regex/} keys %tags;
	}

	return %tags;
}

=head2 get_latest_revision

Retrieve latest revision of master
=cut
sub get_latest_revision {
	my($self) = @_;
	my %heads;
	my $cmd = sprintf('%s ls-remote --heads %s', $GIT, $self->repository);
	my @heads = `$cmd`;
	foreach(@heads) {
		my($sha1,$noise,$ref) = unpack('A40 A A*', $_);
		$heads{$ref} = $sha1;
	}
	return $heads{'refs/heads/master'};
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

1;
