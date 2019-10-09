package Linux::EvDev;
use 5.008001;
use strict;
use warnings;
use Carp;
use Exporter 'import';

# ABSTRACT: Wrapper for libevdev
# VERSION

our %EXPORT_TAGS= (
# BEGIN GENERATED XS CONSTANT LIST
  grab_mode => [qw( GRAB GRAB_MODE_UNGRAB )],
  led_value => [qw( LED_OFF LED_ON )],
  log_priority => [qw( LOG_DEBUG LOG_ERROR LOG_INFO )],
  read_flag => [qw( READ_FLAG_BLOCKING READ_FLAG_FORCE_SYNC READ_FLAG_NORMAL
    READ_FLAG_SYNC )],
  read_status => [qw( READ_STATUS_SUCCESS READ_STATUS_SYNC )],
# END GENERATED XS CONSTANT LIST
);
$EXPORT_TAGS{constants}= [ map { @$_ } values %EXPORT_TAGS ];
our @EXPORT_OK= @{$EXPORT_TAGS{constants}};
require XSLoader;
XSLoader::load("Linux::EvDev", $Linux::EvDev::VERSION);

=head1 EXPORTS

=head2 :constants

This exports all constants defined by libevdev.  They are the same as the C enums except
that the C<"LIBEVDEV_"> prefix is removed.  Constants can additionally be exported by
the name of the enum (also minus the "libevdev_" prefix).

=over

=item :read_flag

enum libevdev_read_flag

=item :log_priority

enum libevdev_log_priority

=item :grab_mode

enum libevdev_grab_mode

=item :read_status

enum libevdev_read_status

=item :led_value

enum libevdev_led_value

=back

=head2 libevdev_new

  my $evdev= libevdev_new;

Return a new instance of C<Linux::EvDev>.  This needs connected to a file handle
with L</libevdev_set_fd>.  If C<$evdev> goes out of scope it will automatically
call L<libevdev_free>.

=head2 libevdev_set_fd

  my $err= libevdev_set_fd($evdev, fileno($fh));

Set the file descriptor (Unix integer) associated with the $evdev object.
Returns 0 on success.  May only be called once per device.  See L</libevdev_change_fd>
if you want to change the fd later on.

=head2 libevdev_new_from_fd

  my $err= libevdev_new_from_fd(fileno($fh), my $evdev_out);

Create a EvDev object and set its file handle.  This is basically L</libevdev_new>
combined with L</libevdev_set_fd> and cleans up the new object if C<set_fd> fails.
Returns 0 on success, or an error code otherwise.  The returned EvDev is stored in
C<$evdev_out>.

=head2 libevdev_free

  libevdev_free($evdev);

Free the internal libevdev instance attached to the C<$evdev>, un-bless it, and also set
C<$evdev> to C<undef>.  If there were other references to the C<$evdev>, they will now
reference a non-magical hashref.  This function is called automatically when the C<$evdev>
goes out of scope, so you probably don't need to call it manually.

=head2 libevdev_get_fd

Returns the file descriptor number associted with the object, or -1 if it hasn't been
initialized.

=head2 libevdev_change_fd

  libevdev_change_fd($evdev, fileno($fh))

Change the file descriptor associated with the object to a new FD number but C<with the
assumption that it points to the same underlying device>.  The object must already refer to
a file descriptor.  You need to perform a re-sync of the device state after this; see
libevdev.h for details.

=head2 libevdev_next_event

  $code= libevdev_next_event($evdev, $flags, $event_out);

Read events from the device and store the next event into C<$event_out>.
C<$flags> can be C<READ_FLAG_NORMAL> (to read actual events from the device) or
C<READ_FLAG_SYNC> (after a SYN_DROPPED event to read a series of virtual events
to get caught up with the device's current state).

Codes returned can be:

=over

=item C<READ_STATUS_SUCCESS>

One or more events were read and C<$event_out> holds the next one.

=item C<READ_STATUS_SYNC>

A C<SYN_DROPPED> event was received, or the function is returning sync events for a
requested C<READ_FLAG_SYNC> in C<$flags>.

=item Negative Value

Negative values are negative libc C<errno> codes.  In particular, C<- EAGAIN> means that
no events are pending, or that a sync has completed.

=back

=cut

__END__



=head2 libevdev_set_device_log_function

  libevdev_set_device_log_function($callback, $callback_data);
  # where callback is:
  sub ($EvDev, $priority, $callback_data, $file, $line, $fn_name, $message);

Set the log callback for the given C<$EvDev>

=head2 libevdev_set_log_priority

=head2 libevdev_get_log_priority

  libevdev_set_log_priority($priority)