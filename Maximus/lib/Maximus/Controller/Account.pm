package Maximus::Controller::Account;
use Digest::SHA qw(sha1_hex);
use Moose;
use namespace::autoclean;
use Maximus::Form::Account::Login;
use Maximus::Form::Account::Signup;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Maximus::Controller::Account - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller to manage accounts

=head1 METHODS

=cut

=head2 index

=cut
sub index :Path :Args(0) {
	my ( $self, $c ) = @_;
	# Require user to be logged in
	$c->response->redirect('login') unless $c->user_exists;
}

=head2 login

=cut

sub login :Local {
    my ( $self, $c ) = @_;
    
	if($c->user_exists) {
		$c->res->redirect($c->uri_for(
			$c->controller('Account')->action_for('index')));
		return;
	}
    
	$c->require_ssl;
	
	my $form = Maximus::Form::Account::Login->new;
	$form->process( $c->req->parameters );
	$c->stash(form => $form);

	if($form->validated) {
		if($c->authenticate({username => $form->field('username')->value,
							 password => $form->field('password')->value } )) {
			# If successful, then let them use the application
			$c->response->redirect($c->uri_for(
				$c->controller('Account')->action_for('index')));
			return;
		}
		else {
			$c->stash(error_msg => 'Bad username or password.');
		}
	}
}

=head2 logout

=cut
sub logout :Local {
	my ($self, $c) = @_;
	$c->logout;
	$c->response->redirect($c->uri_for('/'));
}


=head2 signup

=cut
sub signup :Local {
	my ($self, $c) = @_;
	
	if($c->user_exists) {
		$c->res->redirect($c->uri_for(
			$c->controller('Account')->action_for('index')));
		return;
	}
	
	$c->require_ssl;
	
	my $form = Maximus::Form::Account::Signup->new;
	$form->process( $c->req->parameters );
	$c->stash(form => $form);

	if($form->validated) {
		my $user = $c->find_user({username => $form->field('username')->value}, 'website');
		
		if($user) { 
			$c->stash(error_msg => 'Username already taken.');
			$c->detach;
		}
		
		eval {
			$c->model('DB::User')->create({
				email => $form->field('email')->value,
				username => $form->field('username')->value,
				password => sha1_hex($form->field('password')->value),
			});
		};
		if($@) {
			$c->stash(error_msg => 'An unknown error occured!');
			$c->log->info($@);
			$c->detach;
		}

		$c->stash->{username} = $form->field('username')->value;
		$c->stash->{email} = {
			to => $form->field('email')->value,
			from => $c->config->{email}->{from},
			subject => 'Account registration',
			template => 'account/email/signup.tt',
		};

		$c->forward( $c->view('Email::Template') );
		if(scalar(@{$c->error})) {
			$c->log->warn('Failed to send a mail: ', $@);
			$c->error(0);
		}

		$c->detach('/account/login');
	}
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

