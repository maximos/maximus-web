use strict;
use warnings;
use Test::More;
use FindBin qw/$Bin/;

BEGIN { use_ok 'HOP::Lexer' }
BEGIN { use_ok 'Maximus::Class::Lexer' }

my $lexer = new_ok('Maximus::Class::Lexer');
can_ok($lexer, qw/tokens/);

my $file = "$Bin/data/test.mod1/mod1.bmx";
ok(-e $file, 'Test file exists');

open(my $fh, $file);
ok($fh, 'Test file opened');
my $contents;
$contents .= $_ for(<$fh>);
close($fh);

my @foundTokens = $lexer->tokens($contents);
my @expectedTokens = (
	['MODULENAME', 'test.mod1'],
	['DEPENDENCY', 'brl.basic'],
	['DEPENDENCY', 'htbaapub.rest'],
	['DEPENDENCY', 'brl.retro'],
	['INCLUDE_FILE', 'inc/more_imports.bmx'],
	['INCLUDE_FILE', 'inc/other_imports.bmx'],
);

# Helpful debug line
# print pack('A15A*', $_->[0], $_->[1]), "\n" foreach(@foundTokens);

is_deeply(\@foundTokens, \@expectedTokens, 'Lexer found expected tokens');

done_testing();
