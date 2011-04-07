package Maximus::Role::Module::Source::SCM;
use Moose::Role;
use File::Find;
use Path::Class;

requires 'get_versions';

requires 'get_latest_revision';

sub auto_discover {
    my ($self, undef, undef, $dir) = @_;

    my @mods;
    finddepth(
        sub {
            if (-d $File::Find::name) {
                if ($_ =~ m/(.+)\.mod$/) {
                    my $mod  = $1;
                    my $path = Path::Class::Dir->new($File::Find::name);
                    if ($path->parent =~ m/([a-z0-9_]+)\.mod$/i) {
                        my $scope = $1;
                        push @mods, [$scope, $mod];
                    }
                    else {
                        push @mods, [undef, $mod];
                    }
                }
            }
        },
        $dir
    );
    return @mods;
}

=head1 NAME

Maximus::Role::Module::Source::SCM - Interface for module source SCM handlers

=head1 SYNOPSIS

	package Maximus::Class::Module::Source::SCM::Foo;
	use Moose;

	with 'Maximus::Role::Module::Source::SCM';

=head1 DESCRIPTION

This is the interface for all Maximus::Class::Module::Source::SCM classes

=head1 ATTRIBUTES

=head1 METHODS

=head2 get_versions

returns a hash with available versions

=head2 get_last_revision

returns the latest revision of the repository

=head2 auto_discover

search the repository for module names. Used for a repository hosting an entire
modscope.

It does its best to support multi modscope repositories by adding the scope

Returns all found module names and if applicable also the modscope.

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
