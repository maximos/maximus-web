package Maximus::Model::Announcer;
use strict;
use warnings;
use base 'Catalyst::Model::Adaptor';

__PACKAGE__->config( 
    class       => 'Maximus::Class::Broadcast::Announcer',
    constructor => 'new',
);

=head1 NAME

Maximus::Model::Announcer - Announcements from Maximus!

=head1 SYNOPSIS

See L<Maximus::Class::Broadcast::Announcer>

=head1 DESCRIPTION

This is a model using Maximus::Class::Broadcast::Announcer to announce messages
inside L<Catalyst> action.

=head1 METHODS

=head2 COMPONENT

=cut
sub COMPONENT {
	my($class, $app, $args) = @_;
	my $announcer = $class->SUPER::COMPONENT(@_);

	foreach my $driver_name(keys %{$args->{drivers}}) {
		my $module = 'Maximus::Class::Broadcast::Driver::' . $driver_name;
		eval {
			my $module = $module;
			$module =~ s/::/\//g;
			require $module . '.pm'
		};
		$app->log->warn($@) and next if($@);

		my %args = %{$args->{drivers}->{$driver_name}};
		my $listener = $module->new(\%args);
		$announcer->addListener($listener);
	}
	return $announcer;
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
1;
