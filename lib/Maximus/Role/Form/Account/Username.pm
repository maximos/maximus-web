package Maximus::Role::Form::Account::Username;
use HTML::FormHandler::Moose::Role;

has_field 'username' => (
    type             => '+Maximus::FormField::AlNum',
    label            => 'Username',
    required         => 1,
    required_message => 'You must enter a username',
    minlength        => 3,
    maxlength        => 25,
    css_class        => 'required validate-alphanum minLength:3 maxLength:25',
);

no HTML::FormHandler::Moose::Role;

1;


