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
$contents .= $_ for (<$fh>);
close($fh);

my @foundTokens    = $lexer->tokens($contents);
my @expectedTokens = (
    ['MODULENAME',        'test.mod1'],
    ['MODULEDESCRIPTION', 'some description'],
    ['MODULEVERSION',     '1.1.15'],
    ['DEPENDENCY',        'brl.basic'],
    ['DEPENDENCY',        'htbaapub.rest'],
    ['DEPENDENCY',        'brl.retro'],
    ['INCLUDE_FILE',      'inc/more_imports.bmx'],
    ['INCLUDE_FILE',      'inc/other_imports.bmx'],
);

# Helpful debug line
# diag pack('A15A*', $_->[0], $_->[1]), "\n" foreach(@foundTokens);

is_deeply(\@foundTokens, \@expectedTokens, 'Lexer found expected tokens');

$contents = '';
$contents .= $_ while (<DATA>);
@foundTokens    = $lexer->tokens($contents);
@expectedTokens = (
    ['MODULEDESCRIPTION', 'my description'],
    ['MODULENAME',        'some.test'],
    ['MODULEVERSION',     '1.00'],
    ['MODULEDESCRIPTION', 'MaxGUI/Localization'],
    ['MODULENAME',        'MaxGUI.Localization'],
);
is_deeply(\@foundTokens, \@expectedTokens, 'Lexer found expected tokens');

#diag pack('A15A*', $_->[0], $_->[1]), "\n" foreach(@foundTokens);


done_testing();

__DATA__
SuperStrict
Rem
    bbdoc: my description
End Rem
Module some.test
ModuleInfo "Name: some.test"
ModuleInfo "Version: 1.00"

Rem
bbdoc: MaxGUI/Localization
End Rem
Module MaxGUI.Localization
