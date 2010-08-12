package Maximus::Script::Worker;
use Moose;
use Config::Any;
use Gearman::Worker;
use Storable qw(thaw);
use YAML;
use namespace::autoclean;
use 5.10.0;

with 'Catalyst::ScriptRole';

=head1 NAME

Maximus::Script::Worker - Maximus Gearman worker

=head1 SYNOPSIS

	maximus_worker.pl [options]

=head1 DESCRIPTION

Worker script that waits for Gearman to supply a task to it.

=head1 ATTRIBUTES

=head2 cfg

Contains a HashRef with the configuration in maximus.conf
=cut
has 'cfg' => (
	is => 'ro',
	isa => 'HashRef',
	lazy => 1,
	default => sub {
		Config::Any->load_files({
			files => ['maximus.conf'],
			use_ext => 1,
			flatten_to_hash => 1,
		})->{'maximus.conf'};
	},
);

=head2 verbose

Verbose mode
=cut
has 'verbose' => (
    traits        => [qw(Getopt)],
	cmd_aliases   => 'v',
    isa           => 'Bool',
    is            => 'ro',
    documentation => 'Verbose mode',
    default       => sub { 0 },
);

=head1 METHODS

=head2 run

=cut
sub run {
	my $self = shift;
	$self->_run_application;
}

=head2 _run_application

=cut
sub _run_application {
    my $self = shift;
	
	my $cfg = $self->cfg;
	my %opts = (
		job_servers => [ $cfg->{Gearman}->{job_servers} ],
		prefix => $cfg->{Gearman}->{prefix} // undef,
	);
	
	my $worker = Gearman::Worker->new( %opts );
	
	# Flush output-buffer
	$| = 1;

	my @modules = qw(
		Maximus::Task::Module::Upload
		Maximus::Task::SCM::Update
		Maximus::Task::SCM::AutoDiscover
	);

	foreach my $module(@modules) {
		$worker->register_function($module, sub {
			Class::MOP::load_class($module);
			my @args = thaw($_[0]->arg);
			printf('Task %s with arguments: %s', $module, Dump(@args)) if($self->verbose);
			
			my $task = $module->new;
			warn 'Failed to execute task' unless $task->run(@args);
			printf('Response contains: %s', Dump($task->response)) if($self->verbose);
		});
	}

	$worker->work while 1;
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
