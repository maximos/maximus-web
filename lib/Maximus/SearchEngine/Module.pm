package Maximus::SearchEngine::Module;
use Data::SearchEngine::Item;
use Data::SearchEngine::Paginator;
use Data::SearchEngine::Results;
use Moose;
use namespace::autoclean;

with 'Data::SearchEngine';

has 'schema' => (is => 'rw', 'isa' => 'DBIx::Class::Schema');

sub search {
    my ($self, $query) = @_;

    # search for matching modules
    my $rs   = $self->schema->resultset('Module');
    my %like = (like => '%' . $query->query . '%');
    my @hits = $rs->search(
        {   -or => [
                'me.name'       => \%like,
                'me.desc'       => \%like,
                'modscope.name' => \%like,
                \[  "(modscope.name || '.' || me.name) = ?",
                    [val => $query->query]
                ]
            ],
        },
        {   join     => 'modscope',
            prefetch => 'modscope',
            rows     => $query->count,
            page     => $query->page,
        }
    );

    my $result = Data::SearchEngine::Results->new(
        query => $query,
        pager => Data::SearchEngine::Paginator->new(
            current_page     => $query->page,
            entries_per_page => $query->count,
            total_entries    => scalar @hits,
        )
    );

    # Iterate over your resultset here.
    foreach my $hit (@hits) {
        $result->add(
            Data::SearchEngine::Item->new(
                id     => sprintf('module-%d', $hit->id),
                values => {
                    scope => $hit->modscope->name,
                    mod   => $hit->name,
                    desc  => $hit->desc,
                },
                score => 1,
            )
        );
    }

    return $result;
}

sub find_by_id { }

=head1 NAME

Maximus::SearchEngine - Search Engine for the modules

=head1 DESCRIPTION

Search for modules

=head1 ATTRIBUTES

=head2 schema

A L<DBIx::Class::Schema>

=head1 METHODS

=head2 search(L<Data::SearchEngine::Query> $query)

Search for modules

=head2 find_by_id

Not implemented

=head1 AUTHOR

Christiaan Kras

=head1 LICENSE

Copyright (c) 2010-2011 Christiaan Kras

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

