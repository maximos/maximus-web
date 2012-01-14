package Maximus::Controller::Page;
use Moose;
use Path::Class;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

sub index : Path('/') {
    my ($self, $c, @args) = @_;
    unshift @args, 'page';
    $args[$#args] .= '.tt';
    my @include_path = @{$c->view('TT')->config->{INCLUDE_PATH}};
    my $path = Path::Class::File->new(@include_path, @args);
    $c->detach('/default') unless (-f $path->stringify);
    $c->stash(template => Path::Class::File->new(@args)->stringify);
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Controller::Page - Static Page Controller

=head1 DESCRIPTION

This controller is responsible for serving a number of static pages.

=head1 METHODS

=head2 index

Display template from I</static/templates/page/> directory. Redirects to a 404
error page when not found.

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
