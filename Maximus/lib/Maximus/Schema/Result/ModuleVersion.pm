package Maximus::Schema::Result::ModuleVersion;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Maximus::Schema::Result::ModuleVersion

=cut

__PACKAGE__->table("module_version");

=head1 ACCESSORS

=head2 id

  data_type: INT
  default_value: undef
  extra: HASH(0x3b4dfe4)
  is_auto_increment: 1
  is_nullable: 0
  size: 10

=head2 module_id

  data_type: INT
  default_value: undef
  extra: HASH(0x39edb04)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=head2 version

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 10

=head2 remote_location

  data_type: VARCHAR
  default_value: undef
  is_nullable: 1
  size: 255

=head2 archive

  data_type: LONGBLOB
  default_value: undef
  is_nullable: 1
  size: 4294967295

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
    size => 10,
  },
  "module_id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
  "version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "remote_location",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "archive",
  {
    data_type => "LONGBLOB",
    default_value => undef,
    is_nullable => 1,
    size => 4294967295,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("Index_3", ["module_id", "version"]);

=head1 RELATIONS

=head2 module_dependency_module_version_ids

Type: has_many

Related object: L<Maximus::Schema::Result::ModuleDependency>

=cut

__PACKAGE__->has_many(
  "module_dependency_module_version_ids",
  "Maximus::Schema::Result::ModuleDependency",
  { "foreign.module_version_id" => "self.id" },
);

=head2 module_dependency_dependant_module_version_ids

Type: has_many

Related object: L<Maximus::Schema::Result::ModuleDependency>

=cut

__PACKAGE__->has_many(
  "module_dependency_dependant_module_version_ids",
  "Maximus::Schema::Result::ModuleDependency",
  { "foreign.dependant_module_version_id" => "self.id" },
);

=head2 module

Type: belongs_to

Related object: L<Maximus::Schema::Result::Module>

=cut

__PACKAGE__->belongs_to(
  "module",
  "Maximus::Schema::Result::Module",
  { id => "module_id" },
  {},
);


# Created by DBIx::Class::Schema::Loader v0.05001 @ 2010-04-15 20:12:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5eeBDXtnk+965MYwh/8x3w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
