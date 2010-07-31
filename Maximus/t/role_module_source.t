use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Archive::Zip' }
BEGIN { use_ok 'File::Copy::Recursive', qw/dircopy/ }
BEGIN { use_ok 'File::Temp' }
BEGIN { use_ok 'Maximus::Role::Module::Source' }
BEGIN { use_ok 'Maximus::Class::Module' }
BEGIN { use_ok 'Maximus::Exceptions' }

{
	package TestSource;
	use Moose;
	use File::Copy::Recursive qw/dircopy/;
	use FindBin qw/$Bin/;
	with 'Maximus::Role::Module::Source';

	sub prepare {
		my($self,$mod) = @_;
		dircopy("$Bin/data/test.mod1", $self->tmpDir);
	}
	1;
}

can_ok('TestSource', qw(
	version
	validated
	tmpDir
	prepare
	validate
	archive
	findAndMoveRootDir
	findDependencies
));

my $source = new_ok('TestSource');

isa_ok($source->tmpDir, 'File::Temp::Dir');

my $mod = new_ok('Maximus::Class::Module' => [
	modscope => 'test',
	mod => 'mod1',
	desc => 'A module for testing',
	source => $source,
]);

$source->prepare($mod);
ok(-f sprintf('%s/%s.bmx', $source->tmpDir, $mod->mod), 'Check if mainfile was copied');

$source->validate($mod);
is($source->validated, 1, 'Module validated');
isnt($source->version, '1.00', 'Version string check');
is($source->version, '1.1.15', 'Version string check');

my $fh = new_ok('File::Temp');
my $filename = $source->archive($mod, $fh);

is($filename, sprintf('%s.%s-%s.zip', $mod->modscope, $mod->mod, $source->version), 'Archive filename check');

my $zip = new_ok('Archive::Zip' => [$fh->filename]);
my @gotMembers = sort($zip->memberNames());
my @expectedMembers = sort(
	'mod1.mod/',
	'mod1.mod/mod1.bmx',
	'mod1.mod/doc/',
	'mod1.mod/examples/',
	'mod1.mod/examples/example.bmx',
	'mod1.mod/inc/',
	'mod1.mod/inc/more_imports.bmx',
	'mod1.mod/inc/other_imports.bmx',
);
is_deeply(\@gotMembers, \@expectedMembers, 'Archive contains expected content');

eval {
	my @gotDependencies = $source->findDependencies($mod);
	my @expectedDependencies = (
		[qw(brl basic)],
		[qw(htbaapub rest)],
		[qw(brl retro)],
		[qw(htbaapub xmlrpc)],
		[qw(pub lua)],
		[qw(maxgui drivers)],
	);
	is_deeply(\@gotDependencies, \@expectedDependencies, 'Dependency check');
};

if(my $e = Maximus::Exception::Module::Source->caught()) {
	fail('Dependency check');
}

done_testing();
