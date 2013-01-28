package Maximus::Role::Task::SCM;
use Moose::Role;
use Digest::SHA qw(sha1_hex);
use File::Spec;
use File::Path qw(make_path);
use Path::Class;
use Maximus::Class::Module::Source::SCM::Git;
use Maximus::Class::Module::Source::SCM::Subversion;
use namespace::autoclean;

sub get_source {
    my ($self, $scm) = @_;
    my $local_repo = Path::Class::Dir->new(
        File::Spec->tmpdir(), sha1_hex(__PACKAGE__),
        'repositories',       sha1_hex($scm->repo_url)
    );
    make_path($local_repo->absolute->stringify);

    my $source;
    my $settings = $scm->settings;
    if ($scm->software eq 'git') {
        $source = Maximus::Class::Module::Source::SCM::Git->new(
            repository       => $scm->repo_url,
            local_repository => $local_repo->absolute->stringify,
        );

        # Default settings from SCM table
        if (exists $settings->{tags_filter}) {
            $source->tags_filter($settings->{tags_filter});
        }
    }
    elsif ($scm->software eq 'svn') {
        $source = Maximus::Class::Module::Source::SCM::Subversion->new(
            repository       => $scm->repo_url,
            local_repository => $local_repo->absolute->stringify,
        );

        # Default settings from SCM table
        if (exists $settings->{trunk}) {
            $source->trunk($settings->{trunk});
        }
        if (exists $settings->{tags}) {
            $source->tags($settings->{tags});
        }
        if (exists $settings->{tags_filter}) {
            $source->tags_filter($settings->{tags_filter});
        }
    }

    return $source;
}

=head1 NAME

Maximus::Role::Task::SCM - Role for SCM tasks

=head1 DESCRIPTION

Role for SCM tasks.

=head1 METHODS

=head2

Retrieve a L<Maximus::Class::Module::Source::SCM> type object

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
