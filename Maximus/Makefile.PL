#!/usr/bin/env perl -w
use inc::Module::Install;

name 'Maximus';
all_from 'lib\Maximus.pm';

requires 'Catalyst::Runtime' => '5.8002';
requires 'Catalyst::Model::DBIC::Schema' => '0.40';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'DBIx::Class' => '0.08120';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General';
requires 'Archive::Extract' => '0.38';
requires 'Archive::Zip' => '1.30';
requires 'File::Find' => '';
requires 'File::Temp' => '0.22';
requires 'File::Copy::Recursive' => '0.38';
requires 'Gearman' => '1.11';
requires 'Gearman::Server' => '1.11';
requires 'JSON::Any' => '1.22';
requires 'SQL::Translator' => '0.11005';
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
