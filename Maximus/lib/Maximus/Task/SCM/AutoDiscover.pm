package Maximus::Task::SCM::AutoDiscover;
use Moose;
use DateTime;
use namespace::autoclean;

with 'Maximus::Role::Task';
with 'Maximus::Role::Task::SCM';

=head1 NAME

Maximus::Task::SCM::AutoDiscover - Auto Discover modules from a SCM

=head1 SYNOPSIS

	use Maximus::Task::SCM::AutoDiscover;
	$task->run($scm_id); # SCM ID number
	$task->run($scm); # Maximus::Schema::Result::Scm

=head1 DESCRIPTION

Update module database.

=head1 METHODS

=head2 run

Run task
=cut

sub run {
    my ($self, $scm) = @_;
    unless (ref($scm) eq 'Maximus::Schema::Result::Scm') {
        $scm = $self->schema->resultset('Scm')->find({id => $scm});
    }

    my $source = $self->get_source($scm);
    $self->response([$source->auto_discover]);

    $scm->update(
        {   auto_discover_request  => DateTime->now(),
            auto_discover_response => $self->response,
        }
    );

    1;
}


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

__PACKAGE__->meta->make_immutable;
1;
