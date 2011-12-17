package Maximus::Class::Module::Source::SCM::Git;
use Moose;
use namespace::autoclean;

with 'Maximus::Role::Module::Source';
with 'Maximus::Role::Module::Source::SCM';

use Cwd;
use File::Copy::Recursive qw(dircopy);
use Path::Class;

our $GIT =
  $^O eq 'MSWin32'
  ? '"C:\Program Files\Git\cmd\git.cmd"'
  : '/usr/bin/env git';

has 'repository' => (is => 'ro', isa => 'Str', required => 1);

has 'local_repository' => (is => 'ro', isa => 'Str', required => 1);

has 'tags_filter' => (is => 'rw', isa => 'Str', default => '');

sub init_repo {
    my $self = shift;
    use autodie;

    my @cmd;
    my $cwd = getcwd;
    chdir $self->local_repository;

    my $localrepo = Path::Class::Dir->new($self->local_repository, '.git');
    unless (-d $localrepo->absolute) {
        push @cmd,
          sprintf('%s clone --recursive %s %s',
            $GIT, $self->repository, $self->local_repository);
    }
    else {
        push @cmd, sprintf('%s pull origin master', $GIT);
        push @cmd, sprintf('git submodule update',  $GIT);
    }
    system $_ for @cmd;
    chdir $cwd;
}

sub prepare {
    my ($self, $mod) = @_;
    use autodie;
    confess 'version is required' unless $self->version;

    $self->init_repo;

    my $cmd;
    my $cwd = getcwd;
    chdir $self->local_repository;

    my $hash;
    if ($self->version eq 'dev') {
        $hash = 'HEAD';
    }
    else {
        my %versions = $self->get_versions;
        confess('Specified version '
              . $self->version
              . ' doesn\'t exist in repository')
          unless exists($versions{$self->version});
        $hash = $versions{$self->version};
    }

    my $branch = 'work-' . $self->version;
    $cmd = sprintf('%s checkout -f -b %s %s', $GIT, $branch, $hash);
    system $cmd;

    my $path = Path::Class::Dir->new($self->local_repository);
    dircopy($path->absolute->stringify, $self->tmpDir) or confess($!);

    my @cleanup = (
        sprintf('%s checkout master', $GIT),
        sprintf('%s branch -d %s', $GIT, $branch),
        sprintf('%s gc',           $GIT),
    );
    foreach (@cleanup) {
        system $_;
    }

    chdir $cwd;

    $self->findAndMoveRootDir($mod);
    $self->validate($mod);
}

sub get_versions {
    my ($self) = @_;
    my %tags;

    my $cmd = sprintf('%s ls-remote --tags %s', $GIT, $self->repository);
    my @tags = `$cmd`;

    foreach (@tags) {
        my ($sha1, $noise, $version) = unpack('A40 A11 A*', $_);
        $tags{$version} = $sha1;
    }

    %tags = map { $_ => $tags{$_} } grep { $_ !~ /\^\{\}$/ } keys %tags;

    if (length($self->tags_filter) > 0) {
        my $regex = $self->tags_filter;
        %tags = map {
            my $k = $_;
            $k =~ s/$regex$/$1/;
            $k => $tags{$_};
        } grep {/$regex/} keys %tags;
    }

    return %tags;
}

sub get_latest_revision {
    my ($self) = @_;
    my %heads;
    my $cmd = sprintf('%s ls-remote --heads %s', $GIT, $self->repository);
    my @heads = `$cmd`;
    foreach (@heads) {
        my ($sha1, $noise, $ref) = unpack('A40 A A*', $_);
        $heads{$ref} = $sha1;
    }
    return $heads{'refs/heads/master'};
}

around 'auto_discover' => sub {
    my ($orig, $self) = @_;
    $self->init_repo;
    return $self->$orig(@_, $self->local_repository);
};

sub apply_scm_settings {
    my ($self, $scm_settings) = @_;

    if (defined $scm_settings->{git_tags_filter}) {
        $self->tags_filter($scm_settings->{git_tags_filter});
    }
}

__PACKAGE__->meta->make_immutable;

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

=head2 local_repository

Location of the local copy of the Git repository

=head2 tags_filter

If the repository hosts more modules then set this to filter the listing.
e.g.: C<^v(.+)> if this module uses tags in the style of I<v0.01> or I<v0.3.0>.
You MUST add a capture so the version string can be fetched.

=head1 METHODS

=head2 init_repo

Initialize repository. Either clones or pulls to update

=head2 prepare

Fetch files for I<version> and store them inside the temporary directory

=head2 get_versions

Returns all versions

=head2 get_latest_revision

Retrieve latest revision of master

=head2 auto_discover

Discover available modules from the repository

=head2 apply_scm_settings

Apply SCM specific settings

=head1 AUTHOR

Christiaan Kras

=head1 LICENSE

Copyright (c) 2010-2011 Christiaan Kras

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
