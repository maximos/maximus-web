package Maximus::Schema::Result::ModuleDependency;

# Created by DBIx::Class::Schema::Loader

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

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
    {   data_type         => "integer",
        extra             => {unsigned => 1},
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    "module_version_id",
    {   data_type      => "integer",
        extra          => {unsigned => 1},
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    "modscope",
    {data_type => "varchar", is_nullable => 0, size => 45},
    "modname",
    {data_type => "varchar", is_nullable => 0, size => 45},
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("idx_module_dependency_1",
    ["module_version_id", "modscope", "modname"]);

=head1 RELATIONS

=head2 module_version

Type: belongs_to

Related object: L<Maximus::Schema::Result::ModuleVersion>

=cut

__PACKAGE__->belongs_to(
    "module_version",
    "Maximus::Schema::Result::ModuleVersion",
    {id => "module_version_id"}, {},
);


# Created by DBIx::Class::Schema::Loader v0.07001 @ 2010-08-20 10:22:45


=head2 sqlt_deploy_hook

Force MySQL to use InnoDB and UTF-8

=cut

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;
    $sqlt_table->extra(
        mysql_table_type => 'InnoDB',
        mysql_charset    => 'utf8'
    );
}

__PACKAGE__->meta->make_immutable;
1;
