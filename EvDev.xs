#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <libevdev/libevdev.h>

#include "PerlEvDev.h"

MODULE = Linux::EvDev              PACKAGE = Linux::EvDev

struct libevdev*
libevdev_new()

int
libevdev_new_from_fd(fd, obj_out)
	int fd
	SV *obj_out
	INIT:
		struct libevdev *dev;
		int err;
	CODE:
		err= libevdev_new_from_fd(fd, &dev);
		if (!err)
			sv_setsv(obj_out, PerlEvDev_libevdev_to_obj(dev));
		RETVAL = err;
	OUTPUT:
		RETVAL

void
libevdev_free(obj)
	SV *obj
	CODE:
		PerlEvDev_obj_destroy(obj);

int
libevdev_set_fd(dev, fd)
	struct libevdev* dev
	int fd

int
libevdev_get_fd(dev)
	struct libevdev* dev

int
libevdev_change_fd(dev, fd)
	struct libevdev* dev
	int fd

int
libevdev_next_event(dev, flags, ev)
	struct libevdev *dev
	unsigned int flags
	struct input_event *ev

int
libevdev_has_event_pending(dev)
	struct libevdev *dev

const char *
libevdev_get_name(dev)
	struct libevdev *dev

void
libevdev_set_name(dev, name)
	struct libevdev *dev
	const char *name

const char *
libevdev_get_phys(dev)
	struct libevdev *dev

void
libevdev_set_phys(dev, phys)
	struct libevdev *dev
	const char *phys

const char *
libevdev_get_uniq(dev)
	struct libevdev *dev

int
libevdev_get_id_product(dev)
	struct libevdev *dev

void
libevdev_set_id_product(dev, id)
	struct libevdev *dev
	int id

int
libevdev_get_id_vendor(dev)
	struct libevdev *dev

void
libevdev_set_id_vendor(dev, id)
	struct libevdev *dev
	int id

int
libevdev_get_id_bustype(dev)
	struct libevdev *dev

void
libevdev_set_id_bustype(dev, id)
	struct libevdev *dev
	int id

int
libevdev_get_id_version(dev)
	struct libevdev *dev

void
libevdev_set_id_version(dev, id)
	struct libevdev *dev
	int id

int
libevdev_get_driver_version(dev)
	struct libevdev *dev

int
libevdev_has_property(dev, prop)
	struct libevdev *dev
	unsigned int prop

int
libevdev_enable_property(dev, prop)
	struct libevdev *dev
	unsigned int prop

int
libevdev_has_event_type(dev, type)
	struct libevdev *dev
	unsigned int type

int
libevdev_has_event_code(dev, type, code)
	struct libevdev *dev
	unsigned int type
	unsigned int code

int
libevdev_get_abs_minimum(dev, code)
	struct libevdev *dev
	unsigned int code

int
libevdev_get_abs_maximum(dev, code)
	struct libevdev *dev
	unsigned int code

int
libevdev_get_abs_fuzz(dev, code)
	struct libevdev *dev
	unsigned int code

int
libevdev_get_abs_flat(dev, code)
	struct libevdev *dev
	unsigned int code

int
libevdev_get_abs_resolution(dev, code)
	struct libevdev *dev
	unsigned int code

SV *
libevdev_get_abs_info(dev, code)
	struct libevdev *dev
	unsigned int code
	INIT:
		const struct input_absinfo *absinfo;
	CODE:
		absinfo= libevdev_get_abs_info(dev, code);
		if (absinfo) {
			RETVAL= newSV(0);
			memcpy(PerlEvDev_coerce_to_input_absinfo(RETVAL), absinfo, sizeof(*absinfo));
		}
		else {
			RETVAL= &PL_sv_undef;
		}
	OUTPUT:
		RETVAL

int
libevdev_get_event_value(dev, type, code)
	struct libevdev *dev
	unsigned int type
	unsigned int code

int
libevdev_set_event_value(dev, type, code, value)
	struct libevdev *dev
	unsigned int type
	unsigned int code
	int value

int libevdev_fetch_event_value(dev, type, code, value_sv)
	struct libevdev *dev
	unsigned int type
	unsigned int code
	SV *value_sv
	INIT:
		int value;
	CODE:
		RETVAL = libevdev_fetch_event_value(dev, type, code, &value);
		if (RETVAL)
			sv_setiv_mg(value_sv, value);
	OUTPUT:
		RETVAL

int
libevdev_get_slot_value(dev, slot, code)
	struct libevdev *dev
	unsigned int slot
	unsigned int code

int
libevdev_set_slot_value(dev, slot, code, value)
	struct libevdev *dev
	unsigned int slot
	unsigned int code
	int value

int
libevdev_fetch_slot_value(dev, slot, code, value_sv)
	struct libevdev *dev
	unsigned int slot
	unsigned int code
	SV *value_sv
	INIT:
		int value;
	CODE:
		RETVAL = libevdev_fetch_slot_value(dev, slot, code, &value);
		if (RETVAL)
			sv_setiv_mg(value_sv, value);
	OUTPUT:
		RETVAL

