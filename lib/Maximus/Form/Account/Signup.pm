package Maximus::Form::Account::Signup;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

with 'Maximus::Role::Form::Account::Username';

with 'Maximus::Role::Form::Account::Email';

with 'Maximus::Role::Form::Account::ConfirmPassword';

with 'Maximus::Role::Form::Account::Password';

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Form::Account::Signup - Account Sign-Up form

=head1 DESCRIPTION

Sign-up form

=head1 Attributes

=head2 username

=head2 email

=head2 password

=head2 confirm_password

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
