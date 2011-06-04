use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Controller::Module::Upload' }
BEGIN { use_ok 'Test::WWW::Mechanize::Catalyst' => 'Maximus' }
BEGIN { use_ok 'Archive::Zip', qw(:ERROR_CODES) }
BEGIN { use_ok 'Path::Class' }
BEGIN { use_ok 'File::Temp' }

my $req = request('/module/upload');
ok($req->is_redirect, 'Request should redirect');

# Authenticate
my $ua1 = Test::WWW::Mechanize::Catalyst->new;
$ua1->get_ok('/account/login', 'Request login page');
$ua1->submit_form(
    fields => {
        username => 'demouser',
        password => 'demodemo',
    }
);
$ua1->content_contains('Welcome demouser!', 'Login successful');

# Test valid file upload
my $modpath = Path::Class::Dir->new('t', 'data', 'test.mod1');
my $zip = Archive::Zip->new();
$zip->addTree($modpath->stringify, 'test.mod1');
my $fh = File::Temp->new();
ok($zip->writeToFileHandle($fh) == AZ_OK, 'Created temporary zipfile');
$fh->seek(0, 0);

$ua1->get_ok('/module/upload', 'Request module upload page');
$ua1->content_contains('Upload Module', 'Title match');
$ua1->submit_form(
    fields => {
        scope => 'test',
        name  => 'mod1',
        desc  => 'my test module',
        file  => $fh->filename,
    }
);
$ua1->content_contains('Your module has been uploaded', 'Upload succesful');

# Test invalid file upload
$ua1->get_ok('/module/upload', 'Request module upload page');
$ua1->content_contains('Upload Module', 'Title match');
$ua1->submit_form(
    fields => {
        scope => 'test',
        name  => 'mod1',
        desc  => 'my test module',
        file  => Path::Class::File->new('t', 'data', 'test.mod1', 'dummy.exe')
          ->stringify,
    }
);
$ua1->content_contains('Your archive appears to be faulty', 'Upload failed');

done_testing();
