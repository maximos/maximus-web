package Maximus::Controller::Modules;
use Moose;
use namespace::autoclean;
use Maximus::Form::Module::Edit;

BEGIN { extends 'Catalyst::Controller'; }

sub auto : Private {
    my ($self, $c) = @_;

    if (!$c->user_exists) {
        $c->res->redirect(
            $c->uri_for($c->controller('Account')->action_for('login')));
        return 0;
    }

    return 1;
}

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    $c->stash(modscopes => [$c->user->obj->get_modscopes]);
}

sub edit : Local : Args(2) {
    my ($self, $c, $scope, $modname) = @_;

    my $rs = $c->model('DB::Module')->search(
        {   'modscope.name' => $scope,
            'me.name'       => $modname,
        },
        {   join     => 'modscope',
            prefetch => 'modscope',
        }
    );

    $c->detach('/error_404') unless $rs->count == 1;

    my $module = $rs->first;

    $c->detach('/error_403')
      unless $c->check_any_user_role(
              ('is_superuser',
                  'modscope-' . $module->modscope->id . '-mutable')
      );

    my $init_object = {
        scope  => $module->modscope->name,
        name   => $module->name,
        desc   => $module->desc,
        scm_id => $module->scm_id,
    };
    $init_object = {%$init_object, %{$module->scm_settings}};

    my $form = Maximus::Form::Module::Edit->new(
        {   init_object => $init_object,
            user        => $c->user->obj,
        }
    );

    $form->process($c->req->parameters);
    $c->stash(form => $form);

    if ($form->validated) {
        eval {
            $c->model('DB')->txn_do(
                sub {
                    my ($scm_id, $software);
                    if (int($form->field('scm_id')->value) > 0) {
                        my $scm =
                          $c->model('DB::SCM')
                          ->find({id => $form->field('scm_id')->value});

                        if ($scm) {
                            $scm_id   = $scm->id;
                            $software = $scm->software;
                        }
                    }

                    $module->update(
                        {   scm_id       => $scm_id,
                            scm_settings => {
                                map { $_->name => $_->value }
                                  grep { $_->name =~ m/^$software/; }
                                  $form->fields
                            },
                        }
                    );
                }
            );
        };

        if ($@) {
            $c->stash(error_msg => 'An unknown error occured!');
            $c->log->warn($@);
            $c->detach;
        }

        $c->flash(message => 'Your Module configuration has been stored.');
        $c->response->redirect($c->uri_for_action('/modules/index'));
    }
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Maximus::Controller::Modules - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller for managing a user's modules.

=head1 METHODS

=head2 index

=head2 edit

Edit module settings

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
