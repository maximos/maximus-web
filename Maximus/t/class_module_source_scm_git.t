use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Maximus::Class::Module::Source::SCM::Git' }
BEGIN { use_ok 'Maximus::Class::Module' }
BEGIN { use_ok 'Archive::Extract' }
BEGIN { use_ok 'Path::Class' }
BEGIN { use_ok 'File::Temp' }

my $zip = Path::Class::File->new('t', 'data', 'gitbarerepo.zip');
my $tmp_dir = File::Temp->newdir( CLEANUP => 1 );
my $ae = Archive::Extract->new( archive => $zip->stringify, type => 'zip' );
Maximus::Exception::Module::Archive->throw(error => $ae->error)
  unless $ae->extract( to => $tmp_dir );

my $localrepo = Path::Class::Dir->new( File::Temp->newdir( CLEANUP => 1 ) );
my $gitrepodir = Path::Class::Dir->new($tmp_dir->dirname, 'gitbarerepo');
my $scm = new_ok('Maximus::Class::Module::Source::SCM::Git' => [(
	local_repository => $localrepo->stringify,
	repository => $gitrepodir->stringify,
	mod_path => '',
	tags_filter => 'v?(.+)',
)]);

can_ok($scm, qw/
	get_latest_revision
	get_versions
	repository
	local_repository
	mod_path
	tags_filter
	prepare
/);

my %got_versions = $scm->get_versions();
my %expected_versions = (
	'2.0.1' => 'e4e2fd334e1af3923cbffcff55d4252bf23526bb',
	'2.0.2' => '3d9cffafaff551fe8cbf1a17f14ae15ea757e717',
	'2.0.3' => '2df5e26c2d2fffec7f24650fc15ccabb7a579ef5',
);
is_deeply(\%got_versions, \%expected_versions, 'Fetch expected versions');

is($scm->get_latest_revision(), 'fb79ce002ad52827c97a61614d21b028e5ad66e4', 'Latest revision check');

my $mod = Maximus::Class::Module->new(
	modscope => 'test',
	mod => 'mod1',
	desc => 'A test module',
	source => $scm,
);

foreach(qw/2.0.1 2.0.2 2.0.3 dev/) {
	# Make a new object so we get a new tmpDir everytime
	my $scm = Maximus::Class::Module::Source::SCM::Git->new(
		local_repository => $localrepo->stringify,
		repository => $gitrepodir->stringify,
		mod_path => '',
		tags_filter => 'v?(.+)',
		version => $_,
	);
	$scm->prepare($mod);
	ok($scm->validated, sprintf('test.mod1 %s validated', $_));
}

done_testing();
