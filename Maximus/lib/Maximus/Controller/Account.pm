package Maximus::Controller::Account;
use Digest::SHA qw(sha1_hex);
use Moose;
use namespace::autoclean;
use Maximus::Form::Account::Edit;
use Maximus::Form::Account::ForgotPassword;
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

		$c->stash(username => $form->field('username')->value);
		$c->stash(email => {
			to => $form->field('email')->value,
			from => $c->config->{email}->{from},
			subject => 'Account registration',
			template => 'account/email/signup.tt',
		});

		$c->forward( $c->view('Email::Template') );
		if(scalar(@{$c->error})) {
			$c->log->warn('Failed to send a mail: ', @{$c->error});
			$c->error(0);
		}

		$c->detach('/account/login');
	}
}

=head2 forgot_password

=cut
sub forgot_password : Local {
	my ($self, $c) = @_;
	
	my $form = Maximus::Form::Account::ForgotPassword->new;
	$form->process( $c->req->parameters );
	$c->stash(form => $form);

	if($form->validated) {
		my $user = $c->model('DB::User')->find({
			username => $form->field('username')->value
		});
		if($user) {
			$c->stash(
				email => {
					to => $user->email,
					from => $c->config->{email}->{from},
					subject => 'Please confirm you forgot your password',
					template => 'account/email/forgot_password.tt',
				},
				user => $user,
			);

			$c->forward( $c->view('Email::Template') );
			if(scalar(@{$c->error})) {
				$c->log->warn('Failed to send a mail: ', @{$c->error});
				$c->error(0);
				$c->stash(error_msg => 'Failed to send a confirmation e-mail ' .
									   'because an unexpected error occured. ' .
									   'We\'ve been notified. Please try ' . 
									   'again later.');
				$c->detach;
			}

			$c->stash(
				template => 'message.tt',
				title => 'Confirmation e-mail sent',
				message => 'A e-mail has been sent with a confirmation link. '.
						   'Please check your e-mail for instructions.',
			);
		}
		else {
			$c->stash(error_msg => 'No such user exists.');
		}
	}
}

=head2 reset_password

Expects a username and a hash. If the hash is faulty nothing will happen. After
this action has been succesfully executed the link will be expired because the
password has been changed.
=cut
sub reset_password : Path('reset_password') : Args(2) {
	my ($self, $c, $username, $hash) = @_;
	my $user = $c->model('DB::User')->find({username => $username});
	
	if($user) {
		my $calc_hash = sha1_hex( $user->password . $c->config->{salt} . $user->id );
		if($calc_hash eq $hash) {
			my $password = substr(sha1_hex($c->config->{salt} . $user->id), 0, 8);
			$user->update( {password => sha1_hex( $password ) } );
			
			$c->stash(
				email => {
					to => $user->email,
					from => $c->config->{email}->{from},
					subject => 'Your new password',
					template => 'account/email/reset_password.tt',
				},
				user => $user,
				password => $password,
			);

			$c->forward( $c->view('Email::Template') );
			if(scalar(@{$c->error})) {
				$c->log->warn('Failed to send a mail: ', @{$c->error});
				$c->error(0);
				$c->stash(error_msg => 'Failed to send you your new password ' .
									   'because an unexpected error occured. ' .
									   'We\'ve been notified. Please try ' . 
									   'again later.');
				$c->detach;
			}
			
			$c->authenticate({
				username => $user->username,
				password => $password,
			});
			
			$c->stash(
				template => 'message.tt',
				title => 'Your password has been reset',
				message => 'A e-mail has been sent with your new password. '.
						   'Please update it as soon as possible. You\'ve ' . 
						   'been automatically logged in.',
			);
			$c->detach;
		}
	}
	
	$c->log->info('Attempt at faulty password reset for username ' . $username .
				  ' with hash ' . $hash);
	$c->detach('/default');
}

=head2 edit

Edit account details
=cut
sub edit : Local {
	my ($self, $c) = @_;
	$c->response->redirect('login') unless $c->user_exists;
	$c->require_ssl;
	
	my $form = Maximus::Form::Account::Edit->new({
		init_object => {
			email => $c->user->email,
		}
	});

	$form->process( $c->req->parameters );
	$c->stash(form => $form);

	if($form->validated) {
		eval {
			my $user = $c->model('DB::User')->find({username => $c->user->username});
			$user->update({
				email => $form->field('email')->value,
				password => sha1_hex($form->field('password')->value),
			});
		};
		if($@) {
			$c->stash(error_msg => 'An unknown error occured!');
			$c->log->info($@);
			$c->detach;
		}
	
		$c->stash(
			template => 'message.tt',
			title => 'Your details have been updated',
			message => 'Your account details have been updated. If you\'ve '.
					   'changed your password remember to sign in with your ' . 
					   'new password the next time you visit our website.',
		);
		$c->detach;
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