int
libevdev_get_num_slots(dev)
	struct libevdev *dev

int
libevdev_get_current_slot(dev)
	struct libevdev *dev

void
libevdev_set_abs_maximum(dev, code, max)
	struct libevdev *dev
	unsigned int code
	int max

void
libevdev_set_abs_fuzz(dev, code, fuzz)
	struct libevdev *dev
	unsigned int code
	int fuzz

void
libevdev_set_abs_flat(dev, code, flat)
	struct libevdev *dev
	unsigned int code
	int flat

void
libevdev_set_abs_resolution(dev, code, resolution)
	struct libevdev *dev
	unsigned int code
	int resolution

int
libevdev_enable_event_type(dev, type)
	struct libevdev *dev
	unsigned int type

int
libevdev_disable_event_type(dev, type)
	struct libevdev *dev
	unsigned int type

int
libevdev_disable_event_code(dev, type, code)
	struct libevdev *dev
	unsigned int type
	unsigned int code

int
libevdev_kernel_set_led_value(dev, code, value)
	struct libevdev *dev
	unsigned int code
	int value

int
libevdev_set_clock_id(dev, clockid)
	struct libevdev *dev
	int clockid

int
libevdev_event_is_type(ev, type)
	struct input_event *ev
	unsigned int type

int
libevdev_event_is_code(ev, type, code)
	struct input_event *ev
	unsigned int type
	unsigned int code

const char *
libevdev_event_type_get_name(type)
	unsigned int type

const char *
libevdev_event_code_get_name(type, code)
	unsigned int type
	unsigned int code

const char *
libevdev_property_get_name(prop)
	unsigned int prop

int
libevdev_event_type_get_max(type)
	unsigned int type

int
libevdev_event_type_from_name(name)
	const char *name

int
libevdev_event_code_from_name(type, name)
	unsigned int type
	const char *name

int
libevdev_property_from_name(name)
	const char *name

int
libevdev_get_repeat(dev, delay_sv, period_sv)
	struct libevdev *dev
	SV *delay_sv
	SV *period_sv
	INIT:
		int delay, period;
	CODE:
		RETVAL = libevdev_get_repeat(dev, &delay, &period);
		if (RETVAL == 0) {
			sv_setiv_mg(delay_sv, delay);
			sv_setiv_mg(period_sv, delay);
		}
	OUTPUT:
		RETVAL

# # void
# # libevdev_set_log_function(coderef, data)
# # 	SV *coderef
# # 	SV *data
# # 	INIT:
# # 		SV *_log_callback, *_log_callback_data;
# # 	CODE:
# # 		if (!(SvROK(coderef) && SvTYPE(SvRV((RV*)coderef)) == SVt_PVCV))
# # 			croak("First argument must be a coderef");
# # 		_log_callback= get_sv("Linux::EvDev::_log_callback", GV_ADD);
# # 		_log_callback_data= get_sv("Linux::EvDev::_log_callback_data", GV_ADD);
# # 		SvSetSV_nosteal(_log_callback, coderef);
# # 		SvSetSV_nosteal(_log_callback_data, data);
# # 		libevdev_set_log_function(&PerlEvDev_log_callback, NULL);
# # 
# # void libevdev_set_log_priority(enum libevdev_log_priority priority);
# # 



BOOT:
# BEGIN GENERATED BOOT CONSTANTS
  HV* stash= gv_stashpv("Linux::EvDev", GV_ADD);
  newCONSTSUB(stash, "LOG_ERROR", newSViv(LIBEVDEV_LOG_ERROR));
  newCONSTSUB(stash, "LOG_INFO", newSViv(LIBEVDEV_LOG_INFO));
  newCONSTSUB(stash, "LOG_DEBUG", newSViv(LIBEVDEV_LOG_DEBUG));
  newCONSTSUB(stash, "READ_FLAG_SYNC", newSViv(LIBEVDEV_READ_FLAG_SYNC));
  newCONSTSUB(stash, "READ_FLAG_NORMAL", newSViv(LIBEVDEV_READ_FLAG_NORMAL));
  newCONSTSUB(stash, "READ_FLAG_BLOCKING", newSViv(LIBEVDEV_READ_FLAG_BLOCKING));
  newCONSTSUB(stash, "GRAB_MODE_UNGRAB", newSViv(LIBEVDEV_UNGRAB));
  newCONSTSUB(stash, "READ_FLAG_FORCE_SYNC", newSViv(LIBEVDEV_READ_FLAG_FORCE_SYNC));
  newCONSTSUB(stash, "GRAB", newSViv(LIBEVDEV_GRAB));
  newCONSTSUB(stash, "READ_STATUS_SUCCESS", newSViv(LIBEVDEV_READ_STATUS_SUCCESS));
  newCONSTSUB(stash, "READ_STATUS_SYNC", newSViv(LIBEVDEV_READ_STATUS_SYNC));
  newCONSTSUB(stash, "LED_ON", newSViv(LIBEVDEV_LED_ON));
  newCONSTSUB(stash, "LED_OFF", newSViv(LIBEVDEV_LED_OFF));
# END GENERATED BOOT CONSTANTS
#
