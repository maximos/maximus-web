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

  data_type: INT
  default_value: undef
  extra: HASH(0x39fb024)
  is_auto_increment: 1
  is_nullable: 0
  size: 10

=head2 modscope_id

  data_type: INT
  default_value: undef
  extra: HASH(0x39fab74)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=head2 module_id

  data_type: INT
  default_value: undef
  extra: HASH(0x39fb1b4)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

=head2 module_version_id

  data_type: INT
  default_value: undef
  extra: HASH(0x39f970c)
  is_foreign_key: 1
  is_nullable: 0
  size: 10

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
  "modscope_id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
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
  "module_version_id",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
    size => 10,
  },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 modscope

Type: belongs_to

Related object: L<Maximus::Schema::Result::Modscope>

=cut

__PACKAGE__->belongs_to(
  "modscope",
  "Maximus::Schema::Result::Modscope",
  { id => "modscope_id" },
  {},
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


# Created by DBIx::Class::Schema::Loader v0.05001 @ 2010-04-08 23:51:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4gMiHuuPpe2xZx3wPHc8tQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
