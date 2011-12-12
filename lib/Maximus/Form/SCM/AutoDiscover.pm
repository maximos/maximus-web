package Maximus::Form::SCM::AutoDiscover;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has_field 'modules' => (type => 'Repeatable');

has_field 'modules.modscope' => (
    type             => '+Maximus::FormField::ModPart',
    label            => 'Scope',
    required         => 1,
    required_message => 'You must enter a module scope',
    maxlength        => 45,
);

has_field 'modules.mod' => (
    type             => '+Maximus::FormField::ModPart',
    label            => 'Name',
    required         => 1,
    required_message => 'You must enter a module name',
    maxlength        => 45,
);

has_field 'modules.desc' => (
    type      => 'Text',
    label     => 'Description',
    maxlength => 255,
);

=head1 NAME

Maximus::Form::SCM::AutoDiscover - SCM Auto Discover form

=head1 DESCRIPTION

SCM Auto Discover form

=head1 Attributes

=head2 modules

A Repeatable field that contains the following fields:

=over 4

=item modscope

The module scope

=item modname

The module name

=item description

The module description

=back

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

__PACKAGE__->meta->make_immutable;
1;
