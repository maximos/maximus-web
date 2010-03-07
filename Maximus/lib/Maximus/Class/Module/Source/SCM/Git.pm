package Maximus::Class::Module::Source::SCM::Git;
use Moose;
use namespace::autoclean;

with 'Maximus::Role::Module::Source';
with 'Maximus::Role::Module::Source::SCM';

=head1 NAME

Maximus::Class::Module::Source::SCM::Git - Handles module sources inside a Git
repository

=head1 SYNOPSIS

	use Maximus::Class::Module::Source::SCM::Git;
	my $source = Maximus::Class::Module::Source::SCM::Git->new;

=head1 DESCRIPTION

Git support for retrieving the modules sources.

=head1 ATTRIBUTES

=head1 METHODS


=head2 listVersions

Returns all versions
=cut
sub listVersions {
	my($self) = @_;
	my %tags;
	return %tags;
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
