package Maximus::Controller::SCM;
use Moose;
use namespace::autoclean;
use Maximus::Form::SCM::Configuration;
use Maximus::Form::SCM::AutoDiscover;
use Maximus::Task::SCM::AutoDiscover;

BEGIN { extends 'Catalyst::Controller'; }

sub base : Chained('/') : PathPart('scm') : CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->response->redirect('/account/login') && $c->detach
      unless $c->user_exists;
}

sub index : Chained('base') : PathPart('') : Args(0) {
    my ($self, $c) = @_;
    my @scms = $c->user->obj->get_scms;
    $c->stash(scm_configs => \@scms);
}

sub form : Private {
    my ($self, $c) = @_;

    my ($init_object, $scm) = {};
    if ($scm = $c->stash->{scm}) {
        $init_object = {
            software => $c->stash->{scm}->software,
            repo_url => $c->stash->{scm}->repo_url,
            modules  => [map { $_->id } $c->stash->{scm}->modules],
        };
    }

    my $form = Maximus::Form::SCM::Configuration->new(
        {   init_object => $init_object,
            user        => $c->user->obj,
        }
    );

    $form->process($c->req->parameters);
    $c->stash(
        form     => $form,
        template => 'scm/configuration.tt'
    );

    if ($form->validated) {
        $c->model('DB')->txn_do(
            sub {
                my %data = (
                    software => $form->field('software')->value,
                    repo_url => $form->field('repo_url')->value,
                    settings => '',
                );
                if ($scm) {
                    $scm->update(\%data);
                    $scm->modules->update({scm_id => undef});
                    $c->model('DB::Module')
                      ->search({id => [@{$form->field('modules')->value}]})
                      ->update({scm_id => $scm->id});
                }
                else {
                    $scm = $c->model('DB::SCM')->create(\%data);
                }

                $c->user->obj->find_or_create_related('user_roles',
                    {role_id => $scm->get_role('mutable')->id});
            }
        );
        if ($@) {
            $c->stash(error_msg => 'An unknown error occured!');
            $c->log->warn($@);
            $c->detach;
        }

        $c->flash(message => 'Your SCM Configuration has been stored.');
        $c->response->redirect($c->uri_for_action('/scm/index'));
    }
}

sub add : Chained('base') : PathPart('new') : Args(0) {
    my ($self, $c) = @_;
    $c->forward('form');
}

sub get_scm : Chained('base') : PathPart('') : CaptureArgs(1) {
    my ($self, $c, $scm_id) = @_;
    my $scm = $c->model('DB::SCM')->find({id => $scm_id});
    $c->detach('/error_404') unless $scm;
    $c->detach('/error_403')
      unless $c->user_exists
          && $c->check_any_user_role(
              ('is_superuser', 'scm-' . $scm->id . '-mutable')
          );
    $c->stash('scm' => $scm);
}

sub edit : Chained('get_scm') : PathPart('edit') : Args(0) {
    my ($self, $c) = @_;
    $c->forward('form');
}

sub delete : Chained('get_scm') : PathPart('delete') : Args(0) {
    my ($self, $c) = @_;

    eval { $c->stash->{scm}->delete; };
    if ($@) {
        $c->flash(
            message => 'Failed to delete your SCM Configuration.',
            status  => 'Error',
        );
        $c->log->warn($@);
    }
    else {
        $c->flash(message => 'Your SCM Configuration has been deleted.');
    }
    $c->response->redirect($c->uri_for_action('/scm/index'));
}

sub autodiscover : Chained('get_scm') : PathPart('autodiscover') : Args(0) {
    my ($self, $c) = @_;

    my $scm = $c->stash->{scm};
    if (   length($scm->get_column('auto_discover_request')) == 0
        && length($scm->get_column('auto_discover_response')) == 0
        || exists $c->req->query_params->{refresh})
    {
        my $task = Maximus::Task::SCM::AutoDiscover->new(queue => 1);
        my $task_id = $task->run($scm->id);
        if ($task_id) {
            $scm->update({auto_discover_response => {task_id => $task_id}});
            $c->log->info('Task fired with ID: ' . $task_id);
        }
        else {
            $c->log->error(
                'Failed to fire task ' . ref($task) . ' for SCM ' . $scm->id);
        }
        return $c->response->redirect(
            $c->uri_for($self->action_for('autodiscover'), [$scm->id]));
    }

    my $init_object = {};
    if ($scm->auto_discover_request
        && ref($scm->auto_discover_response) eq 'ARRAY')
    {
        my @modules;
        foreach (@{$scm->auto_discover_response}) {
            push @modules,
              {modscope => $_->[0], mod => $_->[1], desc => undef};
        }
        $init_object = {modules => \@modules};
    }

    my $form = Maximus::Form::SCM::AutoDiscover->new(
        {   init_object => $init_object,
            user        => $c->user->obj,
        }
    );

    $form->process($c->req->parameters);
    $c->stash(form => $form);

    if ($form->validated) {
        my (@error_msgs, @modules_added, @modules_skipped);
        foreach my $form_module ($form->field('modules')->fields) {
            my $module_name = sprintf('%s.%s',
                $form_module->field('modscope')->value,
                $form_module->field('mod')->value);
            $c->model('DB')->txn_do(
                sub {
                    my $module = Maximus::Class::Module->new(
                        modscope => $form_module->field('modscope')->value,
                        mod      => $form_module->field('mod')->value,
                        desc     => $form_module->field('desc')->value || '',
                        schema   => $c->model('DB')->schema,
                    );
                    my $mod = $module->save($c->user->obj);
                    $mod->update({scm_id => $scm->id});
                    push @modules_added, $module_name;
                }
            );
            my $e;
            if ($e = Maximus::Exception::Module->caught()) {
                push @error_msgs,
                  $e->user_msg || 'An unexpected error occured.';
            }
            elsif ($@) {
                push @error_msgs, 'An unkown error occured.';
                $c->log->info($@) if ($@);
            }

            $c->log->info($e->error) if ($e);

            if ($e || $@) {
                push @modules_skipped, $module_name;
            }
        }

        $c->log->warn($_) for (@error_msgs);
        $c->stash(
            {   modules_added   => \@modules_added,
                modules_skipped => \@modules_skipped,
            }
        );
        $c->stash(template => 'scm/autodiscover_added.tt');
    }
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Controller::SCM - SCM configuration management

=head1 DESCRIPTION

This controller is responsible for managing a users' SCM configurations.

=head1 METHODS

=head2 base

=head2 index

Display overview of SCM configurations

=head2 form

Handle the configuration form

=head2 new

Add a new SCM configuration

=head2 get_scm

Retrieve a SCM record

=head2 edit

Edit a SCM configuration

=head2 delete

Delete a SCM configuration

=head2 autodiscover

Autodiscover modules inside a SCM repository.
Force firing a new task by adding the I<refresh> param.
The result can be used to automatically add all the modules to the Maximus
database.

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
