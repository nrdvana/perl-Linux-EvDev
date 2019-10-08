package Linux::EvDev;
use 5.008001;
use strict;
use warnings;
use Carp;

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
$EXPORT_TAGS{constants}= [ map @{$EXPORT_TAGS{$_}}, keys %EXPORT_TAGS ];
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

=head2 libevdev_new_from_fd

  my $err= libevdev_new_from_fd(fileno($fh), my $evdev_out);

Create a EvDev object and set its file handle.  Returns 0 on success, or an error
code otherwise.  The returned EvDev is stored in C<$evdev_out>.

=head2 libevdev_free

  libevdev_free($evdev);

Free the internal libevdev instance attached to the C<$evdev>, un-bless it, and also set
C<$evdev> to C<undef>.  If there were other references to the C<$evdev>, they will now
reference a non-magical hashref.  This function is called automatically when the C<$evdev>
goes out of scope, so you probably don't need to call it manually.

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