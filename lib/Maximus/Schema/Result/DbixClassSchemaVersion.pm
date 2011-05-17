package Maximus::Schema::Result::DbixClassSchemaVersion;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Maximus::Schema::Result::DbixClassSchemaVersion

=cut

__PACKAGE__->table("dbix_class_schema_versions");

=head1 ACCESSORS

=head2 version

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 installed

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
  "version",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "installed",
  { data_type => "varchar", is_nullable => 0, size => 20 },
);
__PACKAGE__->set_primary_key("version");


# Created by DBIx::Class::Schema::Loader v0.07001 @ 2010-08-20 10:22:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iX8ufoyxRx73DerWav689g

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;
    $sqlt_table->extra(
        mysql_table_type => 'InnoDB',
        mysql_charset    => 'utf8'
    );
}

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

# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
