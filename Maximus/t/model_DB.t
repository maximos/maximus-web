use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Model::DB' }

my $user = Maximus->model('DB::User')->create(
    {   username => 'test',
        password => 'test',
        email    => 'test@example.com',
    }
);

is( $user->roles->first->role,
    'user-' . $user->id . '-mutable',
    'user-<id>-mutable role available'
);

my $scm = Maximus->model('DB::Scm')->create(
    {   software => 'git',
        repo_url => '',
        settings => '',
    }
);

my $scm_role = $scm->get_role('mutable');
is( $scm_role->role,
    'scm-' . $scm->id . '-mutable',
    'scm-<id>-mutable role available'
);

ok($scm->delete, 'Delete SCM');

$scm_role = Maximus->model('DB::Role')->find({id => $scm_role->id});
ok(!$scm_role, 'scm-<id>-mutable role deleted');

done_testing();
