// -- Fluff objects. --
// A signpost object that doesn't teleport you somewhere when you touch it.
/obj/structure/no_effect_signpost
	name = "signpost"
	desc = "Won't somebody give me a sign?"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "signpost"
	anchored = TRUE
	density = TRUE

/obj/structure/no_effect_signpost/void
	name = "signpost at the edge of the universe"
	desc = "A direction in the directionless void."
	density = FALSE
	/// Brightness of the signpost.
	var/range = 2
	/// Light power of the signpost.
	var/power = 0.8

/obj/structure/no_effect_signpost/void/Initialize()
	. = ..()
	set_light(range, power)
