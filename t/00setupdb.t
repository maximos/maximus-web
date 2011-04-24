use strict;
use warnings;
use Test::More;


BEGIN {
    use FindBin qw/$Bin/;
    my $dbfile = "$Bin/../testdb.sqlite";
    unlink($dbfile) if (-e $dbfile);
}
BEGIN { use_ok 'Maximus' }

plan skip_all => 'Set MAXIMUS_CONFIG_LOCAL_SUFFIX to \'testing\'!'
  unless defined($ENV{MAXIMUS_CONFIG_LOCAL_SUFFIX})
      && $ENV{MAXIMUS_CONFIG_LOCAL_SUFFIX} eq 'testing';

my $schema = Maximus->model('DB')->schema;
ok(!$schema->get_db_version(), 'Database not versioned');
ok($schema->deploy(),          'Deploy schema');

done_testing();
