package Maximus::Schema::Result::ModuleVersion;

# Created by DBIx::Class::Schema::Loader

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Maximus::Schema::Result::ModuleVersion

=cut

__PACKAGE__->table("module_version");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 module_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 version

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 remote_location

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 archive

  data_type: 'longblob'
  is_nullable: 1

=head2 meta_data

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "module_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "version",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "remote_location",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "archive",
  { data_type => "longblob", is_nullable => 1 },
  "meta_data",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("Index_3", ["module_id", "version"]);

=head1 RELATIONS

=head2 module_dependencies

Type: has_many

Related object: L<Maximus::Schema::Result::ModuleDependency>

=cut

__PACKAGE__->has_many(
  "module_dependencies",
  "Maximus::Schema::Result::ModuleDependency",
  { "foreign.module_version_id" => "self.id" },
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


# Created by DBIx::Class::Schema::Loader v0.07001 @ 2010-08-20 10:22:45

use JSON::Any;
__PACKAGE__->inflate_column(
    'meta_data',
    {   inflate => sub { JSON::Any->jsonToObj(shift || '{}') },
        deflate => sub { JSON::Any->objToJson(shift || {}) },
    }
);

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
