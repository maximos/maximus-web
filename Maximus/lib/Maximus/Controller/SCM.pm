package Maximus::Controller::SCM;
use Moose;
use namespace::autoclean;
use Maximus::Form::SCM::Configuration;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Maximus::Controller::SCM - SCM configuration management

=head1 DESCRIPTION

This controller is responsible for managing a users' SCM configurations.

=head1 METHODS

=head2 base

=cut
sub base :Chained('/') :PathPart('scm') :CaptureArgs(0) {
	my( $self, $c ) = @_;
	$c->response->redirect('/account/login') && $c->detach unless $c->user_exists;
}

=head2 index

Display overview of SCM configurations
=cut
sub index :Chained('base') :PathPart('') :Args(0) {
	my( $self, $c ) = @_;
	my @scms = $c->user->scms;
	$c->stash( scm_configs => \@scms );
}

=head2 form

Handle the configuration form
=cut
sub form :Private {
	my( $self, $c ) = @_;
	$c->stash();
	
	my($init_object, $scm) = {};
	if($scm = $c->stash->{scm}) {
		$init_object = {
			'software' => $c->stash->{scm}->software,
			'repo_url' => $c->stash->{scm}->repo_url,
		};
	}
	
	my $form = Maximus::Form::SCM::Configuration->new({
		init_object => $init_object,
	});
	
	$form->process( $c->req->parameters );
	$c->stash(
		form => $form,
		template => 'scm/configuration.tt'
	);
	
	if($form->validated) {
		eval {
			$c->model('DB::SCM')->update_or_create({
				id => $scm ? $scm->id : undef,
				user_id => $c->user->id,
				software => $form->field('software')->value,
				repo_url => $form->field('repo_url')->value,
				settings => '',
			}, {key => 'primary'});
			
		};
		if($@) {
			$c->stash(error_msg => 'An unknown error occured!');
			$c->log->warn($@);
			$c->detach;
		}

		$c->stash(
			template => 'message.tt',
			title => 'SCM Configuration',
			success_message => 'Your SCM Configuration has been stored.',
		);
		$c->detach;
	}
}

=head2 new

Add a new SCM configuration
=cut
sub add :Chained('base') :PathPart('new') :Args(0) {
	my( $self, $c ) = @_;
	$c->forward('form');
}

=head2 get_scm

Retrieve a SCM record
=cut
sub get_scm :Chained('base') :PathPart('') :CaptureArgs(1) {
	my( $self, $c, $scm_id ) = @_;
	my $scm = $c->model('DB::SCM')->find({id => $scm_id});
	$c->detach('/error_404') unless $scm;
	$c->detach('/error_403') unless( $c->user->id == $scm->user_id);
	$c->stash('scm' => $scm);
}

=head2 edit

Edit a SCM configuration
=cut
sub edit :Chained('get_scm') :PathPart('edit') :Args(0) {
	my( $self, $c ) = @_;
	$c->forward('form');
}

=head2 delete

Delete a SCM configuration
=cut
sub delete :Chained('get_scm') :PathPart('delete') :Args(0) {
	my( $self, $c ) = @_;
	$c->stash('title' => 'Delete SCM Configuration');
	
	eval {
		$c->stash->{scm}->delete;
	};
	if($@) {
		$c->stash(
			template => 'message.tt',
			error_message => 'Failed to delete your SCM Configuration.',
		);
		$c->log->warn($@);
		$c->detach;
	}

	$c->stash(
		template => 'message.tt',
		success_message => 'Your SCM Configuration has been deleted.',
	);
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
