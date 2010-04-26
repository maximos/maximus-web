package Maximus::Controller::Module::Upload;
use Moose;
use namespace::autoclean;
use Maximus::Class::Module;
use Maximus::Class::Module::Source::Archive;
use Maximus::Form::Module::Upload;
use Maximus::Task::Module::Update;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Maximus::Controller::Module::Upload - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 auto

auto makes sure the user is logged in before doing anything
=cut
sub auto :Private {
	my ( $self, $c ) = @_;
	
	if(!$c->user_exists) {
		$c->res->redirect($c->uri_for(
			$c->controller('Account')->action_for('login')));
		return 0;
	}
	
	return 1;
}

=head2 index

=cut

sub index :Path :Args(0) {
	my ( $self, $c ) = @_;

	my $form = Maximus::Form::Module::Upload->new; 

	my $params = $c->req->parameters;
	$params->{file} = $c->req->upload('file') if $c->req->method eq 'POST';
     
	$form->process($params);
	$c->stash(form => $form);

	if($form->validated) {
		my $ok;
		eval {
			my $file = $c->req->upload('file');
				$c->model('DB')->txn_do(sub {
				my $source = Maximus::Class::Module::Source::Archive->new(
					file => $file->tempname,
				);
		    	
				my $module = Maximus::Class::Module->new(
					modscope => $form->field('scope')->value,
					mod => $form->field('name')->value,
					desc => $form->field('desc')->value,
					source => $source,
					schema => $c->model('DB')->schema,
		    	);
		    	$ok = $module->save($c->user->get('id'));
			});
		};
		if($@ || $ok != 1) {
			$c->stash(
				error_msg => $ok || 'An unxpected error occured. Perhaps your '.
									'module is faulty. If this problem keeps '.
									'showing up then please contact us.'
			);
			$c->log->info($@) if($@);
			$c->detach;
		}

		$c->stash(template => 'module/upload/done.tt');
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

