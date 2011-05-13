package Maximus::Form::Module::Upload;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

with 'Maximus::Role::Form::Module';

has '+enctype' => (default => 'multipart/form-data');

has_field 'file' => (
    type             => 'Upload',
    label            => 'Module Archive (.zip)',
    max_size         => 52428800,
    required         => 1,
    required_message => 'You need to supply an archive (.zip)',
    css_class        => 'required',
);

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Form::Module::Upload - Module upload form

=head1 DESCRIPTION

Upload form

=head1 Attributes

=head2 enctype

=head2 file

max_size is 52428800 = 50 megabytes

=head2 scope

Module namespace

=head2 modname

Module name

=head2 desc

Module description

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
