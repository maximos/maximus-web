package Maximus::Role::Module::Source::SCM;
use Moose::Role;
use File::Find;
use Path::Class;
use File::Slurp;

requires 'get_versions';

requires 'get_latest_revision';

requires 'apply_scm_settings';

has 'lexer' => (
    is      => 'ro',
    isa     => 'Maximus::Class::Lexer',
    lazy    => 1,
    default => sub { Maximus::Class::Lexer->new },
);

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
                        push @mods, [$scope, $mod, undef];
                    }
                    else {
                        my ($scope, $desc);
                        my $file_path =
                          Path::Class::File->new($File::Find::name,
                            $mod . '.bmx');

                        # Parse the mainfile to find out what the modscope is
                        # supposed to be
                        if (-f $file_path->stringify) {
                            my $contents = read_file($file_path->stringify);
                            my @tokens   = $self->lexer->tokens($contents);
                            foreach my $token (@tokens) {
                                if ($token->[0] eq 'MODULENAME') {
                                    $scope = lc((split /\./, $token->[1])[0]);
                                }
                                elsif ($token->[0] eq 'MODULEDESCRIPTION') {
                                    $desc = $token->[1] . "";
                                }
                                last if ($scope && $desc);
                            }
                        }
                        push @mods, [$scope, $mod, $desc];
                    }
                }
            }
        },
        $dir
    );
    @mods = sort { $a->[0] . $a->[1] cmp $b->[0] . $b->[1] } @mods;
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

=head2 apply_scm_settings

Apply SCM specific settings

=head2 auto_discover

search the repository for module names. Used for a repository hosting an entire
modscope.

It does its best to support multi modscope repositories by adding the scope.

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
