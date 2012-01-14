package Maximus::Role::Form::Account::Username;
use HTML::FormHandler::Moose::Role;

has_field 'username' => (
    type             => '+Maximus::FormField::AlNum',
    label            => 'Username',
    required         => 1,
    required_message => 'You must enter a username',
    minlength        => 3,
    maxlength        => 25,
    css_class        => 'required validate-alphanum minLength:3 maxLength:25',
);

no HTML::FormHandler::Moose::Role;

=head1 NAME

Maximus::Role::Form::Account::Username - Username field

=head1 DESCRIPTION

This module provides a default Username field for a L<HTML::FormHandler>
account form.

=head1 AUTHOR

Christiaan Kras

=head1 LICENSE

Copyright (c) 2010-2012 Christiaan Kras

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
