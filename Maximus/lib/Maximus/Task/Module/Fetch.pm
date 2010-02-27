package Maximus::Task::Module::Fetch;
use Moose;

with 'Maximus::Role::Task';

=head1 NAME

Maximus::Task::Module::Fetch - Module source fetching task

=head1 SYNOPSIS

	use Maximus::Task::Module::Fetch;
	my $task = Maximus::Task::Module::Fetch->new;
	$task->init(modid => 'foo.bar');
	$task->run;

=head1 DESCRIPTION

Fetch sources for a specified module

=head1 METHODS

=head2 init

Initialize module fetch task

=cut
sub init {
	my $self = shift;
	0;
}

=head2 run

Run task

=cut
sub run {
	my $self = shift;
	0;
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


1;
