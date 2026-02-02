/// Can this mob smell things?
/mob/proc/can_smell()
	if(HAS_TRAIT(src, TRAIT_ANOSMIA))
		return FALSE

	if(stat == DEAD)
		return FALSE

	return TRUE

/mob/living/can_smell()
	if(!..())
		return FALSE

	// Limiting it to a selection of biotypes for now
	// so I don't have to think about "can rocks smell" or whatever
	if(!(mob_biotypes & (MOB_ORGANIC|MOB_HUMANOID|MOB_ROBOTIC)))
		return FALSE

	return TRUE

/mob/living/carbon/human/can_smell()
	if(!..())
		return FALSE

	if(failed_last_breath || internal || external)
		return FALSE

	if(has_smoke_protection())
		return FALSE

	return TRUE

/// Attempt to smell things around us
/mob/living/proc/smell_something()
	if(!can_smell())
		return

	var/turf/open/smellable = get_turf(src)
	if(!istype(smellable))
		return

	var/datum/gas_mixture/air = smellable.return_air()
	var/total_moles = air?.total_moles()
	// can't smell if there's no air
	if(total_moles <= 0)
		return

	// the turf has its own smells affecting it, but we also need to factor in smells from gases present
	var/list/collective_smells_with_gasses = LAZYLISTDUPLICATE(smellable.collective_smells)
	var/pressuremod = 0
	for(var/datum/gas/gas_type as anything in air.gases)
		if(!gas_type::smell)
			continue

		pressuremod ||= clamp(round(air.return_pressure() / ONE_ATMOSPHERE, 0.1), 0.1, 4.0)
		var/datum/smell/gas_smell = get_smell(gas_type::smell)
		switch(air.gases[gas_type][MOLES] / total_moles)
			if(0.05 to 0.25)
				LAZYADDASSOC(collective_smells_with_gasses, gas_smell, (SMELL_INTENSITY_WEAK * pressuremod))
			if(0.25 to 0.5)
				LAZYADDASSOC(collective_smells_with_gasses, gas_smell, (SMELL_INTENSITY_MODERATE * pressuremod))
			if(0.5 to 0.75)
				LAZYADDASSOC(collective_smells_with_gasses, gas_smell, (SMELL_INTENSITY_STRONG * pressuremod))
			if(0.75 to 1.0)
				LAZYADDASSOC(collective_smells_with_gasses, gas_smell, (SMELL_INTENSITY_OVERPOWERING * pressuremod))

	if(!LAZYLEN(collective_smells_with_gasses))
		return

	// collect all smells currently being experienced sorted by effective intensity
	var/list/all_smells = list()
	var/obj/item/organ/tongue/tongue = get_organ_by_type(__IMPLIED_TYPE__)
	var/obj/item/organ/brain/brain = get_organ_by_type(__IMPLIED_TYPE__)

	for(var/smell_effect_untyped, smell_intensity in collective_smells_with_gasses)
		var/datum/smell/smell_effect = smell_effect_untyped
		var/effective_intensity = ceil(smell_intensity - LAZYACCESS(recently_smelled, smell_effect) + tongue?.smell_sensitivity + (brain?.damage * -0.1))
		if(effective_intensity <= 0 || !smell_effect.can_mob_smell(src))
			continue

		all_smells[smell_effect] += effective_intensity
		// insertion sort as we go to keep highest intensity first
		// this list is small, probably averages 4 elements. so it's fine
		var/original_index = all_smells.Find(smell_effect)
		var/correct_index = original_index
		while(correct_index > 1)
			if(all_smells[all_smells[correct_index - 1]] > all_smells[all_smells[correct_index]])
				break
			correct_index -= 1
		if(correct_index != original_index)
			all_smells.Swap(original_index, correct_index)

	if(!length(all_smells))
		return

	var/list/readable_smells = list()
	var/highest_intensity = all_smells[all_smells[1]]

	for(var/i in 1 to length(all_smells))
		var/datum/smell/smell_effect = all_smells[i]
		var/smell_intensity = all_smells[smell_effect]
		if(smell_intensity < 1)
			continue
		// subsequent smells have a chance to be ignored based on how strong the highest intensity smell is
		if(i > 1 && prob(50 + highest_intensity - smell_intensity))
			break

		smell_effect.on_smell(src, smell_intensity)
		readable_smells += smell_effect.format_smell(src, smell_intensity, solo = (length(all_smells) == 1))
		// every time you smell something, further smells are -2 intensity, which compounds
		LAZYADDASSOC(recently_smelled, smell_effect, 2)
		// after 5 minutes of not smelling it, we lose all acclimation to it.
		// however the reset timer is restarted each time we smell it
		addtimer(CALLBACK(src, PROC_REF(remove_recent_smell), smell_effect), 5 MINUTES, TIMER_UNIQUE|TIMER_DELETE_ME|TIMER_OVERRIDE)

	to_chat(src, span_smallnoticeital("[capitalize(english_list(readable_smells))] [(mob_biotypes & MOB_ORGANIC) ? "fills the air" : "detected"] around you."))
	COOLDOWN_START(src, smell_cd, clamp((15 MINUTES) / (values_sum(all_smells) / LAZYLEN(all_smells)), 30 SECONDS, 5 MINUTES))

/mob/living/proc/remove_recent_smell(datum/smell/smell_effect)
	LAZYREMOVE(recently_smelled, smell_effect)

/mob/living/carbon/human/death(gibbed, cause_of_death)
	. = ..()
	if(gibbed || HAS_TRAIT(src, TRAIT_NO_ORGAN_DECAY))
		return
	// ancient bodies found in ruins or space shouldn't be giving off fresh decay smells
	// of course this doesn't catch *all* of those cases but it should be good enough...
	if(!SSticker.HasRoundStarted())
		return

	AddComponent( \
		/datum/component/complex_smell, \
		duration = 30 MINUTES, \
		smell = /datum/smell/decay, \
		intensity = SMELL_INTENSITY_STRONG, \
		radius = 3, \
		clear_signals = list( \
			COMSIG_MOB_STATCHANGE, \
			SIGNAL_ADDTRAIT(TRAIT_NO_ORGAN_DECAY), \
		), \
	)
