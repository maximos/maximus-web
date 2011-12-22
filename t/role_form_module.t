use strict;
use warnings;
use Test::More;

{

    package TestForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler';
    with 'Maximus::Role::Form::Module';
    1;
}

my $form = TestForm->new;

my $good = {
    scope => 'test_1',
    name  => 'test_2',
    desc  => 'some description',
};

ok($form->process(params => $good), 'Good data');
foreach (keys %{$good}) {
    is($form->field($_)->value, $good->{$_});
}

my $bad = {
    scope => 'test#12!@',
    name  => '$.d2)dk',
    desc  => 'a' x 256,
};

ok(!$form->process(params => $bad), 'Bad data');
foreach (keys %{$bad}) {
    ok($form->field($_)->has_errors, $_ . " has errors");
}

done_testing();

