package Maximus::Role::Form::Account::Password;
use HTML::FormHandler::Moose::Role;

has_field 'password' => (
    type             => 'Password',
    label            => 'Password',
    required         => 1,
    required_message => 'You must enter a password',
    minlength        => 6,
    maxlength        => 50,
    css_class        => 'required minLength:6 maxLength:50',
);

no HTML::FormHandler::Moose::Role;

1;

