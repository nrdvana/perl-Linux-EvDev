#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdint.h>
#include <stdarg.h>
#include "PerlEvDev.h"

static void carp_croak_sv(SV* value) {
        dSP;
        PUSHMARK(SP);
        XPUSHs(value);
        PUTBACK;
        call_pv("Carp::croak", G_VOID | G_DISCARD);
}
#define carp_croak(format_args...) carp_croak_sv(sv_2mortal(newSVpvf(format_args)))
#define fetch_if_defined(hv, name) _fetch_if_defined(hv, name, (sizeof(name)-1))

static SV *_fetch_if_defined(HV *self, const char *field, int len) {
	SV **field_p= hv_fetch(self, field, len, 0);
	return (field_p && *field_p && SvOK(*field_p)) ? *field_p : NULL;
}

static SV* PerlEvDev_set_mg(SV *obj, MGVTBL *mg_vtbl, void *ptr) {
	MAGIC *mg= NULL;
	
	if (!sv_isobject(obj))
		croak("Can't add magic to non-object");
	
	/* Search for existing Magic that would hold this pointer */
	for (mg = SvMAGIC(SvRV(obj)); mg; mg = mg->mg_moremagic) {
		if (mg->mg_type == PERL_MAGIC_ext && mg->mg_virtual == mg_vtbl) {
			mg->mg_ptr= ptr;
			return obj;
		}
	}
	sv_magicext(SvRV(obj), NULL, PERL_MAGIC_ext, mg_vtbl, (const char *) ptr, 0);
	return obj;
}

void* PerlEvDev_get_mg(SV *obj, MGVTBL *mg_vtbl) {
	MAGIC *mg= NULL;
	if (sv_isobject(obj)) {
		for (mg = SvMAGIC(SvRV(obj)); mg; mg = mg->mg_moremagic) {
			if (mg->mg_type == PERL_MAGIC_ext && mg->mg_virtual == mg_vtbl)
				return (void*) mg->mg_ptr;
		}
	}
	return NULL;
}

/* Given a struct libevdev*, either find the Linux::EvDev object that already holds it,
 * or wrap it with a new one.  Return a ref to the object.
 */
SV * PerlEvDev_libevdev_to_obj(struct libevdev *evdev) {
	SV *self, **field;
	HV *evdev_to_obj;
	HE *ent;

	// NULL pointers never get wrappers
	if (!evdev) return &PL_sv_undef;

	// The module maintains weak references to all its objects
	evdev_to_obj= get_hv("Linux::EvDev::_evdev_to_obj", GV_ADD);
	field= hv_fetch(evdev_to_obj, (char*)&evdev, sizeof(&evdev), 1);
	if (!field || !*field)
		croak("failed to allocate hv entry");
	if (SvROK(*field))
		return *field;

	// Else create a new wrapper
	self= newRV_noinc((SV*)newHV());
	sv_bless(self, gv_stashpv("Linux::EvDev", GV_ADD));
	PerlEvDev_set_mg(self, &PerlEvDev_libevdev_mg_vtbl, evdev);
	SvSetSV_nosteal(*field, self);
	sv_rvweaken(*field);
	return self;
}

void PerlEvDev_obj_destroy(SV *obj) {
	struct libevdev *evdev;
	HV *evdev_to_obj;
	SV **field;
	// Ignore NULL pointers and thngs that aren't references
	if (!obj || !SvROK(obj)) return;
	// Get libevdev reference, or ignore it
	evdev= PerlEvDev_get_mg_libevdev(obj);
	if (!evdev) return;
	// Remove it from the _evdev_to_obj
	evdev_to_obj= get_hv("Linux::EvDev::_evdev_to_obj", GV_ADD);
	hv_delete(evdev_to_obj, (char*)&evdev, sizeof(&evdev), G_DISCARD);
	// Detach the pointer
	PerlEvDev_set_mg(obj, &PerlEvDev_libevdev_mg_vtbl, NULL);
	// Then free it
	libevdev_free(evdev);
	// rebless the object
	sv_bless(obj, gv_stashpv("Linux::EvDev::Freed", GV_ADD));
	// set reference to undef
	SvSetSV_nosteal(obj, &PL_sv_undef);
}

/* gets called when the blessed HV goes out of scope */
int PerlEvDev_mg_free_libevdev(pTHX_ SV *sv, MAGIC* mg) {
	struct libevdev *evdev= (struct libevdev*) mg->mg_ptr;
	HV *evdev_to_obj;
	mg->mg_ptr= NULL;
	if (evdev) {
		libevdev_free(evdev);
		// Remove it from the _evdev_to_obj
		evdev_to_obj= get_hv("Linux::EvDev::_evdev_to_obj", GV_ADD);
		hv_delete(evdev_to_obj, (char*)&evdev, sizeof(&evdev), G_DISCARD);
	}
	return 0;
}

/*------------------------------------------------------------------------------------------------
 * Set up the vtable structs for applying magic
 */

static int PerlEvDev_mg_nodup(pTHX_ MAGIC *mg, CLONE_PARAMS *param) {
	croak("Can't share EvDev objects across perl iThreads");
	return 0;
}
#ifdef MGf_LOCAL
static int PerlEvDev_mg_nolocal(pTHX_ SV *var, MAGIC* mg) {
	croak("Can't share EvDev objects across perl iThreads");
	return 0;
}
#endif

MGVTBL PerlEvDev_libevdev_mg_vtbl= {
	0, /* get */ 0, /* write */ 0, /* length */ 0, /* clear */
	PerlEvDev_mg_free_libevdev,
	0, PerlEvDev_mg_nodup
#ifdef MGf_LOCAL
	, PerlEvDev_mg_nolocal
#endif
};
