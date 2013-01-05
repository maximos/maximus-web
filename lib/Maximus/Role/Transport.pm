package Maximus::Role::Transport;
use Moose::Role;

has 'base_url' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

requires 'transport';

=head1 NAME

Maximus::Role::Transport - Interface for file transport

=head1 SYNOPSIS

    package Maximus::Class::Transport::Foo;
    use Moose;

    with 'Maximus::Role::Transport';

=head1 ATTRIBUTES

=head2 base_url

The base url of the storage

=head1 DESCRIPTION

This is the interface for transport drivers

=head1 METHODS

=head2 transport

Method that transports the given file. It should return the remote location
of the uploaded file when done.

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
