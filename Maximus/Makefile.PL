#!/usr/bin/env perl -w
use inc::Module::Install;

name 'Maximus';
all_from 'lib\Maximus.pm';

requires 'Catalyst::Runtime' => '5.8002';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General';
requires 'Archive::Builder' => '1.14';
test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
