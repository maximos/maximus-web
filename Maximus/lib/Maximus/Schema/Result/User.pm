package Maximus::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Maximus::Schema::Result::User

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: INT
  default_value: undef
  extra: HASH(0x3e008ac)
  is_auto_increment: 1
  is_nullable: 0
  size: 10

=head2 username

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 45

=head2 password

  data_type: VARCHAR
  default_value: undef
  is_nullable: 0
  size: 40

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
  "username",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 45,
  },
  "password",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 40,
  },
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
);


# Created by DBIx::Class::Schema::Loader v0.05001 @ 2010-03-15 21:21:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:l49xOsYpzKQ5Q8ErhMNk9w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
