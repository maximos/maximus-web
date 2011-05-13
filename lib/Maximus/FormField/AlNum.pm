package Maximus::FormField::AlNum;
use namespace::autoclean;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Field::Text';

apply [
    {   check => sub { shift !~ /[^a-z0-9]/i },
        message => 'Only alphanumerical values are accepted'
    }
];

__PACKAGE__->meta->make_immutable;

1;
