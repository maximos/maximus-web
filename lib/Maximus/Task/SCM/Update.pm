package Maximus::Task::SCM::Update;
use Moose;
use Maximus;
use Maximus::Class::Module;
use Maximus::Exceptions;
use namespace::autoclean;

with 'Maximus::Role::Task';
with 'Maximus::Role::Task::SCM';

sub run {
    my ($self, $args) = @_;
    my ($scm_id, $ignore_latest_rev, $search);

    if (defined($args)) {
        if (ref($args) eq 'ARRAY') {
            ($scm_id, $ignore_latest_rev) = @{$args};
            $ignore_latest_rev ||= 0;
        }
        elsif (!ref($args) && $args > 0) {
            $scm_id = $args;
        }
        $search = {id => $scm_id} if defined($scm_id);
    }

    my $announcer = Maximus->model('announcer');

    # Fetch all or search for given SCM
    foreach my $scm ($self->schema->resultset('Scm')->search($search)) {
        my $source = $self->get_source($scm);
        $source->apply_scm_settings($scm->settings) if ($scm->settings);

        my $latest_rev = $source->get_latest_revision;
        if (   !$scm->revision
            || !$latest_rev
            || $scm->revision ne $latest_rev
            || $ignore_latest_rev)
        {
            foreach my $module ($scm->modules) {

                # Reapply SCM settings
                $source->apply_scm_settings($scm->settings)
                  if ($scm->settings);

                # Module specific SCM settings
                $source->apply_scm_settings($module->scm_settings)
                  if ($module->scm_settings);

                my %versions = $source->get_versions;

                # Skip existing versions
                delete $versions{$_->version}
                  for ($module->module_versions->all);

                # But always retrieve the latest dev version
                $versions{'dev'} = 1;
                foreach my $version (keys %versions) {

                    # New Source object
                    my $source = $self->get_source($scm);

                    # Reapply scm settings to new Source object
                    $source->apply_scm_settings($scm->settings)
                      if ($scm->settings);
                    $source->apply_scm_settings($module->scm_settings)
                      if ($module->scm_settings);

                    $source->version($version);
                    eval {
                        my @users = $module->modscope->get_authors('mutable');
                        die('No authors assigned to this modscope')
                          unless @users;

                        my $mod = Maximus::Class::Module->new(
                            modscope     => $module->modscope->name,
                            mod          => $module->name,
                            desc         => $module->desc,
                            source       => $source,
                            scm_settings => $module->scm_settings,
                            schema       => $self->schema,
                            announcer    => $announcer,
                        );
                        $mod->save($users[0]);
                    };
                    my $e = Maximus::Exception::Module::Source->caught();
                    warn $e->user_msg if $e;
                    warn $@ if $@;
                }
            }
        }

        $scm->update({revision => $latest_rev});
    }
    Maximus->cache->remove($_) for (qw/sources_list sources_list_sv/);
    1;
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Task::SCM::Update - Update SCM configurations and modules

=head1 SYNOPSIS

    use Maximus::Task::SCM::Update;
    $task->run();

=head1 DESCRIPTION

Update module database.

=head1 METHODS

=head2 run

=head2 run($scm_id)

=head2 run($scm_id, $ignore_latest_rev)

Run task. Both 

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
