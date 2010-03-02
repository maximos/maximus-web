package Maximus::Role::Module::Source;
use Moose::Role;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use Carp qw/confess/;
use File::Temp;
use IO::File;

=head1 NAME

Maximus::Role::Module::Source - Interface for module source handlers

=head1 SYNOPSIS

	package Maximus::Class::Module::Source::SCM::Foo;
	use Moose;

	with 'Maximus::Role::Module::Source';

=head1 DESCRIPTION

This is the interface for all Maximus::Class::Module::Source classes

=head1 ATTRIBUTES

=head2 version

Version of module this source represents
=cut
has 'version' => (is => 'rw', 'isa' => 'Str');

=head2 validated

Returns true if C<validate> succeeded.
=cut
has 'validated' => (is => 'rw', 'isa' => 'Bool');

=head2 tmpDir

Retrieve path to temporary directory for file storage. This directory wil be
automatically cleaned up.
=cut
has 'tmpDir' => (
	is => 'ro',
	'isa' => 'File::Temp::Dir',
	builder => '_tmpDirBuilder'
);

sub _tmpDirBuilder {
	return File::Temp->newdir();
}

=head1 METHODS

=head2 prepare

Prepare contents of temporarily directory to validate against the I<validate>
method of L<Maximus::Class::Module::Source::Base> 
=cut
requires 'prepare';

=head2 validate(I<$module>)

Validate directory structure and its contents to see if it can be archived.
I<$module> ISA Maximus::Class::Module
=cut
sub validate {
	my($self, $mod) = @_;

	confess('$mod isn\'t of the type Maximus::Class::Module')
	unless $mod->isa('Maximus::Class::Module');
	
	my $modName = join('.', $mod->modscope, $mod->mod);
	my $mainFile = $self->tmpDir . '/' . $mod->mod . '.bmx';	
	
	my $fh = new IO::File;
	confess('Unable to open main file: ', $mainFile)
	unless($fh->open($mainFile));

	my $modNameOK = 0;
	while(<$fh>) {
		chomp;
		if(index(lc($_), lc('Module ' . $modName)) != -1) {
			# Make sure the line isn't commented
			if($_ =~ m/^(\s|\t)*Module\s/) {
				$modNameOK = 1;
				last;
			}
		}
	}
	$fh->close;
	
	confess('Module name doesn\'t match') unless $modNameOK;
	$self->validated(1);
}

=head2 archive(I<$module>, I<$fileLocation>)

Create an archive out of the contents of the temporarily directory
=cut
sub archive {
	my($self, $mod, $location) = @_;
	confess('Sources are not validated') unless $self->validated;
	confess('Invalid source version') unless $self->version;

	my $modName = $mod->mod . '.mod';
	my $zip = Archive::Zip->new();
	$zip->zipfileComment(
		join("\n", (
			'This BlitzMax module has been packed by Maximus',
			'',
			"Modscope: " . $mod->modscope,
			"Mod: " . $mod->mod,
			"Version: " . $self->version,
			"Description: " . $mod->desc,
			'',
			'Archive creation date on ' . localtime
		))
	);
	$zip->addTree($self->tmpDir , $modName);

	# Remove generated documentation from archive
	$zip->removeMember($modName . '/doc/commands.html');
	
	my @members = $zip->membersMatching('\.(bmx|bbdoc|txt|c|h|cpp|cxx)$');
	$_->desiredCompressionMethod(COMPRESSION_DEFLATED) foreach(@members);
	
	my $fileName = sprintf('%s.%s-%s.zip',
		$mod->modscope,
		$mod->mod,
		$self->version
	);

	confess('Unable to save Zip Archive')
	unless( $zip->writeToFileNamed($location . $fileName) == AZ_OK );
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
