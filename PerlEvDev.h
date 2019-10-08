#include <libevdev/libevdev.h>

/* These are exposed so that PerlEvDev_get_mg and PerlEvDev_set_mg can be generic and not need
 * a pair of functions for each type of object.
 */
extern MGVTBL PerlEvDev_libevdev_mg_vtbl;
extern void* PerlEvDev_get_mg(SV *obj, MGVTBL *mg_vtbl);

#define PerlEvDev_get_mg_libevdev(obj)      ((struct libevdev*) PerlEvDev_get_mg(obj, &PerlEvDev_libevdev_mg_vtbl))
extern SV * PerlEvDev_libevdev_to_obj(struct libevdev *inst);
extern void PerlEvDev_obj_destroy(SV * evdev);
