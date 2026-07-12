/// Can this mob smell things?
/mob/proc/can_smell()
	if(HAS_TRAIT(src, TRAIT_ANOSMIA))
		return FALSE

	if(stat == DEAD || HAS_TRAIT(src, TRAIT_KNOCKEDOUT))
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

#define SPACE_INPUT(input) ("[input ? " [input] " : " "]")

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
			if(all_smells[all_smells[correct_index - 1]] > effective_intensity)
				break
			correct_index -= 1
		if(correct_index != original_index)
			all_smells.Swap(original_index, correct_index)

	if(!length(all_smells))
		return

	var/list/collected_smell_info = list()
	var/highest_intensity = all_smells[all_smells[1]]
	var/formatted_smell = ""

	for(var/i in 1 to length(all_smells))
		var/datum/smell/smell_effect = all_smells[i]
		var/smell_intensity = all_smells[smell_effect]
		if(smell_intensity < 1)
			continue
		// subsequent smells have a chance to be ignored based on how strong the highest intensity smell is
		if(i > 1 && prob(50 + highest_intensity - smell_intensity))
			break

		smell_effect.on_smell(src, smell_intensity)

		var/smell_adjective = smell_effect.get_adjective(src, smell_intensity)
		var/smell_category = smell_effect.get_category(src, smell_intensity)

		collected_smell_info[smell_adjective] ||= list()
		collected_smell_info[smell_adjective][smell_category] ||= list()
		collected_smell_info[smell_adjective][smell_category] += smell_effect.text

		// every time you smell something, further smells are -2 intensity, which compounds
		LAZYADDASSOC(recently_smelled, smell_effect, 2)
		// after 5 minutes of not smelling it, we lose all acclimation to it.
		// however the reset timer is restarted each time we smell it
		addtimer(CALLBACK(src, PROC_REF(remove_recent_smell), smell_effect), 5 MINUTES, TIMER_UNIQUE|TIMER_DELETE_ME|TIMER_OVERRIDE)

	// now we need to stringify the smells
	// smells are grouped by category and adjective so we can output them in a more natural way.
	// e.g. "a strong stench of decay and blood and a faint smell of perfume"
	// instead of "a strong stench of decay, a strong stench of blood, and a faint smell of perfume"

	if(length(collected_smell_info) == 1)
		var/only_adjective = collected_smell_info[1]
		var/only_category = collected_smell_info[only_adjective][1]
		var/only_smells = collected_smell_info[only_adjective][only_category]
		if(only_adjective)
			formatted_smell = "\A [only_adjective] [only_category] of [english_list(only_smells)]"
		else
			formatted_smell = "\A [only_category] of [english_list(only_smells)]"

	else
		for(var/adjective in collected_smell_info)
			for(var/category, smell_effects in collected_smell_info[adjective])
				if(formatted_smell)
					if(adjective == collected_smell_info[length(collected_smell_info)])
						formatted_smell += " and the[SPACE_INPUT(adjective)][category] of [english_list(smell_effects)]"
					else
						formatted_smell += ", the[SPACE_INPUT(adjective)][category] of [english_list(smell_effects)]"
				else
					formatted_smell = "The[SPACE_INPUT(adjective)][category] of [english_list(smell_effects)]"

	to_chat(src, span_smallnoticeital("[formatted_smell] [(mob_biotypes & MOB_ORGANIC) ? "fills the air around you" : "is detected nearby"]."))
	COOLDOWN_START(src, smell_cd, clamp((15 MINUTES) / (values_sum(all_smells) / LAZYLEN(all_smells)), 30 SECONDS, 5 MINUTES))

/mob/living/proc/remove_recent_smell(datum/smell/smell_effect)
	LAZYREMOVE(recently_smelled, smell_effect)

#undef SPACE_INPUT

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

/// A helper proc to add smells that abstracts away the component vs element details,
/// since most callers won't care about the implementation details
/atom/proc/add_smell(
	smell,
	intensity,
	radius,
	category,
	duration,
	base_type,
	wash_type,
	is_fading,
	clear_signals,
)
	ASSERT(istext(smell) || ispath(smell), "Smell must be a string or a path to a /datum/smell")
	ASSERT(intensity > 0, "Smell intensity must be greater than 0")
	ASSERT(radius >= 0, "Smell radius must be 0 or greater")
	ASSERT(isnull(duration) || isnum(duration), "Smell duration must be a number or null")
	ASSERT(isnull(category) || istext(category), "Smell category must be a string or null")
	ASSERT(isnull(base_type) || ispath(base_type), "Smell base type must be a path to a /datum/smell or null")
	ASSERT(isnull(wash_type) || isnum(wash_type), "Smell wash type must be a wash type flag or null")
	ASSERT(isnull(is_fading) || isnum(is_fading), "Smell fading must be a boolean or null")
	ASSERT(isnull(clear_signals) || islist(clear_signals), "Smell clear signals must be a list or null")

	var/use_complex = duration || is_fading || wash_type || length(clear_signals)
	if(isitem(src))
		var/obj/item/wearable = src
		if(wearable.slot_flags)
			use_complex = TRUE

	if(use_complex)
		AddComponent(/datum/component/complex_smell, \
			duration = duration, \
			smell = smell, \
			intensity = intensity, \
			radius = radius, \
			category = category, \
			smell_basetype = base_type, \
			wash_types = wash_type, \
			fade_intensity_over_time = is_fading, \
			clear_signals = clear_signals, \
		)
	else
		AddElement(/datum/element/simple_smell, \
			smell = smell, \
			intensity = intensity, \
			radius = radius, \
			category = category, \
			smell_basetype = base_type, \
		)

/area/add_smell(...)
	CRASH("Areas do not support smells")
