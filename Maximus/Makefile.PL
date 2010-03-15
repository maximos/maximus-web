#!/usr/bin/env perl -w
use inc::Module::Install;

name 'Maximus';
all_from 'lib\Maximus.pm';

requires 'Catalyst::Runtime' => '5.80021';
requires 'Catalyst::Model::DBIC::Schema' => '0.40';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'DBIx::Class' => '0.08120';
requires 'DBD::mysql';
requires 'Digest::SHA' => '5.48';
requires 'Moose';
requires 'MooseX::Storage' => '0.25';
requires 'namespace::autoclean';
requires 'Config::General';
requires 'Archive::Extract' => '0.38';
requires 'Archive::Zip' => '1.30';
requires 'File::Find' => '';
requires 'File::Temp' => '0.22';
requires 'File::Copy::Recursive' => '0.38';
requires 'Gearman::Client' => '1.11';
requires 'Gearman::Server' => '1.11';
requires 'JSON::Any' => '1.22';
requires 'MongoDB' => '0.30';
requires 'SQL::Translator' => '0.11005';
requires 'Template' => '2.22';
requires 'XML::Simple' => '2.18';
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
