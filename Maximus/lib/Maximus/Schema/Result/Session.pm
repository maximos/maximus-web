package Maximus::Schema::Result::Session;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Maximus::Schema::Result::Session

=cut

__PACKAGE__->table("session");

=head1 ACCESSORS

=head2 id

  data_type: CHAR
  default_value: undef
  is_nullable: 0
  size: 72

=head2 session_data

  data_type: TEXT
  default_value: undef
  is_nullable: 1
  size: 65535

=head2 expires

  data_type: INT
  default_value: undef
  extra: HASH(0x3bf828c)
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 72 },
  "session_data",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "expires",
  {
    data_type => "INT",
    default_value => undef,
    extra => { unsigned => 1 },
    is_nullable => 1,
    size => 10,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.05001 @ 2010-03-15 23:18:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9IUDrvfSlwAIz6MmfqouqQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;