package Maximus::Schema::ResultSet::Modscope;
use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::ResultSet';

sub BUILDARGS { $_[2] }

sub search_prefetch_modules_order_by_name_desc {
    return shift->search(
        undef,
        {   order_by => {-desc => 'me.name',},
            prefetch => 'modules',
        }
    );
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Schema::ResultSet::Modscope - Resultset

=head1 DESCRIPTION

Additional methods for searching.

=head1 METHODS

=head2 BUILDARGS

Required to make this work with L<Moose>

=head2 search_prefetch_modules_order_by_name_desc

Searches modscopes with their modules prefetched, ordered by modscope name.

=head1 SEE ALSO

L<DBIx::Class::ResultSet>, L<Maximus::Schema::Result::Modscope>

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

