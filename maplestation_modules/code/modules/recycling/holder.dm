// -- File to make disposals hurt when people tumble through them --
/datum/config_entry/number/disposals_damage_multiplier
	default = 1

/datum/config_entry/number/disposals_damage_chance
	default = 10
	min_val = 0
	max_val = 100

/datum/config_entry/number/disposals_pain_chance
	default = 10
	min_val = 0
	max_val = 100

/obj/structure/disposalholder/try_expel(datum/move_loop/source, succeed, visual_delay)
	. = ..()
	if(!current_pipe && active)
		return

	// Checks if there's an outlet so it doesn't keep trying to damage you there.
	if(locate(/obj/structure/disposaloutlet) in get_turf(src))
		return

	for(var/mob/living/trashed_individual in src)
		if(prob(20))
			playsound(loc, 'sound/effects/clang.ogg', 30, TRUE, FALSE)
		else if(prob(CONFIG_GET(number/disposals_damage_chance)))
			trashed_individual.apply_damage(2 * CONFIG_GET(number/disposals_damage_multiplier), BRUTE)
			if(trashed_individual.has_bones() && trashed_individual.mob_size >= MOB_SIZE_SMALL)
				var/bone_volume = trashed_individual.mob_size == MOB_SIZE_SMALL ? 10 : 50
				var/bone_frequency = trashed_individual.mob_size == MOB_SIZE_SMALL ? 2 : 1
				playsound(loc, 'sound/effects/wounds/crack2.ogg', bone_volume, TRUE, 0, frequency = bone_frequency)
		else if(prob(CONFIG_GET(number/disposals_pain_chance)))
			var/mob/living/carbon/carbon_trashed = trashed_individual
			if(trashed_individual.has_bones() && trashed_individual.mob_size >= MOB_SIZE_SMALL)
				var/bone_volume = trashed_individual.mob_size == MOB_SIZE_SMALL ? 10 : 50
				var/bone_frequency = trashed_individual.mob_size == MOB_SIZE_SMALL ? 2 : 1
				playsound(loc, 'sound/effects/wounds/crack1.ogg', bone_volume, TRUE, 0, frequency = bone_frequency)
			carbon_trashed.sharp_pain(pick(BODY_ZONES_ALL), 4 * CONFIG_GET(number/disposals_damage_multiplier), BRUTE)

/// Check if the mob has any bones
/mob/living/proc/has_bones()
	return (mob_biotypes & (MOB_ORGANIC|MOB_UNDEAD|MOB_BEAST))

/mob/living/silicon/has_bones()
	return FALSE

/mob/living/carbon/has_bones()
	for(var/obj/item/bodypart/part as anything in bodyparts)
		if(part.biological_state & BIO_BONE)
			return TRUE
	return FALSE
