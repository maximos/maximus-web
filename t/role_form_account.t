use strict;
use warnings;
use Test::More;

{

    package TestForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler';
    with 'Maximus::Role::Form::Account::Email';
    with 'Maximus::Role::Form::Account::Username';
    with 'Maximus::Role::Form::Account::ConfirmPassword';
    with 'Maximus::Role::Form::Account::Password';
    1;
}

my $form = TestForm->new;

my $good = {
    email            => 'info@example.com',
    username         => 'Somename0123456789',
    password         => 'secret code',
    confirm_password => 'secret code',
};

ok($form->process(params => $good), 'Good data');
foreach (keys %{$good}) {
    is($form->field($_)->value, $good->{$_}, $_ . ' validated');
}

my $bad = {
    email            => 'info_example.com',
    username         => 'Somename0123456789@$ !+_-',
    password         => 'sec',
    confirm_password => 'not so secret code',
};

ok(!$form->process(params => $bad), 'Bad data');
foreach (keys %{$bad}) {
    ok($form->field($_)->has_errors, $_ . " has errors");
}

done_testing();

