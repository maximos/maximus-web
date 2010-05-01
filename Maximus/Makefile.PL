#!/usr/bin/env perl -w
use inc::Module::Install;

name 'Maximus';
all_from 'lib/Maximus.pm';

requires 'Catalyst::Runtime' => '5.80022';
requires 'Catalyst::Model::DBIC::Schema' => '0.40';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::DBIC';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Plugin::RequireSSL' => '0.06';
requires 'Catalyst::View::TT';
requires 'DBIx::Class' => '0.08120';
requires 'DBIx::Class::Schema::Loader' => '0.06001';
requires 'DBI';
requires 'DBD::mysql';
requires 'Digest::SHA' => '5.48';
requires 'Exception::Class' => '1.30';
requires 'FCGI';
requires 'FCGI::ProcManager';
requires 'Moose';
requires 'MooseX::Storage' => '0.25';
requires 'namespace::autoclean';
requires 'Config::General';
requires 'Archive::Extract' => '0.38';
requires 'Archive::Zip' => '1.30';
requires 'Email::Valid';
requires 'File::Find' => '';
requires 'File::Temp' => '0.22';
requires 'File::Copy::Recursive' => '0.38';
#We won't be using these yet, so no need to require them
#requires 'Gearman::Client' => '1.11';
#requires 'Gearman::Server' => '1.11';
requires 'JSON::Any' => '1.22';
requires 'HTML::FormHandler' => '0.30003';
requires 'JSON::Any' => '1.22';
requires 'SQL::Translator' => '0.11005';
requires 'Template' => '2.22';
requires 'version';
requires 'XML::Simple' => '2.18';
test_requires 'Test::More' => '0.88';
test_requires 'Test::WWW::Mechanize::Catalyst' => '0.52';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
