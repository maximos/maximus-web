#!/bin/env perl
use strict;
use Pod::Usage;
use Getopt::Long;
use lib './lib';
use Maximus::Schema;

my ( $preversion, $help );
GetOptions(
'p|preversion:s'  => \$preversion,
) or die pod2usage;

my $schema = Maximus::Schema->connect(
'dbi:mysql:maximus',
'maximus',
'demo',
);
my $sql_dir = './sql';
my $version = $schema->schema_version();
# Change MySQL to undef to generate DDL's for SQLite, PostgreSql and MySQL
$schema->create_ddl_dir( 'MySQL', $version, $sql_dir, $preversion );
