use strict;
use warnings;
use local::lib;
use lib './lib';
use Maximus;
use Plack::Builder;
use Plack::Middleware::ReverseProxy;

my $app = Maximus->psgi_app(@_);
$app = Plack::Middleware::ReverseProxy->wrap($app);
