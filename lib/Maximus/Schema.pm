package Maximus::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use namespace::autoclean;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-05-14 15:39:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vLonTLLPAm6VLcbA/+tlQA

__PACKAGE__->load_components(qw/Schema::Versioned/);
__PACKAGE__->upgrade_directory('sql/');
our $VERSION = '0.004';



# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
