package Maximus::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces(
    result_namespace => 'Result',
);


# Created by DBIx::Class::Schema::Loader v0.05001 @ 2010-03-15 21:21:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dq5GgSRPQg/7mXtKuuO9RA

__PACKAGE__->load_components(qw/Schema::Versioned/);
__PACKAGE__->upgrade_directory('sql/');
our $VERSION = '0.001';
1;
