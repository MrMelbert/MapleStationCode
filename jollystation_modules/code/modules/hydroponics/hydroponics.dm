// -- Hydroponics tray additions --
#define TRAY_MODIFIED_BASE_NUTRIDRAIN 0.5
#define TRAY_MODIFIED_BASE_MAXWATER 200

/obj/machinery/hydroponics/constructable
	// Max water is doubled so they don't need to rely on autogrow for all their trays
	maxwater = TRAY_MODIFIED_BASE_MAXWATER
	// Nutriment drain is halved so they can not worry about fertilizer as much
	nutridrain = TRAY_MODIFIED_BASE_NUTRIDRAIN

/obj/machinery/hydroponics/constructable/RefreshParts()
	. = ..()
	// Dehardcodes the nutridrain scaling factor
	calculate_nutridrain()

/obj/machinery/hydroponics/constructable/CtrlClick(mob/user)
	var/curr_sustain = self_sustaining
	. = ..()
	// Hacky check to see if we actually toggled sustaining or not
	// because I don't want to touch the main file
	if(curr_sustain != self_sustaining)
		calculate_nutridrain()

/obj/machinery/hydroponics/constructable/proc/calculate_nutridrain()
	var/sustaining_mod = self_sustaining ? 2 : 1
	nutridrain = initial(nutridrain) / (sustaining_mod * rating)

#undef TRAY_BASE_NUTRIDRAIN
