package Maximus::Script::Task;
use Moose;
use Maximus;
use namespace::autoclean;

with 'Catalyst::ScriptRole';

=head1 NAME

Maximus::Script::Task - Maximus taskrunner

=head1 SYNOPSIS

	maximus_task.pl --task taskname

=head1 DESCRIPTION

Runs a task for Maximus

=head1 ATTRIBUTES

=head2

=cut
has task => (
    traits        => [qw(Getopt)],
    cmd_aliases   => 't',
    isa           => 'Str',
    is            => 'ro',
    documentation => 'Task to execute',
);

=head1 METHODS

=head2 run

=cut
sub run {
	my($self) = shift;
	
	print Maximus->config->{name};
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
