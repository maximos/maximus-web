use strict;
use warnings;
use Test::More;
use 5.10.1;

BEGIN {
    plan skip_all => 'Set TEST_TWITTER_CONSUMER_KEY to run this test'
      unless defined( $ENV{TEST_TWITTER_CONSUMER_KEY} );
    plan skip_all => 'Set TEST_TWITTER_CONSUMER_SECRET to run this test'
      unless defined( $ENV{TEST_TWITTER_CONSUMER_SECRET} );
    plan skip_all => 'Set TEST_TWITTER_ACCESS_TOKEN to run this test'
      unless defined( $ENV{TEST_TWITTER_ACCESS_TOKEN} );
    plan skip_all => 'Set TEST_TWITTER_ACCESS_TOKEN_SECRET to run this test'
      unless defined( $ENV{TEST_TWITTER_ACCESS_TOKEN_SECRET} );
}

BEGIN { use_ok 'Maximus::Class::Broadcast::Driver::Twitter' }
BEGIN { use_ok 'Maximus::Class::Broadcast::Message' }
BEGIN { use_ok 'Net::Twitter' }

my %auth = (
    consumer_key        => $ENV{TEST_TWITTER_CONSUMER_KEY},
    consumer_secret     => $ENV{TEST_TWITTER_CONSUMER_SECRET},
    access_token        => $ENV{TEST_TWITTER_ACCESS_TOKEN},
    access_token_secret => $ENV{TEST_TWITTER_ACCESS_TOKEN_SECRET},
);
diag $_, ": ", $auth{$_} for ( keys %auth );

my $nt = new_ok 'Net::Twitter' => [
    (
        traits              => [ 'OAuth', 'API::REST' ],
        consumer_key        => $auth{consumer_key},
        consumer_secret     => $auth{consumer_secret},
        access_token        => $auth{access_token},
        access_token_secret => $auth{access_token_secret},
    )
];

# Construct driver with Net::Twitter object
my $driver =
  new_ok( 'Maximus::Class::Broadcast::Driver::Twitter' => [ ( nt => $nt ) ] );
isa_ok( $driver->nt, 'Net::Twitter' );

my $msg =
  new_ok( 'Maximus::Class::Broadcast::Message' =>
      [ ( text => '1st test of Maximus::Class::Broadcast::Driver::Twitter', ) ]
  );
my $res = $driver->say($msg);
ok( $res->{id}, 'First test message sent OK' );
$driver->nt->destroy_status( $res->{id} );

# Let the driver construct the Net::Twitter object
$driver = new_ok( 'Maximus::Class::Broadcast::Driver::Twitter' => [ \%auth ] );
isa_ok( $driver->nt, 'Net::Twitter' );

$msg =
  new_ok( 'Maximus::Class::Broadcast::Message' =>
      [ ( text => '2nd test of Maximus::Class::Broadcast::Driver::Twitter', ) ]
  );
$res = $driver->say($msg);
ok( $res->{id}, 'Second test message sent OK' );
$driver->nt->destroy_status( $res->{id} );
done_testing();
