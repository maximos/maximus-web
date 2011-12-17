package Maximus::Exceptions;

use Exception::Class (
    'Maximus::Exception'         => {fields => qw/ user_msg /,},
    'Maximus::Exception::Module' => {isa    => 'Maximus::Exception',},
    'Maximus::Exception::Module::Archive' =>
      {isa => 'Maximus::Exception::Module',},
    'Maximus::Exception::Module::Source' =>
      {isa => 'Maximus::Exception::Module',},
);

=head1 NAME

Maximus::Exceptions - All Exceptions in Maximus

=head1 SYNOPSIS

    use Maximus::Exceptions;

=head1 DESCRIPTION

All exceptions are contained in this file.

=head1 EXCEPTIONS

=head2 Maximus::Exception

General exception

=head2 Maximus::Exception::Module

A exception used when handling modules

=head2 Maximus::Exception::Module::Archive

A exception used when handling module archives

=head2 Maximus::Exception::Module::Source

A exception used when processing module sources

=head1 SEE ALSO

L<Exception::Class>

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
