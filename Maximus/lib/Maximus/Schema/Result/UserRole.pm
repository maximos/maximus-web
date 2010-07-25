package Maximus::Schema::Result::UserRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Maximus::Schema::Result::UserRole

=cut

__PACKAGE__->table("user_role");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 role_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "role_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("user_id", "role_id");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Maximus::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Maximus::Schema::Result::Role",
  { id => "role_id" },
  {},
);

=head2 user

Type: belongs_to

Related object: L<Maximus::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Maximus::Schema::Result::User",
  { id => "user_id" },
  {},
);


# Created by DBIx::Class::Schema::Loader v0.07000 @ 2010-07-25 12:04:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:k9swcqKTwfnBvVUPCUR2KQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
