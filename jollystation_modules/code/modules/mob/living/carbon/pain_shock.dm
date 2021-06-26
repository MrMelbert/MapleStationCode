// -- Shock from too much pain. --
/datum/disease/shock
	form = "Condition"
	name = "Shock"
	spread_text = "Neurogenic" // Only model pain shock
	max_stages = 3
	stage_prob = 0.5
	cure_text = "Maintain a high body temperature, stop blood loss, and provide pain relievers while monitoring closely."
	agent = "Pain"
	viable_mobtypes = list(/mob/living/carbon/human)
	permeability_mod = 1
	desc = "Occurs when a subject enters a state of shock due to high pain, blood loss, heart difficulties, and other injuries. \
		If left untreated the subject may experience Cardiac Arrest."
	severity = DISEASE_SEVERITY_DANGEROUS
	disease_flags = CAN_CARRY|CAN_RESIST
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	visibility_flags = HIDDEN_PANDEMIC
	bypasses_immunity = TRUE

/datum/disease/shock/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	var/treatments = 0
	if(affected_mob.bodytemperature > BODYTEMP_COLD_DAMAGE_LIMIT)
		(stage > 2) ? (stage = 2) : (treatments++)

	if(!affected_mob.is_bleeding())
		(stage > 2) ? (stage = 2) : (treatments++)

	if(affected_mob.pain_controller.get_average_pain() < 45)
		(stage > 2) ? (stage = 2) : (treatments += 2)

	if(treatments >= 3) // As soon as they get their pain managed, stop bleeding, and have regular body temperature, the shock is cured
		to_chat(affected_mob, span_bold(span_green("You body feel active and awake again!")))
		cure()
		return FALSE

	switch(stage)
		// compensated (or nonprogressive) - still able to sustain themselves
		// - agitation, anxiety
		// - nausea or vomiting
		// - chills
		if(1)
			if(DT_PROB(0.5, delta_time))
				to_chat(affected_mob, span_danger("Your chest feels uncomfortable."))
				affected_mob.flash_pain_overlay(1)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_danger("You feel nauseous."))
				if(prob(50))
					affected_mob.vomit(35, stun = FALSE)
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, span_danger("You feel anxious."))
				affected_mob.jitteriness += rand(6,8)
			var/datum/species/our_species = affected_mob.dna?.species
			if(our_species)
				if(DT_PROB(10, delta_time))
					to_chat(affected_mob, span_danger("You feel cold."))
				affected_mob.adjust_bodytemperature(-5 * delta_time, our_species.bodytemp_cold_damage_limit + 5) // Not lethal

		// decompensated (or progressive) - unable to maintain themselves
		// - mental issues
		// - difficulty breathing / high heart rate
		// - decrease in body temperature
		if(2)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, span_danger("Your chest feels wrong!"))
				affected_mob.flash_pain_overlay(2)
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, span_danger("You can't focus on anything!"))
				affected_mob.add_confusion(rand(4,8))
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, span_danger("You're having difficulties breathing!"))
				affected_mob.losebreath = clamp(affected_mob.losebreath + 4, 0, 12)
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, span_danger("You skip a breath!"))
				affected_mob.adjustOxyLoss(rand(5, 15))
			var/datum/species/our_species = affected_mob.dna?.species
			if(our_species)
				if(DT_PROB(12, delta_time))
					to_chat(affected_mob, span_danger("You feel freezing!"))
				affected_mob.adjust_bodytemperature(-10 * delta_time, our_species.bodytemp_cold_damage_limit - 20) // uh oh

		// irreversible - point of no return, system failure
		// cardiac arrest
		if(3)
			if(DT_PROB(33, delta_time))
				affected_mob.set_heartattack(TRUE)
				cure()
			else if(DT_PROB(10, delta_time))
				to_chat(affected_mob, span_userdanger(pick("You feel your heart skip a beat...", "You feel your body shutting down...", "You feel your heart beat irregularly...")))
