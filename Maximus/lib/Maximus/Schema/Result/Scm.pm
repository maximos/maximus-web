package Maximus::Schema::Result::Scm;

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

Maximus::Schema::Result::Scm

=cut

__PACKAGE__->table("scm");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
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
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
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
  { data_type => "datetime", is_nullable => 1 },
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


# Created by DBIx::Class::Schema::Loader v0.07001 @ 2010-08-20 10:22:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Oev6tDjoUpH6TYsAgMO4FA


use JSON::Any;
__PACKAGE__->inflate_column('settings', {
	inflate => sub { JSON::Any->jsonToObj(shift || '{}') },
	deflate => sub { JSON::Any->objToJson(shift || {} ) },
});
1;


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
