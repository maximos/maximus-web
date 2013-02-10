package Maximus::Schema::ResultSet::Module;
use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::ResultSet';

sub BUILDARGS { $_[2] }

sub search_by_modscope_and_name {
    my ($self, $modscope, $modname) = @_;
    return $self->search(
        {   'modscope.name' => $modscope,
            'me.name'       => $modname,
        },
        {   join     => 'modscope',
            prefetch => 'modscope',
        }
    );
}

sub search_by_modscope_and_name_and_version {
    my ($self, $modscope, $modname, $version) = @_;
    return $self->search(
        {   'modscope.name'           => $modscope,
            'me.name'                 => $modname,
            'module_versions.version' => $version,
        },
        {join => [qw /modscope module_versions/],}
    );
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Schema::ResultSet::Module - Resultset

=head1 DESCRIPTION

Additional methods for searching.

=head1 METHODS

=head2 BUILDARGS

Required to make this work with L<Moose>

=head2 search_by_modscope_and_name

Search modules by modscope and name.

=head2 search_by_modscope_and_name_and_version

Search modules by modscope, name and module version.

=head1 SEE ALSO

L<DBIx::Class::ResultSet>, L<Maximus::Schema::Result::Module>

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
