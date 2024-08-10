GLOBAL_LIST_EMPTY(dead_players_during_shift)
/mob/living/carbon/human/gib_animation()
	new /obj/effect/temp_visual/gib_animation(loc, dna.species.gib_anim)

/mob/living/carbon/human/dust_animation()
	new /obj/effect/temp_visual/dust_animation(loc, dna.species.dust_anim)

/mob/living/carbon/human/spawn_gibs(drop_bitflags=NONE)
	if(flags_1 & HOLOGRAM_1)
		return
	if(drop_bitflags & DROP_BODYPARTS)
		new /obj/effect/gibspawner/human(drop_location(), src, get_static_viruses())
	else
		new /obj/effect/gibspawner/human/bodypartless(drop_location(), src, get_static_viruses())

/mob/living/carbon/human/spawn_dust(just_ash = FALSE)
	if(just_ash)
		new /obj/effect/decal/cleanable/ash(loc)
	else
		new /obj/effect/decal/remains/human(loc)

/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD)
		return
	var/obj/item/organ/internal/heart/human_heart = get_organ_slot(ORGAN_SLOT_HEART)
	human_heart?.Stop()

	. = ..()

	if(client && !HAS_TRAIT(src, TRAIT_SUICIDED) && !(client in GLOB.dead_players_during_shift))
		GLOB.dead_players_during_shift += client

	if(SSticker.HasRoundStarted())
		SSblackbox.ReportDeath(src)
		log_message("has died (BRUTE: [src.getBruteLoss()], BURN: [src.getFireLoss()], TOX: [src.getToxLoss()], OXY: [src.getOxyLoss()]", LOG_ATTACK)
		if(key) // Prevents log spamming of keyless mob deaths (like xenobio monkeys)
			investigate_log("has died at [loc_name(src)].<br>\
				BRUTE: [src.getBruteLoss()] BURN: [src.getFireLoss()] TOX: [src.getToxLoss()] OXY: [src.getOxyLoss()] STAM: [src.getStaminaLoss()]<br>\
				<b>Brain damage</b>: [src.get_organ_loss(ORGAN_SLOT_BRAIN) || "0"]<br>\
				<b>Blood volume</b>: [src.blood_volume]cl ([round((src.blood_volume / BLOOD_VOLUME_NORMAL) * 100, 0.1)]%)<br>\
				<b>Reagents</b>:<br>[reagents_readout()]", INVESTIGATE_DEATHS)

	var/death_block = ""
	death_block += span_danger("<center><span style='font-size: 32px'>You have died of [get_cause_of_death()].</font></center>")
	death_block += "<hr>"
	death_block += span_danger("Barring complete bodyloss, you can (in most cases) be revived by other players. \
		If you do not wish to be brought back, use the \"Do Not Resuscitate\" verb in the ghost tab.")
	to_chat(src, examine_block(death_block))

/mob/living/carbon/human/proc/get_cause_of_death(probable_cause)
	if(!probable_cause)
		var/most_negative_val
		for(var/key in consciousness_modifiers)
			var/contribution = consciousness_modifiers[key]
			if(contribution > -5)
				continue
			if(!probable_cause || contribution < most_negative_val)
				probable_cause = key
				most_negative_val = contribution
		for(var/key in max_consciousness_values)
			var/contribution = max_consciousness_values[key] - 100
			if(contribution > -40)
				continue
			if(!probable_cause || contribution < most_negative_val)
				probable_cause = key
				most_negative_val = contribution

	switch(probable_cause)
		if("oxy")
			return "suffocation"
		if("brain_damage")
			return "brain damage"
		if("blood")
			return "blood loss"
		if("tox")
			return "toxic poisoning"
		if("brute")
			return "blunt trauma"
		if("burn")
			return "severe burns"
		if("pain")
			return "pain"
		if("shock")
			return "neurological shock"
		if("heart_attack")
			return "a heart attack"
		if("drunk")
			return "alcohol poisoning"
		if("hunger")
			return "starvation"
		if("thermia")
			if(bodytemperature < get_body_temp_normal())
				return "hypothermia"
			return "hyperthermia"

	if(findtext(probable_cause, "disease"))
		return "disease"
	if(findtext(probable_cause, "addiction"))
		return "addiction"

	return "unknown causes"

/mob/living/carbon/human/proc/reagents_readout()
	var/readout = "Blood:"
	for(var/datum/reagent/reagent in reagents?.reagent_list)
		readout += "<br>[round(reagent.volume, 0.001)] units of [reagent.name]"

	readout += "<br>Stomach:"
	var/obj/item/organ/internal/stomach/belly = get_organ_slot(ORGAN_SLOT_STOMACH)
	for(var/datum/reagent/bile in belly?.reagents?.reagent_list)
		if(!belly.food_reagents[bile.type])
			readout += "<br>[round(bile.volume, 0.001)] units of [bile.name]"

	return readout

/mob/living/carbon/human/proc/makeSkeleton()
	ADD_TRAIT(src, TRAIT_DISFIGURED, TRAIT_GENERIC)
	set_species(/datum/species/skeleton)
	return TRUE

/mob/living/carbon/proc/Drain()
	become_husk(CHANGELING_DRAIN)
	ADD_TRAIT(src, TRAIT_BADDNA, CHANGELING_DRAIN)
	blood_volume = 0
	return TRUE
