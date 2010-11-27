use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Controller::SCM' }
BEGIN { use_ok 'Test::WWW::Mechanize::Catalyst' => 'Maximus' }
BEGIN { use_ok 'Archive::Extract' }
BEGIN { use_ok 'Path::Class' }
BEGIN { use_ok 'File::Temp' }
BEGIN { use_ok 'DateTime' }

my $ua1 = Test::WWW::Mechanize::Catalyst->new;
$ua1->get_ok( '/account/login', 'Request login page' );
$ua1->submit_form(
    fields => {
        username => 'demo_user',
        password => 'demo',
    }
);
$ua1->content_contains( 'Welcome demo_user!', 'Login successful' );

my $zip = Path::Class::File->new( 't', 'data', 'gitbaremultirepo.zip' );
my $tmp_dir = File::Temp->newdir( CLEANUP => 1 );
my $ae = Archive::Extract->new( archive => $zip->stringify, type => 'zip' );
Maximus::Exception::Module::Archive->throw( error => $ae->error )
  unless $ae->extract( to => $tmp_dir );
my $gitrepodir = Path::Class::Dir->new( $tmp_dir->dirname, 'gitbaremultirepo' );

$ua1->get_ok( '/scm/new', 'Request add scm page' );
$ua1->submit_form(
    fields => {
        software => 'git',
        repo_url => $gitrepodir->stringify,
        modules  => [],
    },
);
$ua1->content_contains( 'Your SCM Configuration has been stored',
    'Added configuration' );

my $scm              = Maximus->model('DB::Scm')->first;
my $autodiscover_url = '/scm/' . $scm->id . '/autodiscover';
my $req = request($autodiscover_url);
ok( $req->is_redirect, 'Redirects' );
$scm->update( { auto_discover_response => { task_id => 'test' } } );

my $autodiscover =
  sub { $ua1->get_ok( $autodiscover_url, 'Request auto discover page' ); };
$autodiscover->();
$ua1->content_contains('task is being executed');
$scm->update(
    {
        auto_discover_request  => DateTime->now(),
        auto_discover_response => [
            qw/maxgui drivers/,
            qw/maxgui fltkmaxgui/,
            qw/maxgui maxgui/,
            qw/maxgui proxygadgets/
          ]

    }
);
$autodiscover->();
$ua1->content_contains('This Auto-Discover result was created on');
$scm->update({auto_discover_response => []});
$autodiscover->();
$ua1->content_contains('No BlitzMax modules were discovered');


done_testing();
