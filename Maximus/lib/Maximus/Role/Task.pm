package Maximus::Role::Task;
use Moose::Role;
use Config::Any;
use Gearman::Client;
use Maximus::Schema;
use Storable qw(freeze);
use 5.10.0;

has 'cfg' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub {
        Config::Any->load_files(
            {   files           => ['maximus.conf'],
                use_ext         => 1,
                flatten_to_hash => 1,
            }
        )->{'maximus.conf'};
    },
);

has 'gearman' => (
    is      => 'ro',
    isa     => 'Gearman::Client',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $cfg  = $self->cfg;
        my %opts = (
            job_servers => [$cfg->{Gearman}->{job_servers}],
            prefix      => $cfg->{Gearman}->{prefix} // undef,
        );
        Gearman::Client->new(%opts);
    },
);

has 'queue' => (
    is  => 'ro',
    isa => 'Bool',
);

has 'schema' => (
    is      => 'ro',
    isa     => 'DBIx::Class::Schema',
    lazy    => 1,
    default => sub {
        my $self = shift;
        Maximus::Schema->connect($self->cfg->{'Model::DB'}->{connect_info});
    },
);

has 'response' => (
    is  => 'rw',
    isa => 'Any',
);

requires 'run';

around 'run' => sub {
    my ($orig, $self, @params) = @_;
    if ($self->queue) {
        return $self->gearman->dispatch_background(
            ref($self) => freeze(\@params));
    }
    else {
        return $self->$orig(@params);
    }
};

=head1 NAME

Maximus::Role::Task - Interface for tasks

=head1 SYNOPSIS

	package Maximus::Task::Foo;
	use Moose;

	with 'Maximus::Role::Task';

=head1 DESCRIPTION

This is the interface for all tasks

=head1 ATTRIBUTES

=head2 cfg

Contains a HashRef with the configuration in maximus.conf

=head2 gearman

Gearman client

=head2 queue

Send task and subtasks to the queue server

=head2 schema

DBIx::Class schema

=head2 response

Field to store output it

=head1 METHODS

=head2 run

Run the task. It should return true if successfull. If I<queue> has been set the
task will be dispatched to the queue server when invoked. When sent to the queue
server it'll return the job server handle.

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
