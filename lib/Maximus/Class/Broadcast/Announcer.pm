package Maximus::Class::Broadcast::Announcer;
use Moose;
use Maximus::Class::Broadcast::Message;
use Log::Log4perl;
use namespace::autoclean;

has 'listeners' => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRef[Object]',
    default => sub { [] },
    handles => {
        getListeners   => 'elements',
        addListener    => 'push',
        countListeners => 'count',
    },
);

has 'logger' => (
    isa     => 'Log::Log4perl::Logger',
    is      => 'ro',
    default => sub { Log::Log4perl->get_logger() },
    lazy    => 1,
);

sub say {
    my ($self, $msg) = @_;

    my $ref = ref(\$msg);

    if ($ref eq 'SCALAR') {
        $msg = Maximus::Class::Broadcast::Message->new(text => $msg);
    }
    elsif ($ref eq 'HASH') {
        $msg = Maximus::Class::Broadcast::Message->new(%{$msg});
    }
    elsif (ref($msg) ne 'Maximus::Class::Broadcast::Message') {
        $msg = Maximus::Class::Broadcast::Message->new($msg);
    }

    foreach my $listener ($self->getListeners) {
        eval { $listener->say($msg); };
        $self->logger->warn($@) if $@ && $self->logger;
    }
    return $msg;
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Class::Broadcast::Announcer - Announcer for updates

=head1 SYNOPSIS

	use Maximus::Class::Broadcast::Announcer;
	my $ann = Maximus::Class::Broadcast::Announcer->new;
	my $listener = Maximus::Class::Announcer::Driver::Null->new;
	$listener->init();
	$ann->addListener($listener);
	my $count = $ann->countListeners;
	my @listeners = $ann->getListeners;
	my $msg = Maximus::Class::Broadcast::Message->new(text => 'Hello world!');
	$ann->say($msg);
	$ann->say('Hello world!');
	$ann->say(text => 'Hello world!');

=head1 DESCRIPTION

Provides a generic interface to make announcements about updates, such as newly
upload modules and such.

=head1 ATTRIBUTES

=head2 logger

A L<Log::Log4perl::Logger> object

=head1 METHODS

=head2 getListeners

Retrieve array with all listeners

=head2 addListener

Add listener

=head2 countListeners

Return listener count


=head2 say(string $msg)
=head2 say(text => $msg)
=head2 say(L<Maximus::Class::Broadcast::Message>)

Announce a message to all listeners, returns the message.


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
