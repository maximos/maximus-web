#!/usr/bin/env perl -w
use inc::Module::Install;

name 'Maximus';
all_from 'lib/Maximus.pm';

requires 'Archive::Extract' => '0.38';
requires 'Archive::Zip' => '1.30';
requires 'Catalyst::Runtime' => '5.80024';
requires 'Catalyst::Model::DBIC::Schema' => '0.40';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Engine::PSGI' => '0.10';
requires 'Catalyst::Log::Log4perl' => '1.04';
requires 'Catalyst::Model::Adaptor' => '0.08';
requires 'Catalyst::Plugin::Assets' => '0.036';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Plugin::Cache';
requires 'Catalyst::Plugin::Compress::Zlib' => '0.01';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::PageCache';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::DBIC';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::RequireSSL' => '0.06';
requires 'Catalyst::View::Email' => '0.30';
requires 'Catalyst::View::TT';
requires 'Cache::Cache' => '1.06';
requires 'Config::General';
requires 'CSS::Minifier::XS' => '0.05';
requires 'DBD::mysql';
requires 'DBI';
requires 'DBIx::Class' => '0.08123';
requires 'DBIx::Class::Schema::Loader' => '0.07000';
requires 'Digest::SHA' => '5.48';
requires 'Email::Valid';
requires 'Exception::Class' => '1.30';
requires 'File::Find' => '';
requires 'File::Temp' => '0.22';
requires 'File::Copy::Recursive' => '0.38';
#We won't be using these yet, so no need to require them
#requires 'Gearman::Client' => '1.11';
#requires 'Gearman::Server' => '1.11';
requires 'HTML::FormHandler' => '0.32002';
requires 'HOP::Lexer' => '0.032';
requires 'JavaScript::Minifier::XS' => '0.07';
requires 'JSON::Any' => '1.22';
requires 'local::lib';
requires 'Log::Dispatch' => '2.26';
requires 'Log::Log4perl' => '1.28';
requires 'File::Type' => '0.22';
requires 'Moose';
requires 'MooseX::Storage' => '0.25';
requires 'namespace::autoclean';
requires 'Net::Twitter' => '3.13003';
requires 'Path::Class' => '0.19';
requires 'SQL::Translator' => '0.11006';
requires 'Template' => '2.22';
requires 'Template::Plugin::Digest::SHA1' => '0.03';
requires 'version';
requires 'XML::Simple' => '2.18';
test_requires 'Cache::Null' => '2.04';
test_requires 'DBD::SQLite' => '1.29';
test_requires 'Test::More' => '0.88';
test_requires 'Test::WWW::Mechanize::Catalyst' => '0.52';
recommends 'FCGI';
recommends 'FCGI::ProcManager';
recommends 'Plack' => '0.9938';
recommends 'Plack::Middleware::ReverseProxy' => '0.06';
recommends 'Starman' => '0.2004';
catalyst;
perl_version '5.010001';
license 'MIT';

requires_external_bin 'svn';
if($^O eq 'MSWin32') {
	die('Please install msysgit') unless -f 'C:\Program Files\Git\cmd\git.cmd';
}
else {
	requires_external_bin 'git'
}

install_script glob('script/*.pl');
auto_install;
WriteAll;
