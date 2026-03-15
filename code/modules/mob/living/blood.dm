#define BLOOD_DRIP_RATE_MOD 90 //Greater number means creating blood drips more often while bleeding
// Conversion between internal drunk power and common blood alcohol content
#define DRUNK_POWER_TO_BLOOD_ALCOHOL 0.003

/****************************************************
				BLOOD SYSTEM
****************************************************/

// NON-MODULE CHANGE for blood
// Takes care blood loss and regeneration
/mob/living/carbon/human/handle_blood(seconds_per_tick, times_fired)

	if(HAS_TRAIT(src, TRAIT_NOBLOOD) || HAS_TRAIT(src, TRAIT_FAKEDEATH))
		remove_max_consciousness_value(BLOOD_LOSS)
		return

	if(body_temperature < BLOOD_STOP_TEMP || HAS_TRAIT(src, TRAIT_HUSK)) //cold or husked people do not pump the blood.
		return

	var/sigreturn = SEND_SIGNAL(src, COMSIG_HUMAN_ON_HANDLE_BLOOD, seconds_per_tick, times_fired)
	if(sigreturn & HANDLE_BLOOD_HANDLED)
		return

	//Blood regeneration if there is some space
	if(!(sigreturn & HANDLE_BLOOD_NO_NUTRITION_DRAIN))
		if(blood_volume < BLOOD_VOLUME_NORMAL && !HAS_TRAIT(src, TRAIT_NOHUNGER))
			var/nutrition_ratio = 0
			switch(nutrition)
				if(0 to NUTRITION_LEVEL_STARVING)
					nutrition_ratio = 0.2
				if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
					nutrition_ratio = 0.4
				if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
					nutrition_ratio = 0.6
				if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
					nutrition_ratio = 0.8
				else
					nutrition_ratio = 1
			if(satiety > 80)
				nutrition_ratio *= 1.25
			adjust_nutrition(-nutrition_ratio * HUNGER_FACTOR * seconds_per_tick)
			blood_volume = min(blood_volume + (BLOOD_REGEN_FACTOR * physiology.blood_regen_mod * nutrition_ratio * seconds_per_tick), BLOOD_VOLUME_NORMAL)

	//Effects of bloodloss
	if(!(sigreturn & HANDLE_BLOOD_NO_EFFECTS))
		var/word = pick("dizzy","woozy","faint")
		switch(blood_volume)
			if(BLOOD_VOLUME_MAX_LETHAL to INFINITY)
				if(SPT_PROB(7.5, seconds_per_tick))
					to_chat(src, span_userdanger("Blood starts to tear your skin apart. You're going to burst!"))
					investigate_log("has been gibbed by having too much blood.", INVESTIGATE_DEATHS)
					inflate_gib()
			if(BLOOD_VOLUME_EXCESS to BLOOD_VOLUME_MAX_LETHAL)
				if(SPT_PROB(5, seconds_per_tick))
					to_chat(src, span_warning("You feel your skin swelling."))
			if(BLOOD_VOLUME_MAXIMUM to BLOOD_VOLUME_EXCESS)
				if(SPT_PROB(5, seconds_per_tick))
					to_chat(src, span_warning("You feel terribly bloated."))
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				if(SPT_PROB(2.5, seconds_per_tick))
					to_chat(src, span_warning("You feel [word]."))
				var/threshold = 50 * ((BLOOD_VOLUME_SAFE - blood_volume) / (BLOOD_VOLUME_SAFE - BLOOD_VOLUME_OKAY))
				if(getOxyLoss() < threshold)
					adjustOxyLoss(1)
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				add_max_consciousness_value(BLOOD_LOSS, CONSCIOUSNESS_MAX * 0.9)
				add_consciousness_modifier(BLOOD_LOSS, -10)
				adjust_traumatic_shock(0.5 * seconds_per_tick)
				if(getOxyLoss() < 100)
					adjustOxyLoss(2) // Keep in mind if they're still breathing while bleeding - some of this will be recovered
				if(SPT_PROB(2.5, seconds_per_tick))
					set_eye_blur_if_lower(12 SECONDS)
					to_chat(src, span_warning("You feel very [word]."))
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
				add_max_consciousness_value(BLOOD_LOSS, CONSCIOUSNESS_MAX * 0.6)
				add_consciousness_modifier(BLOOD_LOSS, -20)
				adjust_traumatic_shock(1 * seconds_per_tick)
				if(getOxyLoss() < 150)
					adjustOxyLoss(3)
				set_eye_blur_if_lower(6 SECONDS)
				if(SPT_PROB(7.5, seconds_per_tick))
					Unconscious(rand(2, 6) * 1 SECONDS)
					losebreath += 1
					to_chat(src, span_warning("You feel extremely [word]."))
			if(-INFINITY to BLOOD_VOLUME_SURVIVE)
				add_max_consciousness_value(BLOOD_LOSS, CONSCIOUSNESS_MAX * 0.2)
				add_consciousness_modifier(BLOOD_LOSS, -50)
				adjust_traumatic_shock(3 * seconds_per_tick)
				set_eye_blur_if_lower(20 SECONDS)
				// Unconscious(10 SECONDS)
				var/how_screwed_are_we = 1 - ((BLOOD_VOLUME_SURVIVE - blood_volume) / BLOOD_VOLUME_SURVIVE)
				adjustOxyLoss(max(5, 50 * how_screwed_are_we))
				// if(!HAS_TRAIT(src, TRAIT_NODEATH))
				// 	investigate_log("has died of bloodloss.", INVESTIGATE_DEATHS)
				// 	death()

	if(blood_volume > BLOOD_VOLUME_OKAY || (sigreturn & HANDLE_BLOOD_NO_EFFECTS))
		remove_max_consciousness_value(BLOOD_LOSS)
		remove_consciousness_modifier(BLOOD_LOSS)

	// NON-MODULE CHANGE END for blood

	var/temp_bleed = 0
	//Bleeding out
	for(var/obj/item/bodypart/iter_part as anything in bodyparts)
		var/iter_bleed_rate = iter_part.cached_bleed_rate
		temp_bleed += iter_bleed_rate * seconds_per_tick

		if(iter_part.generic_bleedstacks) // If you don't have any bleedstacks, don't try and heal them
			iter_part.adjustBleedStacks(-1)

	if(temp_bleed)
		bleed(temp_bleed)

