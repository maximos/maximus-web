use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Maximus' }
BEGIN { use_ok 'Maximus::Class::Module' }
BEGIN { use_ok 'Maximus::SearchEngine::Module' }
BEGIN { use_ok 'DBIx::Class::Schema' }

my $schema = Maximus->model('DB')->schema;
my $se = new_ok('Maximus::SearchEngine::Module' => [(schema => $schema)]);

can_ok($se, qw( search find_by_id));

my ($scope, $mod, $desc) = ('search', 'engine', 'search engine az');

# Save a new module for querying
my $module = Maximus::Class::Module->new(
    modscope => $scope,
    mod      => $mod,
    desc     => $desc,
    schema   => $schema,
);
my $user = $schema->resultset('User')->create(
    {   username => 'searchengine',
        password => '1234',
        email    => 'search@engi.ne'
    }
);
$module->save($user);

# Try several keywords
foreach (qw(search engine search.engine az)) {
    my $query =
      Data::SearchEngine::Query->new(count => 10, page => 1, query => $_);
    ok(my $results = $se->search($query), 'Search for ' . $_);
    is(@{$results->items},                       1,      'Found 1 item');
    is($results->items->[0]->get_value('scope'), $scope, 'Scope match');
    is($results->items->[0]->get_value('mod'),   $mod,   'Name match');
    is($results->items->[0]->get_value('desc'),  $desc,  'Description match');
}

my $query =
  Data::SearchEngine::Query->new(count => 10, page => 1, query => "nothing");
ok(my $results = $se->search($query), 'Search for nothing');
is(@{$results->items}, 0, 'Found 0 items');

done_testing();

