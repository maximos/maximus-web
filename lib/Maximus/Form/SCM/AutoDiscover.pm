package Maximus::Form::SCM::AutoDiscover;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

=head1 NAME

Maximus::Form::SCM::Auto Discover - SCM Auto Discover form

=head1 DESCRIPTION

SCM Auto Discover form

=head1 Attributes

=head2 username

=cut

has_field 'software' => (
    type    => 'Select',
    label   => 'SCM Software',
    options => [
        {value => 'git', label => 'Git'},
        {value => 'svn', label => 'Subversion'},
    ],
    required         => 1,
    required_message => 'You must enter a SCM',
);

=head2 repo_url

=cut

has_field 'repo_url' => (
    type             => 'Text',
    label            => 'Repository URL',
    required         => 1,
    required_message => 'You must enter a repository URL',
);

=head2 modules

=cut

has_field 'modules' => (
    type          => 'Select',
    select_widget => 'select',
    multiple      => 1,
);

=head2 user

=cut

has 'user' => (
    is       => 'ro',
    isa      => 'Maximus::Schema::Result::User',
    required => 1,
);

=head1 METHODS

=head2 options_modules

=cut

sub options_modules {
    my $self = shift;
    return unless $self->user;

    my @selections;
    foreach my $modscope ($self->user->modscopes) {
        my @modules = $modscope->modules;
        if (@modules) {
            foreach my $module (@modules) {
                push @selections,
                  { value => $module->id,
                    label => sprintf('%s.%s', $modscope->name, $module->name),
                  };
            }
        }
    }
    return @selections;
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