/// Has each bodypart update its bleed/wound overlay icon states
/mob/living/carbon/proc/update_bodypart_bleed_overlays()
	for(var/obj/item/bodypart/iter_part as anything in bodyparts)
		iter_part.update_part_wound_overlay()

/// Makes a blood drop, leaking amt units of blood from the mob
/mob/living/proc/bleed(amt, leave_pool = TRUE)
	return

/mob/living/carbon/bleed(amt, leave_pool = TRUE)
	if((status_flags & GODMODE) || HAS_TRAIT(src, TRAIT_NOBLOOD))
		return
	blood_volume = max(blood_volume - amt, 0)

	if(leave_pool && isturf(loc) && prob(sqrt(amt) * BLOOD_DRIP_RATE_MOD))
		add_splatter_floor(loc, (amt <= 10))

/mob/living/carbon/human/bleed(amt, leave_pool = TRUE)
	amt *= physiology.bleed_mod
	return ..()

/// A helper to see how much blood we're losing per tick
/mob/living/proc/get_bleed_rate()
	return 0

/mob/living/carbon/get_bleed_rate()
	var/bleed_amt = 0
	for(var/X in bodyparts)
		var/obj/item/bodypart/iter_bodypart = X
		bleed_amt += iter_bodypart.cached_bleed_rate
	return bleed_amt

/mob/living/carbon/human/get_bleed_rate()
	. = ..()
	. *= physiology.bleed_mod

/mob/living/proc/restore_blood()
	blood_volume = initial(blood_volume)

/mob/living/carbon/restore_blood()
	blood_volume = BLOOD_VOLUME_NORMAL
	for(var/i in bodyparts)
		var/obj/item/bodypart/BP = i
		BP.setBleedStacks(0)

/****************************************************
				BLOOD TRANSFERS
****************************************************/

// NON-MODULE CHANGE : Blood rework

