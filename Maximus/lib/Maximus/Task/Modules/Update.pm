package Maximus::Task::Modules::Update;
use Moose;
use Maximus::Task::Module::Update;

with 'Maximus::Role::Task';

=head1 NAME

Maximus::Task::Modules::Update - Update module database

=head1 SYNOPSIS

	use Maximus::Task::Modules::Update;
	$task->init;
	$task->run;

=head1 DESCRIPTION

Update module database.

=head1 METHODS

=head2 init

Initialize module update task
=cut
sub init { 1 }

=head2 run

Run task
TODO: Dispatch tasks, optionally, to Gearman...
=cut
sub run {
	my $self = shift;
	die('Updating module not yet supported!');
	
	1;
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
