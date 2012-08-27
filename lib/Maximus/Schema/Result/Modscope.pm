package Maximus::Schema::Result::Modscope;

# Created by DBIx::Class::Schema::Loader

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Maximus::Schema::Result::Modscope

=cut

__PACKAGE__->table("modscope");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

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
  "name",
  { data_type => "varchar", is_nullable => 0, size => 45 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("uniq_name", ["name"]);

=head1 RELATIONS

=head2 modules

Type: has_many

Related object: L<Maximus::Schema::Result::Module>

=cut

__PACKAGE__->has_many(
  "modules",
  "Maximus::Schema::Result::Module",
  { "foreign.modscope_id" => "self.id" },
  {},
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-30 21:39:48


=head1 METHODS

=head2 insert

Inserting a modscope record will also insert a role with a value of
I<modscope-id-mutable> and I<modscope-id-readable>.

=cut

sub insert {
    my ($self, @args) = @_;

    my $guard = $self->result_source->schema->txn_scope_guard;
    $self->next::method(@args);

    # Create scm-<id>-mutable role and link it to the new modscope
    my $rs_roles = $self->result_source->schema->resultset('Role');
    $rs_roles->create({role => 'modscope-' . $self->id . '-' . $_})
      for (qw/mutable readable/);

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
      $rs_roles->search({role => {-like => 'modscope-' . $self->id . '-%'}});
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
    return $rs_roles->single({role => 'modscope-' . $self->id . '-' . $name});
}

=head2 get_authors

Retrieve the authors who're allowed to use this modscope

=cut

sub get_authors {
    my ($self, $role_name) = @_;
    my $role    = $self->get_role($role_name || 'readable');
    my @roles   = $role->search_related('user_roles');
    my @authors = map { $_->user } @roles;
    return @authors;
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
