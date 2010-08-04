#!/usr/bin/perl
use strict;
use warnings;
use local::lib;
use lib './lib';
use Config::Any;
use Digest::SHA qw(sha1_hex);
use File::Spec;
use File::Path qw(make_path);
use Maximus::Schema;
use Maximus::Class::Module;
use Maximus::Class::Module::Source::SCM::Git;
use Maximus::Class::Module::Source::SCM::Subversion;
use Path::Class;

my $cfg = Config::Any->load_files({
	files => ['maximus.conf'],
	use_ext => 1,
	flatten_to_hash => 1,
})->{'maximus.conf'};

my $schema = Maximus::Schema->connect( $cfg->{'Model::DB'}->{connect_info} );

foreach my $scm( $schema->resultset('Scm')->all ) {
	my($source, $latest_rev);
	my $local_repo = Path::Class::Dir->new(File::Spec->tmpdir(), $cfg->{name}, 'repositories', sha1_hex($scm->repo_url));
	make_path($local_repo->absolute->stringify);
	
	if($scm->software eq 'git') {
		$source = Maximus::Class::Module::Source::SCM::Git->new(
			repository => $scm->repo_url,
			local_repository => $local_repo->absolute->stringify,
		);
		
		$latest_rev = $source->get_latest_revision;
	}
	elsif($scm->software eq 'svn') {
		next;
	}
	
	if(!$scm->revision || !$latest_rev || $scm->revision ne $latest_rev) {
		foreach my $module( $scm->modules ) {
			my %versions = $source->get_versions;
			# Skip existing versions
			delete $versions{$_->version} for($module->module_versions->all);
			# But always retrieve the latest dev version
			$versions{'dev'} = 1;
			foreach my $version(keys %versions) {
				$source->mod_path('');
				if($scm->software eq 'git') {
					if($module->scm_settings && exists $module->scm_settings->{mod_path}) {
						$source->mod_path( $module->scm_settings->{mod_path} );
					}
				}
				$source->version($version);
				my $mod = Maximus::Class::Module->new(
					modscope => $module->modscope->name,
					mod => $module->name,
					desc => $module->desc,
					source => $source,
					schema => $schema,
				);
				$mod->save( $module->modscope->user_id );
			}
		}

		$scm->update({
			revision => $latest_rev
		});
	}
}
