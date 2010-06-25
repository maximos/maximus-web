package Maximus::Class::Module::Source::Archive;
use Moose;
use Archive::Extract;
use Carp qw/confess/;
use File::Type;
use Maximus::Exceptions;
use namespace::autoclean;

with 'Maximus::Role::Module::Source';

=head1 NAME

Maximus::Class::Module::Source::Archive - Handles module sources in
archives

=head1 SYNOPSIS

	use Maximus::Class::Module::Source::Archive;
	my $source = Maximus::Class::Module::Source::Archive->new;

=head1 DESCRIPTION

Archive support for retrieving the modules sources.

=head1 ATTRIBUTES

=head2 file

Location to archive file
=cut
has 'file' => (is => 'rw', isa => 'Str', required => 1);

=head1 METHODS

=head2 prepare

Extract given archive to temporary directory and modify its contents if required
=cut
sub prepare {
	my($self, $mod) = @_;
	my $type = File::Type->new->checktype_filename($self->file);
	
	Maximus::Exception::Module::Archive->throw(
		error => 'Not a zip archive: ' . $type
	) unless $type eq 'application/zip';
	
	my $ae = Archive::Extract->new( archive => $self->file, type => 'zip' );
	Maximus::Exception::Module::Archive->throw(error => $ae->error)
	  unless $ae->extract( to => $self->tmpDir );
	
	$self->findAndMoveRootDir($mod);
	$self->validate($mod);
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
