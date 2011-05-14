package Maximus::Controller::Timeline;
use DateTime;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

sub base : Chained('/') : PathPart('timeline') : CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash(announcements => $c->model('DB::Announcement')
          ->search_literal(undef, {order_by => {-desc => 'date'}}));
}

sub index : Chained('base') : PathPart('') : Args(0) {
    my ($self, $c) = @_;
}

sub build_feed : Chained('base') : PathPart('') : CaptureArgs(0) {
    my ($self, $c) = @_;

    my @entries;
    foreach my $announcement ($c->stash->{announcements}) {
        push @entries,
          { id       => $announcement->id,
            title    => $announcement->message,
            modified => $announcement->date,
            link     => $c->req->base,
          };
    }

    $c->stash(
        feed => {
            title => sprintf('%s Timeline', $c->config->{name}),
            copyright =>
              sprintf('%s %s', DateTime->now->year, $c->config->{name}),
            link        => $c->req->base,
            generator   => $c->config->{name},
            author      => $c->config->{name},
            description => 'A timeline that contains all announcements',
            modified    => DateTime->now,
            entries     => \@entries,
        }
    );
}

sub atom : Chained('build_feed') : PathPart : Args(0) {
    my ($self, $c) = @_;
    $c->stash->{feed}->{format}    = 'Atom';
    $c->stash->{feed}->{self_link} = $c->req->uri;
    $c->forward('View::Feed');
}

sub rss : Chained('build_feed') : PathPart : Args(0) {
    my ($self, $c) = @_;
    $c->stash->{feed}->{format}    = 'RSS 2.0';
    $c->stash->{feed}->{self_link} = $c->req->uri;
    $c->forward('View::Feed');
}

=head1 NAME

Maximus::Controller::Timeline - Timeline controller

=head1 DESCRIPTION

This controller is responsible for serving the timeline/announcements of the
website.

=head1 METHODS

=head2 base

=head2 index

=head2 atom

=head2 rss

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
