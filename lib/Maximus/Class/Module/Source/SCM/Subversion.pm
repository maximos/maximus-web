package Maximus::Class::Module::Source::SCM::Subversion;
use Moose;
use Carp qw/confess/;
use Path::Class;
use namespace::autoclean;

with 'Maximus::Role::Module::Source';
with 'Maximus::Role::Module::Source::SCM';

has 'repository' => (is => 'ro', isa => 'Str', required => 1);

has 'local_repository' => (is => 'ro', isa => 'Str', required => 1);

has 'trunk' => (is => 'rw', isa => 'Str', default => 'trunk');

has 'tags' => (is => 'rw', isa => 'Str', default => 'tags');

has 'tags_filter' => (is => 'rw', isa => 'Str', default => '');

sub init_repo {
    my $self = shift;
    confess 'version is required' unless $self->version;

    my $cmd;

    # Checkout or update repository local persistent copy
    if ($self->version eq 'dev') {
        my $localrepo =
          Path::Class::Dir->new($self->local_repository, '.svn');
        my $action = (-d $localrepo->absolute) ? 'update' : 'checkout';
        my $url = join('/', ($self->repository, $self->trunk));

        if ($action eq 'checkout') {
            $cmd = join(
                ' ',
                (   'svn --trust-server-cert --non-interactive',
                    $action, $url, $self->local_repository,
                )
            );
        }
        elsif ($action eq 'update') {
            $cmd = join(
                ' ',
                (   'svn --trust-server-cert --non-interactive', $action,
                    $self->local_repository,
                )
            );
        }

        # Update or checkout repository
        `$cmd`;

        # Fast export local repository to tmpDir for further processing
        $cmd = join(
            ' ',
            (   'svn --trust-server-cert --non-interactive export --force',
                $self->local_repository, $self->tmpDir
            )
        );
        `$cmd`;
    }

    # Export to temp. directory
    else {
        my %versions = $self->get_versions;
        confess('Specified version doesn\'t exist in repository')
          unless exists($versions{$self->version});

        my $url = join('/',
            ($self->repository, $self->tags, $versions{$self->version}));

        my $cmd = join(
            ' ',
            (   'svn --trust-server-cert --non-interactive export --force',
                $url, $self->tmpDir
            )
        );

        `$cmd`;
    }
}

sub prepare {
    my ($self, $mod) = @_;
    $self->init_repo;
    $self->findAndMoveRootDir($mod);
    $self->validate($mod);
}

sub get_versions {
    my ($self) = @_;
    my %tags;

    if (length($self->tags) > 0) {
        my $cmd = 'svn --trust-server-cert --non-interactive list '
          . join('/', ($self->repository, $self->tags));
        my @ls = `$cmd`;

        if (length($self->tags_filter) > 0) {
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

sub get_latest_revision {
    my ($self) = @_;
    my $cmd = 'svn --trust-server-cert --non-interactive info '
      . join('/', ($self->repository, $self->trunk));
    my @info     = `$cmd`;
    my @revision = map {
        $_ =~ s/[^\d]+//g;
        $_ = int($_);
    } grep { $_ =~ /^Revision: \d*/ } @info;
    return $revision[0];
}

around 'auto_discover' => sub {
    my ($orig, $self) = @_;
    my $old_version = $self->version;
    $self->version('dev');
    $self->init_repo;
    $self->version($old_version);
    return $self->$orig(@_, $self->tmpDir);
};

sub apply_scm_settings {
    my ($self, $scm_settings) = @_;

    if (defined $scm_settings->{svn_trunk}) {
        $self->trunk($scm_settings->{svn_trunk});
    }
    if (defined $scm_settings->{svn_tags}) {
        $self->tags($scm_settings->{svn_tags});
    }
    if (defined $scm_settings->{svn_tags_filter}) {
        $self->tags_filter($scm_settings->{svn_tags_filter});
    }
}

__PACKAGE__->meta->make_immutable;

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

Location of remote Subversion repository. Must be publicly readable

=head2 local_repository

Location of the local copy of the Subversion repository

=head2 trunk

Path to trunk. If the repository hosts more modules then set it to the module
path, e.g. trunk/my.mod

=head2 tags

Path to tags. If the repository hosts more modules then set I<tags_filter> to
filter the listing.

=head2 tags_filter

If the repository hosts more modules then set this to filter the listing.
e.g.: C<^my\.mod-(.+)> if this module uses tags in the style of I<my.mod-0.01>
or I<my.mod-0.3.0>. You MUST add a capture so the version string can be fetched.

=head2 apply_scm_settings

Apply SCM specific settings

=head1 METHODS

=head2 init_repo

Initialize repository. Either clones or pulls to update

=head2 prepare

Fetch files for I<version> and sort them inside the temporary directory

=head2 get_versions

Returns all versions

=head2 get_latest_revision

Retrieve latest revision of trunk

=head2 auto_discover

Discover available modules from the repository

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
