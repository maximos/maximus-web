package Maximus::Schema::Result::ModuleDependency;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Maximus::Schema::Result::ModuleDependency

=cut

__PACKAGE__->table("module_dependency");

=head1 ACCESSORS

=head2 module_version_id

  data_type: INT
  default_value: undef
  extra: HASH(0x3bc619c)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=head2 dependant_module_version_id

  data_type: INT
  default_value: undef
  extra: HASH(0x3bc5d94)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=cut

__PACKAGE__->add_columns(
  "module_version_id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "dependant_module_version_id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
);
__PACKAGE__->set_primary_key("module_version_id", "dependant_module_version_id");

=head1 RELATIONS

=head2 dependant_module_version

Type: belongs_to

Related object: L<Maximus::Schema::Result::ModuleVersion>

=cut

__PACKAGE__->belongs_to(
  "dependant_module_version",
  "Maximus::Schema::Result::ModuleVersion",
  { id => "dependant_module_version_id" },
  {},
);

=head2 module_version

Type: belongs_to

Related object: L<Maximus::Schema::Result::ModuleVersion>

=cut

__PACKAGE__->belongs_to(
  "module_version",
  "Maximus::Schema::Result::ModuleVersion",
  { id => "module_version_id" },
  {},
);


# Created by DBIx::Class::Schema::Loader v0.05003 @ 2010-04-24 12:19:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sTZm1kmUvNVzuO+QhwPT8Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
