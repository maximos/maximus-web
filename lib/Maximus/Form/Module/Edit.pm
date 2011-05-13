package Maximus::Form::Module::Edit;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has_field 'scope' => (
    type     => 'Text',
    label    => 'Modscope',
);

has_field 'name' => (
    type     => 'Text',
    label    => 'Name',
);

has_field 'desc' => (
    type             => 'Text',
    label            => 'Description',
    required         => 1,
    required_message => 'You must enter a description',
);

has_field 'scm_id' => (
    type          => 'Select',
    select_widget => 'select',
    multiple      => 1,
    label         => 'SCM Configuration',
);

has_field 'git_tags_filter' => (
    type  => 'Text',
    label => 'Tags filter (regular expression, leave empty for default)',
);

has_field 'svn_trunk' => (
    type  => 'Text',
    label => 'Path to Trunk (leave empty for default)',
);

has_field 'svn_tags' => (
    type  => 'Text',
    label => 'Path to Tags (leave empty for default)',
);

has_field 'svn_tags_filter' => (
    type  => 'Text',
    label => 'Tags filter (regular expression, leave empty for default)',
);

has 'user' => (
    is       => 'ro',
    isa      => 'Maximus::Schema::Result::User',
    required => 1,
);

sub options_scm_id {
    my $self = shift;
    return unless $self->user;

    my @selections;
    foreach my $scm ($self->user->get_scms) {
        push @selections,
          { value => $scm->id,
            label => sprintf('%s: %s', $scm->software, $scm->repo_url),
          };
    }
    return @selections;
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Form::Module::Edit - Module upload form

=head1 DESCRIPTION

Edit module form

=head1 Attributes

=head2 scope

Module namespace

=head2 modname

Module name

=head2 desc

Module description

=head2 user

User object

=head2 git_tags_filter

=head2 svn_trunk

=head2 svn_tags

=head2 svn_tags_filter

=head1 Methods

=head2 options_scm_id

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
