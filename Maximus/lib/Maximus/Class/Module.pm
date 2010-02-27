package Maximus::Class::Module;
use Moose;

=head1 NAME

Maximus::Class::Module - Represents a module

=head1 SYNOPSIS

	use Maximus::Class::Module;
	my $module = Maximus::Class::Module->new;

=head1 DESCRIPTION

This class represents a module

=head1 ATTRIBUTES

=head2 modscope

Modscope (namespace) of module, e.g. B<brl>.example
=cut
has 'modscope' => (is => 'rw', isa => 'String', required => 1);

=head2 mod

Name of module, e.g. brl.B<example>
=cut
has 'mod' => (is => 'rw', isa => 'String', required => 1);

=head2 name

Formal name of module
=cut
has 'name' => (is => 'rw', isa => 'String', required => 1);

=head1 METHODS

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
