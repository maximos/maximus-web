package Maximus::Schema::Result::User;

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

Maximus::Schema::Result::User

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 password

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 email

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
  "username",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "password",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 45 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("Index_2", ["username"]);

=head1 RELATIONS

=head2 user_roles

Type: has_many

Related object: L<Maximus::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "Maximus::Schema::Result::UserRole",
  { "foreign.user_id" => "self.id" },
  {},
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-01-30 21:46:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xjGzMUdsAE2WtAwXE9+TFw

__PACKAGE__->many_to_many(
    "roles",
    "user_roles",
    "role"
);

sub insert {
    my ( $self, @args ) = @_;

    my $guard = $self->result_source->schema->txn_scope_guard;
    $self->next::method(@args);

    # Create user-<id>-mutable role and link it to the new user
    my $rs_roles = $self->result_source->schema->resultset('Role');
    my $role = $rs_roles->create({role => 'user-' . $self->id . '-mutable'});
    $self->create_related('user_roles', {role_id => $role->id});

    $guard->commit;

    return $self;
}

__PACKAGE__->meta->make_immutable;
1;
