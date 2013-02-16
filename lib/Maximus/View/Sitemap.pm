package Maximus::View::Sitemap;
use Moose;
use namespace::autoclean;
use Search::Sitemap;

extends 'Catalyst::View';

sub process {
    my ($self, $c) = @_;
    my $map       = Search::Sitemap->new();
    my @locations = @{$c->stash->{sitemap}};
    $map->add($_) foreach (@locations);
    $c->response->header('Content-Type' => 'text/xml');
    $c->response->body($map->xml());
    return 1;
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::View::Sitemap - Catalyst View

=head1 SYNOPSIS

    $c->stash(
        sitemap => [
            {   loc        => '/',
                priority   => 1.0,
                changefreq => 'monthly',
            },
            {   loc      => '/client',
                priority => 1.0,
            },
        ]
    );

=head1 DESCRIPTION

Catalyst View for rendering a XML Sitemap.

=head1 METHODS

=head2 process

Process view.

=head1 SEE ALSO

L<Search::Sitemap>

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
