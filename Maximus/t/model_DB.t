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

ok(!$user->is_superuser, 'not is_superuser');
my $role_superuser =
  Maximus->model('DB::Role')->create({role => 'is_superuser'});
$user->create_related('user_roles', {role_id => $role_superuser->id});
ok($user->is_superuser, 'is_superuser');

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

my $modscope = Maximus->model('DB::Modscope')->create({name => 'testscope'});

my $modscope_get_roles = sub {
    return Maximus->model('DB::Role')
      ->search({role => {-like => 'modscope-' . $modscope->id . '-%'}});
};

my @modscope_roles               = $modscope_get_roles->();
my @modscope_role_names          = sort map { $_->role } @modscope_roles;
my @modscope_role_names_expected = (
    'modscope-' . $modscope->id . '-mutable',
    'modscope-' . $modscope->id . '-readable'
);
@modscope_role_names_expected = sort(@modscope_role_names_expected);

is_deeply(
    \@modscope_role_names,
    \@modscope_role_names_expected,
    'Modscope contains expected roles'
);
ok($modscope->delete, 'Delete modscope');
ok(!Maximus->model('DB::Role')->find({role => $_->role}),
    $_->role . ' deleted')
  for (@modscope_roles);

done_testing();
