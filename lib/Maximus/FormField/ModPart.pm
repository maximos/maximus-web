package Maximus::FormField::ModPart;
use namespace::autoclean;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Field::Text';

apply [
    {   check => sub { shift !~ /[^a-z0-9_]/i },
        message => 'Only alphanumerical values and \'_\' are accepted'
    }
];

__PACKAGE__->meta->make_immutable;

1;
