use strict;
use warnings;
use FindBin;
use Test::More;

BEGIN { use_ok 'Maximus::Class::Transport::FileSystem' }
BEGIN { use_ok 'File::Temp' }
BEGIN { use_ok 'Path::Class' }

my $tmp_dir = File::Temp->newdir(CLEANUP => 1);

my $fs = new_ok(
    'Maximus::Class::Transport::FileSystem' => [
        (   destination => $tmp_dir->dirname,
            base_url    => 'http://localhost/files'
        )
    ]
);

can_ok($fs, qw/transport destination base_url/);

my $tmp_file = File::Temp->new();
my $remote_location = $fs->transport($tmp_file->filename, 'myfile.zip');
is( $remote_location,
    'http://localhost/files/myfile.zip',
    'remote location matches'
);

my $path = Path::Class::File->new($tmp_dir, 'myfile.zip');
ok(-e $tmp_file->filename, 'Temporary file still exists');
ok(-e $path->stringify,    'File has been copied');

done_testing();

