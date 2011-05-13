package Maximus::Role::Form::Account::Password;
use HTML::FormHandler::Moose::Role;

has_field 'password' => (
    type             => 'Password',
    label            => 'Password',
    required         => 1,
    required_message => 'You must enter a password',
    minlength        => 6,
    maxlength        => 50,
);

has_field 'confirm_password' => (
    type             => 'PasswordConf',
    label            => 'Confirm password',
    required         => 1,
    required_message => 'You must confirm your password',
);

no HTML::FormHandler::Moose::Role;

1;

