package Maximus::Form::Account::Edit;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

=head1 NAME

Maximus::Form::Account::Signup - Account Edit form

=head1 DESCRIPTION

Account edit form

=head1 Attributes

=head2 email

=cut

has_field 'email' => (
    type             => 'Email',
    label            => 'E-Mail',
    required         => 1,
    required_message => 'You must enter a e-mail address',
);

=head2 password

=cut

has_field 'password' => (
    type             => 'Password',
    label            => 'Password',
    required         => 1,
    required_message => 'You must enter a password',
);

=head2 confirm_password

=cut

has_field 'confirm_password' => (
    type             => 'PasswordConf',
    label            => 'Confirm password',
    required         => 1,
    required_message => 'You must confirm your password',
);

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
