package Maximus::Class::Broadcast::Driver::Null;
use Moose;
use namespace::autoclean;
with 'Maximus::Role::Broadcast::Driver';

has 'counter' => (
    isa     => 'Int',
    is      => 'rw',
    default => 0,
);

sub say {
    my ($self, $msg) = @_;
    $self->counter($self->counter + 1);
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Class::Broadcast::Driver::Null - Test driver

=head1 SYNOPSIS

    use Maximus::Class::Broadcast::Driver::Null;
    my $driver = Maximus::Class::Broadcast::Driver::Null->new;
    my $msg = Maximus::Class::Broadcast::Message->new(text => 'Hello world!');
    $driver->say($msg);

=head1 DESCRIPTION

This driver is mainly for testing purposes. Any message passed to it will be
ignored. It does however count the number of times C<say> has been called.

=head1 ATTRIBUTES

=head2 counter

Contains the number of times C<say> has been called.

=head1 METHODS

=head2 say(L<Maximus::Class::Broadcast::Message> $msg)

Ignores the message but adds 1 to the C<counter> attribute.

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
