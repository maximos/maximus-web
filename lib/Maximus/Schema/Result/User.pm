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

=head1 METHODS

=head2 insert

Inserting a user record will also insert a role with a value of
I<user-id-mutable>.

=cut

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

=head2 search_role_objects($pattern)

Search for object id's in user roles.

C<$pattern> can be either a Regexp or a string. When using a string only supply
the prefix, e.g. I<scm> for I<^scm-\d+>

=cut

sub search_role_objects {
    my ($self, $pattern) = @_;
    unless (ref($pattern) eq 'Regexp') {
        $pattern = qr/^$pattern-\d+/;
    }
    
    return map { $_->role =~ m/(\d+)/ }
      grep     { $_->role =~ $pattern } $self->roles;
}

=head2 get_scms

Retrieve all SCM's this user has access to

=cut

sub get_scms {
    my ($self) = @_;
    my @scms   = $self->search_role_objects(qr/^scm-\d+-mutable/);
    return unless @scms;

    my $rs     = $self->result_source->schema->resultset('Scm');
    return $rs->search({ id => \@scms});
}

=head2 get_modscopes

Retrieve all modscopes this user has access to

=cut

sub get_modscopes {
    my ($self) = @_;
    my @modscopes = $self->search_role_objects(qr/^modscope-\d+-readable/);
    return unless @modscopes;

    my $rs        = $self->result_source->schema->resultset('Modscope');
    return $rs->search({ id => \@modscopes});
}

=head2 is_superuser

See if the user has the I<is_superuser> role

=cut

sub is_superuser {
    my ($self) = @_;
    return scalar grep { $_->role eq 'is_superuser' } $self->roles;
}

__PACKAGE__->meta->make_immutable;
1;
