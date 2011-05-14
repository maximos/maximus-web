package Maximus::Schema::Result::Announcement;

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

Maximus::Schema::Result::Announcement

=cut

__PACKAGE__->table("announcement");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 message

  data_type: 'text'
  is_nullable: 0

=head2 message_type

  data_type: 'varchar'
  is_nullable: 0
  size: 45

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
  "date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "message",
  { data_type => "text", is_nullable => 0 },
  "message_type",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "meta_data",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-05-14 15:41:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:T8IPxXaS/foXU/y2zVYs6w

use JSON::Any;
__PACKAGE__->inflate_column('meta_data', {
	inflate => sub { JSON::Any->jsonToObj(shift || '{}' ) },
	deflate => sub { JSON::Any->objToJson(shift || {} ) },
});

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
