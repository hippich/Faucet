use utf8;
package Faucet::Schema::Result::Facebook;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Faucet::Schema::Result::Facebook

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<facebook>

=cut

__PACKAGE__->table("facebook");

=head1 ACCESSORS

=head2 token

  data_type: 'varchar'
  is_nullable: 0
  size: 256

=head2 username

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 ip

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 address

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 first_name

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 last_name

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 link

  data_type: 'varchar'
  is_nullable: 1
  size: 1024

=head2 id

  data_type: 'int'
  is_nullable: 1

=head2 gender

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 hometown

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 hometown_id

  data_type: 'int'
  is_nullable: 1

=head2 location

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 location_id

  data_type: 'int'
  is_nullable: 1

=head2 timezone

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 time

  data_type: 'int'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "token",
  { data_type => "varchar", is_nullable => 0, size => 256 },
  "username",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "ip",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "address",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "first_name",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "last_name",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "link",
  { data_type => "varchar", is_nullable => 1, size => 1024 },
  "id",
  { data_type => "int", is_nullable => 1 },
  "gender",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "hometown",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "hometown_id",
  { data_type => "int", is_nullable => 1 },
  "location",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "location_id",
  { data_type => "int", is_nullable => 1 },
  "timezone",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "time",
  { data_type => "int", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</token>

=back

=cut

__PACKAGE__->set_primary_key("token");


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2011-11-24 09:59:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:esLrFGhp0qFMVt4IkSgxdA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
