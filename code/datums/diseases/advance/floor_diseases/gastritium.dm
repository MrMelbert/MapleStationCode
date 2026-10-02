/// Caused by dirty food. Makes you burp out Tritium, sometimes burning hot!
/datum/disease/gastritium
	name = "Gastritium"
	desc = "If left untreated, may manifest in severe Tritium heartburn."
	form = "Bacteria"
	agent = "Atmobacter Polyri"
	cure_text = /datum/reagent/consumable/milk::name
	spread_text = "None"
	cures = list(/datum/reagent/consumable/milk)
	viable_mobtypes = list(/mob/living/carbon/human)
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	severity = DISEASE_SEVERITY_HARMFUL
	max_stages = 5
	required_organ = ORGAN_SLOT_STOMACH
	/// The chance of burped out tritium to be hot during max stage
	var/tritium_burp_hot_chance = 10

/datum/disease/gastritium/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(SPT_PROB(1, seconds_per_tick))
				affected_mob.emote("burp")
		if(3)
			if(SPT_PROB(1, seconds_per_tick) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("Your stomach makes turbine noises..."))
			else if(SPT_PROB(1, seconds_per_tick))
				affected_mob.emote("burp")
		if(4)
			if(SPT_PROB(1, seconds_per_tick) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("You're starting to feel like a burn chamber..."))
			else if(SPT_PROB(1, seconds_per_tick))
				tritium_burp()
		if(5)
			if(SPT_PROB(1, seconds_per_tick) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("You feel like you're about to delam..."))
			else if(SPT_PROB(1, seconds_per_tick))
				tritium_burp(hot_chance = TRUE)

	affected_mob.add_homeostasis_level(type, affected_mob.bodytemp_heat_damage_limit - 5 KELVIN, 0.5)

/datum/disease/gastritium/remove_disease()
	affected_mob.remove_homeostasis_level(type)
	return ..()

/datum/disease/gastritium/proc/tritium_burp(hot_chance = FALSE)
	var/datum/gas_mixture/burp = new
	burp.set_gas(/datum/gas/tritium, MOLES_GAS_VISIBLE)
	burp.temperature = affected_mob.body_temperature
	if(hot_chance && prob(tritium_burp_hot_chance))
		burp.set_temperature(TRITIUM_MINIMUM_BURN_TEMPERATURE)
		if(affected_mob.stat == CONSCIOUS)
			to_chat(affected_mob, span_warning("Your throat feels hot!"))
	affected_mob.visible_message("burps out green gas.", visible_message_flags = EMOTE_MESSAGE)
	affected_mob.loc.assume_air(burp)
