package Maximus::Class::Broadcast::Driver::Twitter;
use Moose;
use Net::Twitter;
use namespace::autoclean;
with 'Maximus::Role::Broadcast::Driver';

our $VERSION = '0.002';
$VERSION = eval { $VERSION };

=head1 NAME

Maximus::Class::Broadcast::Driver::Twitter - Tweet broadcasts

=head1 SYNOPSIS

	use Maximus::Class::Broadcast::Driver::Twitter;
	my $driver = Maximus::Class::Broadcast::Driver::Twitter->new(
		consumer_key => 'maximus',
		consumer_secret => 'secret',
        access_token => 'token',
        access_token_secret => 'secret',
	);
	
	# -or-
	
	use Net::Twitter;
	my $nt = Net::Twitter->new(
		traits => ['OAuth', 'API::REST'],
		consumer_key => 'maximus',
		consumer_secret => 'secret',
        access_token => 'token',
        access_token_secret => 'secret',
	);
	
	$driver = Maximus::Class::Broadcast::Driver::Twitter->new( nt => $nt);
	
	# Finally...
	my $msg = Maximus::Class::Broadcast::Message->new(text => 'Hello world!');
	$driver->say($msg);

=head1 DESCRIPTION

Broadcast messages to Twitter.

=head1 ATTRIBUTES

=head2 nt

Net::Twitter object
=cut

has 'nt' => (
    isa => 'Net::Twitter',
    is  => 'rw',
);

=head2 consumer_key

Read-Only, used for creating a Net::Twitter object
=cut

has 'consumer_key' => (
    isa => 'Str',
    is  => 'ro',
);

=head2 consumer_key

Read-Only, used for creating a Net::Twitter object
=cut

has 'consumer_secret' => (
    isa => 'Str',
    is  => 'ro',
);

=head2 access_token

Read-Only, used for creating a Net::Twitter object
=cut

has 'access_token' => (
    isa => 'Str',
    is  => 'ro',
);

=head2 access_token_secret

Read-Only, used for creating a Net::Twitter object
=cut

has 'access_token_secret' => (
    isa => 'Str',
    is  => 'ro',
);

=head1 METHODS

=head2 say(L<Maximus::Class::Broadcast::Message> $msg)

Tweet the message
=cut

sub say {
    my ( $self, $msg ) = @_;
    return $self->nt->update( $msg->text );
}

=head2 BUILD

Allow the constructor to create a Net::Twitter object when none is passed
=cut

sub BUILD {
    my $self = shift;
    if (   $self->consumer_key
        && $self->consumer_secret
        && $self->access_token
        && $self->access_token_secret
        && !$self->nt )
    {
        $self->nt(
            Net::Twitter->new(
                traits              => [ 'OAuth', 'API::REST' ],
                consumer_key        => $self->consumer_key,
                consumer_secret     => $self->consumer_secret,
                access_token        => $self->access_token,
                access_token_secret => $self->access_token_secret,
            )
        );
    }
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

__PACKAGE__->meta->make_immutable;
1;
