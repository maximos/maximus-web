package Maximus::Script::SQL::Upgrade;
use Moose;
use namespace::autoclean;

with 'Catalyst::ScriptRole';

with 'Maximus::Role::Schema';

sub run {
    my $self = shift;
    $self->_run_application;
}

sub _run_application {
    my $self   = shift;
    my $schema = $self->schema;

    if (!$schema->get_db_version()) {
        $schema->deploy();
    }
    else {
        $schema->upgrade();
    }
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Script::SQL::Upgrade - Update database to latest version 

=head1 SYNOPSIS

    maximus_sql_upgrade.pl

=head1 DESCRIPTION

Upgrade database to latest version

=head1 METHODS

=head2 run

=head2 _run_application

=head1 AUTHOR

Christiaan Kras

=head1 LICENSE

Copyright (c) 2010-2013 Christiaan Kras

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


