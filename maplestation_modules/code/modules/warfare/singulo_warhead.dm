/obj/effect/singulo_warhead
	name = "active bluespace singularity warhead"
	desc = "An active bluespace singularity warhead. You probably should be running instead of looking at this."
	icon = 'icons/effects/anomalies.dmi'
	icon_state = "dimensional"
	opacity = TRUE
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE

	var/lifetime = 2 SECONDS
	var/tuned = FALSE

/obj/effect/singulo_warhead/Initialize(mapload)
	. = ..()
	QDEL_IN(src, lifetime)
