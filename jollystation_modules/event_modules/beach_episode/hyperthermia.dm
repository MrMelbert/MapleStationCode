/datum/disease/hyperthermia
	name = "Hyperthermia"
	max_stages = 6
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	cure_text = "Cool down of the body and careful monitoring."
	agent = "Long exposure to extremely hot conditions."
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "Sever heat exposure. Monitoring is required in case of vomiting and sudden collapses. If left untreated and in hot conditions for too long, brain damage may occur."
	severity = DISEASE_SEVERITY_HARMFUL
	bypasses_immunity = TRUE

/datum/disease/hyperthermia/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return
	switch(stage)
		if(1)
			if(DT_PROB(1, delta_time))
				affected_mob.vomit(5)
			if(DT_PROB(3, delta_time))
				to_chat(affected_mob, span_danger("You feel queasy."))
			if(DT_PROB(3, delta_time))
				to_chat(affected_mob, span_danger("You're sweating profusely."))
			if(DT_PROB(3.5, delta_time))
				to_chat(affected_mob, span_danger("You feel exceptionally hot."))
		if(2)
			if(DT_PROB(1.5, delta_time))
				affected_mob.vomit(5)
			if(DT_PROB(3, delta_time))
				to_chat(affected_mob, span_danger("You feel nauseous."))
		if(3)
			if(DT_PROB(3, delta_time))
				affected_mob.vomit(5)
			if(DT_PROB(4, delta_time))
				to_chat(affected_mob, span_danger("You feel faint."))
			if(DT_PROB(5, delta_time))
				to_chat(affected_mob, span_danger("You feel nauseous."))
		if(4)
			if(DT_PROB(4, delta_time))
				to_chat(affected_mob, span_danger("This heat is killing you!"))
		if(5)
			if(DT_PROB(6, delta_time))
				to_chat(affected_mob, span_danger("You feel like you're about to collapse!"))
		if(6)
			if(DT_PROB(7, delta_time))
				to_chat(affected_mob, span_danger("You lose consciousness..."))
				affected_mob.visible_message(span_warning("[affected_mob] suddenly collapses!"), \
											span_userdanger("You suddenly collapse!"))
				affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5, 170)
				affected_mob.Unconscious(rand(100, 200))
				if(prob(1))
					affected_mob.emote("snore")
