package Maximus::Task::SCM::Update;
use Moose;
use Maximus::Class::Module;
use namespace::autoclean;

with 'Maximus::Role::Task';
with 'Maximus::Role::Task::SCM';

=head1 NAME

Maximus::Task::SCM::Update - Update SCM configurations and modules

=head1 SYNOPSIS

	use Maximus::Task::SCM::Update;
	$task->run();

=head1 DESCRIPTION

Update module database.

=head1 METHODS

=head2 run

Run task
=cut

sub run {
    my ($self, $scm_id) = @_;
    my $search;
    if (ref($scm_id) eq 'ARRAY' && @{$scm_id} == 1
        or !ref($scm_id) && $scm_id > 0)
    {
        $search = {id => $scm_id};
    }

    # Fetch all or search for given SCM
    foreach my $scm ($self->schema->resultset('Scm')->search($search)) {
        my $source     = $self->get_source($scm);
        my $latest_rev = $source->get_latest_revision;
        if (!$scm->revision || !$latest_rev || $scm->revision ne $latest_rev)
        {
            foreach my $module ($scm->modules) {
                my %versions = $source->get_versions;

                # Skip existing versions
                delete $versions{$_->version}
                  for ($module->module_versions->all);

                # But always retrieve the latest dev version
                $versions{'dev'} = 1;
                foreach my $version (keys %versions) {

                    # New Source object
                    my $source = $self->get_source($scm);
                    if ($scm->software eq 'svn' && $module->scm_settings) {
                        if (exists $module->scm_settings->{trunk}) {
                            $source->trunk($module->scm_settings->{trunk});
                        }
                        if (exists $module->scm_settings->{tags}) {
                            $source->tags($module->scm_settings->{tags});
                        }
                        if (exists $module->scm_settings->{tags_filter}) {
                            $source->tags_filter(
                                $module->scm_settings->{tags_filter});
                        }
                    }

                    $source->version($version);
                    eval {
                        my $mod = Maximus::Class::Module->new(
                            modscope => $module->modscope->name,
                            mod      => $module->name,
                            desc     => $module->desc,
                            source   => $source,
                            schema   => $self->schema,
                        );
                        $mod->save($module->modscope->user_id);
                    };
                    warn $@ if $@;
                }
            }
        }

        $scm->update({revision => $latest_rev});
    }
    1;
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
