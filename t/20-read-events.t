use strict;
use warnings;
use Test::More;

use_ok('Linux::EvDev') || BAIL_OUT;
plan skip_all => 'Skipping read tests unless TEST_EVDEV_READ is set'
	unless $ENV{TEST_EVDEV_READ};
my ($path, $dev);
for (-e $ENV{TEST_EVDEV_READ}? $ENV{TEST_EVDEV_READ} : </dev/input/event*>) {
	if (open $dev, '<', $_) {
		$path= $_;
		last;
	}
}
plan skip_all => 'Can\'t read from any /dev/input/event* device'
	unless $dev;

ok( my $evdev= Linux::EvDev::libevdev_new(), 'new instance' );
is( Linux::EvDev::libevdev_set_fd($evdev, fileno $dev), 0, 'set fd' );
my $code= Linux::EvDev::libevdev_next_event($evdev, Linux::EvDev::READ_FLAG_SYNC(), my $event );
ok( $code >= 0, 'got an event' )
	or diag "code=$code";
isa_ok( $event, 'Linux::EvDev::Event', 'event' );
$code= Linux::EvDev::libevdev_next_event($evdev, Linux::EvDev::READ_FLAG_SYNC(), \my $event2 );
is( length $event2, length $$event, 'event structs are same length' );
my $event3= $event;
$code= Linux::EvDev::libevdev_next_event($evdev, Linux::EvDev::READ_FLAG_SYNC(), $event3 );
is( $event3+0, $event+0, 'event loaded into same object ref' );

done_testing;
