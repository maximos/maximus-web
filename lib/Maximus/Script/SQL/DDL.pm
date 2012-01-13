package Maximus::Script::SQL::DDL;
use Moose;
use namespace::autoclean;

with 'Catalyst::ScriptRole';

with 'Maximus::Role::Schema';

has 'preversion' => (
    traits        => [qw(Getopt)],
    cmd_aliases   => 'p',
    isa           => 'Str',
    is            => 'ro',
    documentation => 'Database version to upgrade from',
);

has 'sql_dir' => (
    traits        => [qw(Getopt)],
    cmd_aliases   => 'd',
    isa           => 'Str',
    is            => 'ro',
    documentation => 'Directory to store SQL files in',
    default       => './sql',
);

sub run {
    my $self = shift;
    $self->_run_application;
}

sub _run_application {
    my $self    = shift;
    my $version = $self->schema->schema_version();

    $self->schema->create_ddl_dir(['MySQL', 'SQLite'],
        $version, $self->sql_dir, $self->preversion);
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Script::SQL::DDL - Generate SQL upgrade files

=head1 SYNOPSIS

    maximus_sql_ddl.pl [options]

=head1 DESCRIPTION

Generate SQL upgrade files.

=head1 ATTRIBUTES

=head2 preversion

The version of the database to create an upgrade file for

=head1 METHODS

=head2 run

=head2 _run_application

=head1 AUTHOR

Christiaan Kras

=head1 LICENSE

Copyright (c) 2010-2012 Christiaan Kras

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=cut

1;

