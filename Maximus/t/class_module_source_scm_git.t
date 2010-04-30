use strict;
use warnings;
use Test::More;

BEGIN {
	TODO: {
		local $TODO = 'Maximus::Class::Module::Source::SCM::Git not yet implemented';
		use_ok 'Maximus::Class::Module::Source::SCM::Git'		
	};
}


done_testing();
