package Maximus::Role::Form::Account::Email;
use HTML::FormHandler::Moose::Role;

has_field 'email' => (
    type             => 'Email',
    label            => 'E-Mail',
    required         => 1,
    required_message => 'You must enter a e-mail address',
    maxlength        => 45,
);

no HTML::FormHandler::Moose::Role;

1;
