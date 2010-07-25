package Maximus::Role::Module::Source;
use Moose::Role;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use File::Copy::Recursive qw/dirmove/;
use File::Find;
use File::Temp;
use Maximus::Exceptions;
use Maximus::Class::Lexer;
use version;

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
has 'version' => (is => 'rw', isa => 'Str');

=head2 validated

Returns true if C<validate> succeeded.
=cut
has 'validated' => (is => 'rw', isa => 'Bool');

=head2 tmpDir

Retrieve path to temporary directory for file storage. This directory wil be
automatically cleaned up.
=cut
has 'tmpDir' => (
	is => 'ro',
	isa => 'File::Temp::Dir',
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

	Maximus::Exception::Module::Source->throw(
		'$mod isn\'t of the type Maximus::Class::Module'
	) unless $mod->isa('Maximus::Class::Module');
	
	my $modName = join('.', $mod->modscope, $mod->mod);
	my $mainFile = $self->tmpDir . '/' . $mod->mod . '.bmx';	
	
	my $fh = new IO::File;
	Maximus::Exception::Module::Source->throw(
		'Unable to open main file: ' . $mainFile
	) unless($fh->open($mainFile));

	my $contents;
	$contents .= $_ for(<$fh>);
	$fh->close;
	
	my $lexer = Maximus::Class::Lexer->new;
	my @tokens = $lexer->tokens($contents);
	my $modNameOK = 0;
	foreach(@tokens) {
		if($_->[0] eq 'MODULENAME' && $_->[1] eq $modName) {
			$modNameOK = 1;
		}
		elsif($_->[0] eq 'MODULEVERSION') {
			$mod->source->version(version->parse($_->[1])->stringify);
		}
	}	

	Maximus::Exception::Module::Source->throw(
		user_msg => 'Module name doesn\'t match'
	) unless $modNameOK;
	$self->validated(1);
}

=head2 findDependencies(I<$module>)

Analyze BlitzMax source code to find dependent modules.
Returns an array with at each index an array of which the first value is the
modscope, and the second the modname.
I<$module> ISA Maximus::Class::Module
=cut
sub findDependencies {
	my($self, $mod, $filename) = @_;

	confess('Sources are not validated') unless $self->validated;
	
	$filename = $self->tmpDir . '/' . $mod->mod . '.bmx' unless $filename;
	Maximus::Exception::Module::Source->throw(
		'Sourcefile doesn\'t exist: ' . $filename
	) unless(-e $filename);
	
	open(my $fh, $filename);
	Maximus::Exception::Module::Source->throw(
		'Couldn\'t open sourcefile: ' . $filename
	) unless($fh);
	my $contents;
	$contents .= $_ for(<$fh>);
	close($fh);
	
	my $lexer = Maximus::Class::Lexer->new;
	my @tokens = $lexer->tokens($contents);
	my @deps;
	foreach(@tokens) {
		if($_->[0] eq 'DEPENDENCY') {
			push @deps, [split/\./, $_->[1]];
		}
		elsif($_->[0] eq 'INCLUDE_FILE') {
			my $path = $self->tmpDir . '/' . $_->[1];
			@deps = (@deps, $self->findDependencies($mod, $path));
		}
	}

	return @deps;
}

=head2 archive(I<$module>, I<$fh>)

Create an archive out of the contents of the temporarily directory
I<$fh> should be a C<IO::Handle> or any other derived handle. Returns the name
of the archive on success.
=cut
sub archive {
	my($self, $mod, $fh) = @_;
	confess('Sources are not validated') unless $self->validated;
	confess('Invalid source version') unless $self->version;
	confess('Handle isn\'t a IO::Handle') unless $fh->isa('IO::Handle');

	my $modName = $mod->mod . '.mod';
	my $zip = Archive::Zip->new();
	$zip->zipfileComment(
		join("\n", (
			'This BlitzMax module has been packed by Maximus',
			'',
			pack('A20A*', 'Modscope', $mod->modscope),
			pack('A20A*', 'Mod', $mod->mod),
			pack('A20A*', 'Version', $self->version),
			pack('A20A*', 'Description', $mod->desc),
			'',
			'Archive creation date on ' . localtime
		))
	);
	$zip->addTree($self->tmpDir , $modName);

	# Remove generated documentation from archive
	$zip->removeMember($modName . '/doc/commands.html');
	
	# Remove files that are the result of a compilation
	foreach($zip->membersMatching('\.(o|s|a|i|exe|gitignore|bmx\/|svn\/)$')) {
		$zip->removeMember($_);
	}
	
	my @members = $zip->membersMatching('\.(bmx|bbdoc|txt|c|h|cpp|cxx)$');
	$_->desiredCompressionMethod(COMPRESSION_DEFLATED) foreach(@members);

	confess('Unable to save Zip Archive')
	unless( $zip->writeToFileHandle($fh) == AZ_OK );
	$fh->seek(0,0);
	
	sprintf('%s.%s-%s.zip',
		$mod->modscope,
		$mod->mod,
		$self->version
	);
}

=head2 findAndMoveRootDir(I<$module>)

Find the location of the mainfile and move the contents of this directory to the
root of the temporary directory
=cut
sub findAndMoveRootDir {
	my($self, $mod) = @_;
	return if(defined($mod->source->version) && $mod->source->version eq 'dev');
	my $mainFile = $mod->mod . '.bmx';
	
	my @files;
	finddepth(sub {
		return if($_ eq '.' || $_ eq '..');
		push @files, $File::Find::name;
	}, $self->tmpDir);
	
	@files = sort @files;
	foreach(@files) {
		if($_ =~ m/\/$mainFile$/) {
			my $rootDir = $_;
			$rootDir =~ s/$mainFile$//;
			chop($rootDir) if substr($rootDir,-1,1) eq '/';
			last if $rootDir eq $self->tmpDir;
			dirmove($rootDir, $self->tmpDir);
			last;
		}	
	}
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
