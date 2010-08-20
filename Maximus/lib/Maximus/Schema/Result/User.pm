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

=head2 modscopes

Type: has_many

Related object: L<Maximus::Schema::Result::Modscope>

=cut

__PACKAGE__->has_many(
  "modscopes",
  "Maximus::Schema::Result::Modscope",
  { "foreign.user_id" => "self.id" },
  {},
);

=head2 scms

Type: has_many

Related object: L<Maximus::Schema::Result::Scm>

=cut

__PACKAGE__->has_many(
  "scms",
  "Maximus::Schema::Result::Scm",
  { "foreign.user_id" => "self.id" },
  {},
);

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


# Created by DBIx::Class::Schema::Loader v0.07001 @ 2010-08-20 10:22:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Njc/JXf4nwryYC5Luz+KzQ


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
