use strict;
use warnings;
use local::lib;
use lib './lib';
use Maximus;
use Plack::Builder;
use Plack::Middleware::ReverseProxy;
Maximus->setup_engine('PSGI');

my $app = sub {
        Maximus->run(@_)
};
$app = Plack::Middleware::ReverseProxy->wrap($app);
