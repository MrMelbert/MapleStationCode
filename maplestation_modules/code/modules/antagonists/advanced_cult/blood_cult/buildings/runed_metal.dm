// Make runed metal not rigid.
/datum/material/runedmetal/New()
	. = ..()
	categories -= MAT_CATEGORY_RIGID

// Real cult walls have a special examine for non-cultists.
/turf/closed/wall/mineral/cult/examine(mob/user)
	. = ..()
	if(!isliving(user) || IS_CULTIST(user))
		return

	var/mob/living/living_user = user
	if(prob(66))
		living_user.adjust_dizzy_up_to(20 SECONDS, 50 SECONDS)
		. += span_hypnophrase("The shifting symbols cause you to feel dizzy...")
