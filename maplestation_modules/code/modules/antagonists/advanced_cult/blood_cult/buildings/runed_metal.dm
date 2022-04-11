// Make runed metal not rigid.
/datum/material/runedmetal/New()
	. = ..()
	categories -= MAT_CATEGORY_RIGID

// Real cult walls have a special examine for non-cultists.
/turf/closed/wall/mineral/cult/examine(mob/user)
	. = ..()
	if(isliving(user) && !IS_CULTIST(user))
		var/mob/living/living_user = user
		if(living_user.dizziness <= 25 && prob(66))
			living_user.dizziness += 10
			. += span_hypnophrase("The shifting symbols cause you to feel dizzy...")