//Gets blood from mob to a container or other mob, preserving all data in it.
/mob/living/proc/transfer_blood_to(atom/movable/AM, amount, forced)
	if(!has_blood() || !AM.reagents)
		return FALSE
	if(blood_volume < BLOOD_VOLUME_BAD && !forced)
		return FALSE

	if(blood_volume < amount)
		amount = blood_volume

	blood_volume -= amount
	AM.reagents.add_reagent(blood_type.reagent_type, amount, blood_type.get_blood_data(src), body_temperature)
	return TRUE

/// Updates the blood_type variable with a blood_type singleton
/mob/living/proc/set_blood_type(input_type, update = TRUE)
	var/new_blood = find_blood_type(input_type)
	if(isnull(new_blood) || blood_type == new_blood)
		return FALSE

	blood_type = new_blood
	return TRUE

/mob/living/carbon/set_blood_type(input_type, update = TRUE)
	. = ..()
	if(!.)
		return

	var/update_needed = FALSE
	for(var/obj/item/bodypart/part as anything in bodyparts)
		for(var/obj/item/organ/organ_bit in part)
			if(IS_ORGANIC_ORGAN(organ_bit) || isandroid(src))
				organ_bit.blood_dna_info = get_blood_dna_list()
		if(part.damage_color == blood_type.color)
			continue
		part.damage_color = blood_type.color
		// only these vars are affected by damage color so we can skip updates if none of them are set
		if(part.brutestate || part.is_husked || part.cached_bleed_rate)
			update_needed = TRUE

	if(update && update_needed)
		update_body_parts()

/mob/living/carbon/human/set_blood_type(input_type, update = TRUE)
	// force clowns to always have clown blood on april fools
	if(check_holidays(APRIL_FOOLS) && is_clown_job(mind?.assigned_role))
		input_type = /datum/blood_type/clown

	return ..()

/// Resets the blood type to the initial blood type, which is determined by species and DNA.
/mob/living/proc/reset_blood_type(update = TRUE)
	set_blood_type(initial_blood_type, update)

/mob/living/carbon/reset_blood_type(update = TRUE)
	set_blood_type(initial(dna.species.exotic_bloodtype) || dna.human_blood_type || random_human_blood_type(), update)

/// Do we have (mechanical) blood?
/mob/living/proc/has_blood()
	if(HAS_TRAIT(src, TRAIT_HUSK) || HAS_TRAIT(src, TRAIT_NOBLOOD))
		return FALSE
	if(isnull(blood_type))
		return FALSE
	return TRUE

/**
 * Create a splat of this mob's life juice
 * Does nothing if the mob does not have a blood type set
 * DOES work if the mob does not actually have blood but does have a blood type
 *
 * * blood_turf - where to make the splatter. defaults to the current turf
 * * small_drip - whether to make a small drip or a big splat
 */
/mob/living/proc/add_splatter_floor(turf/blood_turf = get_turf(src), small_drip)
	if(isnull(blood_type))
		return
	return blood_type.make_blood_splatter(blood_turf, small_drip, get_blood_dna_list(), get_static_viruses())

/**
 * Create a visual effect of this mob's blood splattering in a direction
 * Does nothing if the mob does not have a blood type set
 * DOES work if the mob does not actually have blood but does have a blood type
 *
 * * splat_dir - the direction to splatter in. defaults to a random cardinal direction
 */
/mob/living/proc/do_splatter_effect(splat_dir = pick(GLOB.cardinals))
	if(isnull(blood_type))
		return
	var/obj/effect/temp_visual/dir_setting/bloodsplatter/splatter = new(get_turf(src), splat_dir)
	splatter.color = blood_type.color

// NON-MODULE CHANGE END

/mob/living/proc/get_blood_alcohol_content()
	var/blood_alcohol_content = 0
	var/datum/status_effect/inebriated/inebriation = has_status_effect(/datum/status_effect/inebriated)
	if(!isnull(inebriation))
		blood_alcohol_content = round(inebriation.drunk_value * DRUNK_POWER_TO_BLOOD_ALCOHOL, 0.01)

	return blood_alcohol_content

#undef BLOOD_DRIP_RATE_MOD
#undef DRUNK_POWER_TO_BLOOD_ALCOHOL
