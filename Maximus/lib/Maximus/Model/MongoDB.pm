package Maximus::Model::MongoDB;

use strict;
use MongoDB;
use Moose;

extends 'Catalyst::Component';

__PACKAGE__->config(
    server => {
		host => '127.0.0.1',
		port => '27017',
	},
	database => 'maximus',
);

=head1 NAME

Maximus::Model::DB - MongoDB Model

=head1 SYNOPSIS

See L<Maximus>

=head1 DESCRIPTION

Model using L<MongoDB>

=head1 ATTRIBUTES

=head2 connection

A C<MongoDB::Connection>
=cut
has 'db' => (
	is => 'ro',
	isa => 'MongoDB::Database',
	builder => '_tmpDatabaseBuilder',
);

sub _tmpDatabaseBuilder {
	my $conn = MongoDB::Connection->new(
		host => __PACKAGE__->config->{server}->{host},
		port => __PACKAGE__->config->{server}->{port},
	);
	$conn->get_database(__PACKAGE__->config->{database});
}

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

1;
