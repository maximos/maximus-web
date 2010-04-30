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

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 module_version_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 modscope

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 modname

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "module_version_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "modscope",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "modname",
  { data_type => "varchar", is_nullable => 0, size => 45 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("Index_3", ["module_version_id", "modscope", "modname"]);

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-04-30 21:49:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Je5fyQTIyNnlAaUN0YKHCg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
