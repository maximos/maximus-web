package Maximus::Role::Form::Module;
use HTML::FormHandler::Moose::Role;

has_field 'scope' => (
    type             => '+Maximus::FormField::ModPart',
    label            => 'Modscope',
    required         => 1,
    required_message => 'You must enter a modscope',
    maxlength        => 45,
    css_class        => 'required validate-alphanum minLength:1 maxLength:45',
);

has_field 'name' => (
    type             => '+Maximus::FormField::ModPart',
    label            => 'Name',
    required         => 1,
    required_message => 'You must enter a module name',
    maxlength        => 45,
    css_class        => 'required validate-alphanum minLength:1 maxLength:45',
);

has_field 'desc' => (
    type             => 'Text',
    label            => 'Description',
    required         => 1,
    required_message => 'You must enter a description',
    minLength        => 5,
    maxlength        => 255,
    css_class        => 'required minLength:5 maxLength:255',
);

no HTML::FormHandler::Moose::Role;

=head1 NAME

Maximus::Role::Form::Module - Default fields for Module form

=head1 DESCRIPTION

This module provides a set of default fields for a Module L<HTML::FormHandler>
form.

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
