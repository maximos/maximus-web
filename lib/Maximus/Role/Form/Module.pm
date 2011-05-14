package Maximus::Role::Form::Module;
use HTML::FormHandler::Moose::Role;

has_field 'scope' => (
    type             => '+Maximus::FormField::AlNum',
    label            => 'Modscope',
    required         => 1,
    required_message => 'You must enter a modscope',
    maxlength        => 25,
    css_class        => 'required validate-alphanum minLength:1 maxLength:25',
);

has_field 'name' => (
    type             => '+Maximus::FormField::AlNum',
    label            => 'Name',
    required         => 1,
    required_message => 'You must enter a module name',
    maxlength        => 25,
    css_class        => 'required validate-alphanum minLength:1 maxLength:25',
);

has_field 'desc' => (
    type             => 'Text',
    label            => 'Description',
    required         => 1,
    required_message => 'You must enter a description',
    minLength        => 5,
    maxlength        => 255,
    css_class        => 'required minLength:5 maxLength:255',
);

no HTML::FormHandler::Moose::Role;

1;