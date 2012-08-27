package Maximus::Schema;

# Created by DBIx::Class::Schema::Loader

use Moose;
use namespace::autoclean;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-05-14 15:39:11

__PACKAGE__->load_components(qw/Schema::Versioned/);
__PACKAGE__->upgrade_directory('sql/');
our $VERSION = '1.000001';


__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
