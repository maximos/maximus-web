package Maximus::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

sub index : Path : Args(0) {
    my ($self, $c) = @_;
}

sub default : Private {
    my ($self, $c) = @_;
    $c->forward('error_404');
}

sub error_404 : Private {
    my ($self, $c) = @_;
    $c->stash->{template} = '404.tt';
    $c->response->status(404);
}

sub error_403 : Private {
    my ($self, $c) = @_;
    $c->stash->{template} = '403.tt';
    $c->response->status(403);
}

sub end : ActionClass('RenderView') {
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Controller::Root - Root Controller for Maximus

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=head2 default

Standard 404 error page

=head2 error_404

Standard 404 not-found page

=head2 error_403

Standard 403 forbidden page

=head2 end

Attempt to render a view, if needed.

=head1 AUTHOR

Christiaan Kras

=head1 LICENSE

Copyright (c) 2010 Christiaan Kras

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
