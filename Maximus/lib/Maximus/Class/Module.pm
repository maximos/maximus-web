package Maximus::Class::Module;
use Moose;
use Moose::Util::TypeConstraints;
use Maximus::Exceptions;
use IO::File;
use namespace::autoclean;

=head1 NAME

Maximus::Class::Module - Represents a module

=head1 SYNOPSIS

	use Maximus::Class::Module;
	my $module = Maximus::Class::Module->new;

=head1 DESCRIPTION

This class represents a module

=head1 ATTRIBUTES

=head2 modscope

Modscope (namespace) of module, e.g. B<brl>.example
=cut

subtype 'ModScope' => as Str => where {
    my $modscope = $_;
    foreach my $reservedScope (('brl', 'pub')) {
        return 0 if (lc($modscope) eq lc($reservedScope));
    }
    1;
} => message {"This modscope ($_) is reserved!"};

has 'modscope' => (is => 'rw', isa => 'ModScope', required => 1);

=head2 mod

Name of module, e.g. brl.B<example>
=cut

has 'mod' => (is => 'rw', isa => 'Str', required => 1);

=head2 desc

Description of module
=cut

has 'desc' => (is => 'rw', isa => 'Str', required => 1);

=head2 source

Source location. Needs to be a class which does L<Maximus::Role::Module::Source>
=cut

has 'source' => (
    is       => 'rw',
    does     => 'Maximus::Role::Module::Source',
    required => 1
);

=head2 scm_settings

SCM specific settings
=cut

has 'scm_settings' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

=head2 schema

L<DBIx::Class schema>
=cut

has 'schema' => (is => 'rw', 'isa' => 'DBIx::Class::Schema');

=head1 METHODS

=head2 save

Save module in database
=cut

sub save {
    my ($self, $user_id) = @_;

    Maximus::Exception::Module->throw('schema is missing')
      unless $self->schema;

    Maximus::Exception::Module->throw(
        'required parameter $user_id is missing')
      unless $user_id;

    # A user can only upload a module for the given modscope if the modscope
    # belongs to the user or if it doesn't exist yet
    my $modscope =
      $self->schema->resultset('Modscope')
      ->single({name => $self->modscope,});

    if ($modscope && $user_id != $modscope->user_id) {
        Maximus::Exception::Module->throw(
            user_msg => 'This modscope doesn\'t belong to you');
    }
    elsif (!$modscope) {
        $modscope = $self->schema->resultset('Modscope')->create(
            {   name    => $self->modscope,
                user_id => $user_id,
            }
        );
    }

    my $mod = $self->schema->resultset('Module')->update_or_create(
        {   modscope_id  => $modscope->id,
            name         => $self->mod,
            desc         => $self->desc,
            scm_settings => $self->scm_settings,
        }
    );

    $self->source->prepare($self);
    $self->source->validate($self) unless $self->source->validated;

    my @deps = $self->source->findDependencies($self);

    my $fh = IO::File->new_tmpfile;
    my $filename = $self->source->archive($self, $fh);

    my $archive;
    while (<$fh>) {
        $archive .= $_;
    }

    my $version;
    $self->schema->txn_do(
        sub {
            $version =
              $self->schema->resultset('ModuleVersion')->update_or_create(
                {
                    module_id       => $mod->id,
                    version         => $self->source->version,
                    archive         => $archive,
                    remote_location => undef,
                }
              );

            $version->module_dependencies->delete;
            $self->schema->resultset('ModuleDependency')->create(
                {   module_version_id => $version->id,
                    modscope          => $_->[0],
                    modname           => $_->[1],
                }
            ) foreach @deps;
        }
    );

    Maximus::Exception::Module->throw('Unable to save module to database')
      unless $version;

    return $version;
}

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

__PACKAGE__->meta->make_immutable;
1;
