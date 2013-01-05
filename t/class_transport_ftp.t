use strict;
use warnings;
use Test::More;
use File::Slurp qw(slurp);
use File::Copy;
use v5.12;

BEGIN {
    use Net::FTP::Mock (
        localhost => {
            Anonymous => {
                '' => {
                    active => 1,
                    root   => 't/data/ftp-server/',
                }
            }
        }
    );

    sub Net::FTP::Mock::put {
        my ($self, $src, $dst) = @_;
        note('Faking file upload to ', $dst);
        given (ref($src)) {
            when ('File::Temp') {

                #note('Contents contain: ', slurp($src->filename));
                copy($src->filename, $dst);
            }
            default {
                #note('Contents contain: ', slurp($src));
                copy($src, $dst);
            }
        }
        return 1;
    }
}

BEGIN { use_ok 'Maximus::Class::Transport::FTP' }
BEGIN { use_ok 'File::Temp' }

my $tmp_dir = File::Temp->newdir(CLEANUP => 1);

my $fs = new_ok(
    'Maximus::Class::Transport::FTP' => [
        (   destination => $tmp_dir->dirname,
            base_url    => 'http://localhost/files',
            hostname    => 'localhost',
            port        => 21,
            username    => 'Anonymous',
            password    => '',
        )
    ]
);

can_ok($fs, qw/transport base_url hostname port username password/);

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

