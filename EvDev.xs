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
