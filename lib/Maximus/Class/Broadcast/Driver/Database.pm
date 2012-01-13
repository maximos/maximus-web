package Maximus::Class::Broadcast::Driver::Database;
use Moose;
use namespace::autoclean;
with 'Maximus::Role::Broadcast::Driver';

has 'model' => (
    isa      => 'DBIx::Class::ResultSet',
    is       => 'ro',
    required => 1,
);

sub say {
    my ($self, $msg) = @_;

    return $self->model->create(
        {   date         => $msg->date,
            message      => $msg->text,
            message_type => $msg->type,
            meta_data    => $msg->meta_data,
        }
    );
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Class::Broadcast::Driver::Database - Database driver

=head1 SYNOPSIS

    use Maximus::Class::Broadcast::Driver::Database;
    my $driver = Maximus::Class::Broadcast::Driver::Database->new;
    my $msg = Maximus::Class::Broadcast::Message->new(text => 'Hello world!');
    $driver->say($msg);

=head1 DESCRIPTION

This driver hooks up a L<DBIx::Class::Core> database table to the Broadcast
system of Maximus.

=head1 ATTRIBUTES

=head2 model

Contains the L<DBIx::Class::ResultSet> object in which the message will be
stored.

=head1 METHODS

=head2 say(L<Maximus::Class::Broadcast::Message> $msg)

Adds the message to the database.

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
