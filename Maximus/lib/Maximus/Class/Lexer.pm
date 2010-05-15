package Maximus::Class::Lexer;
use Moose;
use HOP::Lexer 'string_lexer';
use namespace::autoclean;

=head1 NAME

Maximus::Class::Lexer - BlitzMax Lexer

=head1 SYNOPSIS

	use Maximus::Class::Lexer;
	my $lexer = Maximus::Class::Lexer->new;
	my @tokens = $lexer->tokens('string');

=head1 DESCRIPTION

Provides a minimal BlitzMax lexer to retrieve information about dependant
modules and which files the module depends on.

=head1 METHODS


=head2 tokens(I<$input_iterator>)

Scan input and return a list with tokens
=cut
sub tokens {
	my($self, $input_iterator) = @_;
	my $lexer = string_lexer($input_iterator, (
		[ 'COMMENT', qr/'.*?\n/, sub {()} ],
		[ 'COMMENT', qr/[ \t]*\bRem\n(?:\n|.)*?\s*\bEnd[ \t]*Rem/i, sub {()} ],
		[ 'MODULENAME', qr/\bModule[\s\t]+\w+\.\w+/i, \&_text],
		[ 'MODULEVERSION', qr/\bModuleInfo[\s\t]+"Version: .+"/i, sub {
		  	my($label, $value) = @_;
		  	$value =~ /"Version: (.+)"/;
		  	[$label, $1]
		  }
		],
		[ 'DEPENDENCY', qr/\b(?i:Import|Framework)[\s\t]+\w+\.\w+/, \&_text],
		[ 'INCLUDE_FILE', qr/\b(?i:Import|Include)[\s\t]+".+\.bmx"/, sub {
		  	my($label, $value) = @_;
		  	$value =~ /"(.+)"/;
		  	[$label, $1]
		  }
		],
	));
	
	my @tokens;
	while(my $token = $lexer->()) {
		next unless ref($token) eq 'ARRAY';
		push @tokens, $token;
	}
	return @tokens;
}

=head2 _text

Private subroutine
=cut
sub _text {
	my($label, $value) = @_;
	my @values = split(/\s/, $value);
	[$label, $values[1]]
}

=head1 SEE ALSO

L<HOP::Lexer>

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
