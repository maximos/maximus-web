package Maximus::Class::Transport::FileSystem;
use Moose;
use File::Path qw(make_path);
use File::Copy;
use Path::Class;
use namespace::autoclean;

with 'Maximus::Role::Transport';

has 'destination' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

sub transport {
    my ($self, $src, $dst_name) = @_;
    my $path = Path::Class::File->new($self->destination, $dst_name);
    make_path($path->dir->stringify);
    copy($src, $path->stringify) or die('Unable to copy file');
    return sprintf('%s/%s', $self->base_url, $dst_name);
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Class::Transport::FileSystem - FileSystem transport driver

=head1 SYNOPSIS

    use Maximus::Class::Transport::FileSystem;

    my $transporter = Maximus::Class::Transport::FileSystem->new(
        destination => '/my/dir',
        base_url    => 'http://localhost:5000/archives',
    );
    $transporter->transport($local_file, $remote_filename);

=head1 DESCRIPTION

This transport driver stores files locally.

=head1 ATTRIBUTES

=head2 base_url

The remote base url of the storage location

=head2 destination

Path where files will be stored.

=head1 METHODS

=head2 transport

Method that transports the given file. It returns the remote location of the
file if it succeeded, otherwise throws an exception.

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
