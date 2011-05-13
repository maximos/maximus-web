package Maximus::Role::Form::Account::ConfirmPassword;
use HTML::FormHandler::Moose::Role;

has_field 'confirm_password' => (
    type             => 'PasswordConf',
    label            => 'Confirm password',
    required         => 1,
    required_message => 'You must confirm your password',
    css_class =>
      "required validate-match matchInput:'password' matchName:'password'",
);

no HTML::FormHandler::Moose::Role;

1;

