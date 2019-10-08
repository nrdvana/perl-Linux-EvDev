use strict;
use warnings;
use Test::More;

use_ok('Linux::EvDev') || BAIL_OUT;

ok( my $evdev= Linux::EvDev::libevdev_new(), 'new instance' );
my $evdev2= $evdev;
Linux::EvDev::libevdev_free($evdev);
ok( !$evdev, 'free() cleared the reference' );
isa_ok( $evdev2, 'Linux::EvDev::Freed' );

done_testing;
