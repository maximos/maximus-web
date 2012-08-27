package Maximus::Schema::Result::Scm;

# Created by DBIx::Class::Schema::Loader

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Maximus::Schema::Result::Scm

=cut

__PACKAGE__->table("scm");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 software

  data_type: 'varchar'
  is_nullable: 0
  size: 15

=head2 repo_url

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 settings

  data_type: 'text'
  is_nullable: 0

=head2 revision

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 auto_discover_request

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 auto_discover_response

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
  "software",
  { data_type => "varchar", is_nullable => 0, size => 15 },
  "repo_url",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "settings",
  { data_type => "text", is_nullable => 0 },
  "revision",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "auto_discover_request",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "auto_discover_response",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 modules

Type: has_many

Related object: L<Maximus::Schema::Result::Module>

=cut

__PACKAGE__->has_many(
  "modules",
  "Maximus::Schema::Result::Module",
  { "foreign.scm_id" => "self.id" },
  {},
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-05-14 11:37:39


use JSON::Any;
__PACKAGE__->inflate_column(
    $_,
    {   inflate => sub { JSON::Any->jsonToObj(shift || '{}') },
        deflate => sub { JSON::Any->objToJson(shift || {}) },
    }
) for (qw/settings auto_discover_response/);

=head1 METHODS

=head2 insert

Inserting a scm record will also insert a role with a value of
I<scm-id-mutable>.

=cut

sub insert {
    my ($self, @args) = @_;

    my $guard = $self->result_source->schema->txn_scope_guard;
    $self->next::method(@args);

    # Create scm-<id>-mutable role and link it to the new scm
    my $rs_roles = $self->result_source->schema->resultset('Role');
    my $role = $rs_roles->create({role => 'scm-' . $self->id . '-mutable'});

    $guard->commit;

    return $self;
}

=head2 delete

Deleting a scm record will also remove any related roles

=cut

sub delete {
    my ($self, @args) = @_;

    my $schema = $self->result_source->schema;
    my $guard  = $schema->txn_scope_guard;
    $self->next::method(@args);

    my $rs_roles = $schema->resultset('Role');
    my $roles =
      $rs_roles->search({role => {-like => 'scm-' . $self->id . '-%'}});
    $roles->delete;

    $guard->commit;

    return $self;
}

=head2 get_role

Retrieve role

=cut

sub get_role {
    my ($self, $name) = @_;
    my $rs_roles = $self->result_source->schema->resultset('Role');
    return $rs_roles->single({role => 'scm-' . $self->id . '-' . $name});
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

__PACKAGE__->meta->make_immutable;
1;
