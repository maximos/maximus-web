use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Maximus::Class::Broadcast::Driver::Log4perl' }
BEGIN { use_ok 'Maximus::Class::Broadcast::Message' }
BEGIN { use_ok 'Log::Log4perl', qw(:easy) }

my $logger   = Log::Log4perl->get_logger();
my $appender = Log::Log4perl::Appender->new('Log::Log4perl::Appender::String',
    name => 'test');
my $layout = Log::Log4perl::Layout::PatternLayout->new('%m');
$appender->layout($layout);
$logger->add_appender($appender);
$logger->level($INFO);

my $driver = new_ok(
    'Maximus::Class::Broadcast::Driver::Log4perl' => [(logger => $logger)]);
my $msg =
  new_ok('Maximus::Class::Broadcast::Message' => [(text => 'Hello world!',)]);
$driver->say($msg);
is($appender->string(), $msg->text, 'Message got logged');

# Reset string
$appender->string('');
$logger->level($WARN);
$driver->say($msg);
isnt($appender->string, $msg->text, 'Message didn\'t get logged');

# Driver should construct its own Log::Log4perl::Logger if not supplied
$driver = new_ok('Maximus::Class::Broadcast::Driver::Log4perl');
isa_ok($driver->logger, 'Log::Log4perl::Logger');

done_testing();
