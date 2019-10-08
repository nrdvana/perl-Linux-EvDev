#! /usr/bin/env perl
use strict;
use warnings;
use Test::More;
BEGIN { use_ok('Linux::EvDev', ':constants') || BAIL_OUT };

foreach my $constname (@{ $Linux::EvDev::EXPORT_TAGS{constants} }) {
	if (eval "my \$a = $constname; 1") {
		pass($constname);
	}
	elsif ($@ =~ /available on this version/) {
		SKIP: { skip "$constname unavailable on this version of libevdev", 1; fail($constname); }
	}
	else {
		fail($constname);
	}
}

done_testing;
