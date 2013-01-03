package Maximus::Task::Module::Upload;
use Moose;
use File::Temp;
use namespace::autoclean;

with 'Maximus::Role::Task';

has 'transporter' => (
    is         => 'ro',
    does       => 'Maximus::Role::Transport',
    builder    => '_transport_builder',
    lazy_build => 1,
);

sub run {
    my ($self, $module_version) = @_;
    unless (ref($module_version) eq 'Maximus::Schema::Result::ModuleVersion')
    {
        $module_version =
          $self->schema->resultset('ModuleVersion')
          ->find({id => $module_version});
    }

    return 1 if ($module_version->remote_location);

    my $tmp_file = File::Temp->new();
    open my $fh, '>', $tmp_file or die('Failed to open tmp file');
    binmode $fh;
    print $fh $module_version->get_column('archive');
    close $fh;

    my $filename = sprintf('%s-%s-%s.zip',
        $module_version->module->modscope->name,
        $module_version->module->name,
        $module_version->version);

    my $remote_location =
      $self->transporter->transport($tmp_file->filename, $filename);
    unlink $tmp_file;

    $module_version->update({remote_location => $remote_location,});
    $self->response($remote_location);
    1;
}

sub _transport_builder {
    my $self   = shift;
    my $driver = $self->cfg->{Transport}->{driver};
    my %args   = %{$self->cfg->{Transport}->{options}};

    my $module = 'Maximus::Class::Transport::' . $driver;
    eval {
        my $module = $module;
        $module =~ s/::/\//g;
        require $module . '.pm';
    };
    die($@) if ($@);

    my $transporter = $module->new(\%args);
    return $transporter;
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Task::Module::Upload - Upload module archive for persistent storage

=head1 SYNOPSIS

    use Maximus::Task::Module::Upload;
    $task->run($module_version_id); # Module Version ID number
    $task->run($module_version); # Maximus::Schema::Result::ModuleVersion

=head1 DESCRIPTION

Upload module archive for persistent storage.

=head1 ATTRIBUTES

=head2 transporter

Transport driver

=head1 METHODS

=head2 run

Run task

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
