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
	my($source);	
	if($scm->software eq 'git') {
		my $local_repo = Path::Class::Dir->new(File::Spec->tmpdir(), $cfg->{name}, 'repositories', sha1_hex($scm->repo_url));
		make_path($local_repo->absolute->stringify);

		$source = Maximus::Class::Module::Source::SCM::Git->new(
			repository => $scm->repo_url,
			local_repository => $local_repo->absolute->stringify,
		);
	}
	elsif($scm->software eq 'svn') {
		$source = Maximus::Class::Module::Source::SCM::Subversion->new(
			repository => $scm->repo_url,
		);
	}
	
	my $latest_rev = $source->get_latest_revision;
	if(!$scm->revision || !$latest_rev || $scm->revision ne $latest_rev) {
		foreach my $module( $scm->modules ) {
			my %versions = $source->get_versions;
			# Skip existing versions
			delete $versions{$_->version} for($module->module_versions->all);
			# But always retrieve the latest dev version
			$versions{'dev'} = 1;
			foreach my $version(keys %versions) {
				if($scm->software eq 'git') {
					$source->mod_path('');  # Reset mod_path
					if($module->scm_settings && exists $module->scm_settings->{mod_path}) {
						$source->mod_path( $module->scm_settings->{mod_path} );
					}
				}
				elsif($scm->software eq 'svn' && $module->scm_settings) {
					# Shouldn't forget to reset these settings!!
					if(exists $module->scm_settings->{trunk}) {
						$source->trunk( $module->scm_settings->{trunk} );
					}
					if(exists $module->scm_settings->{tags}) {
						$source->tags( $module->scm_settings->{tags} );
					}
					if(exists $module->scm_settings->{tags_filter}) {
						$source->tags_filter( $module->scm_settings->{tags_filter} );
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
