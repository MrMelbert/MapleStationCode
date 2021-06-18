/datum/disease/hyperthermia
	name = "Hyperthermia"
	max_stages = 3
	spread_text = "None"
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	cure_text = "Cool down of the body and careful monitoring."
	agent = "Long exposure to extremely hot conditions."
	viable_mobtypes = list(/mob/living/carbon/human)
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	desc = "Sever heat exposure. Monitoring is required in case of vomiting and sudden collapses. If left untreated and in hot conditions for too long, brain damage may occur."
	severity = DISEASE_SEVERITY_HARMFUL
	bypasses_immunity = TRUE

/datum/disease/hyperthermia/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return
	switch(stage)
		if(1)
			if(DT_PROB(0.5, delta_time))
				affected_mob.vomit(5)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, "<span class='danger'>You feel exceptionally hot.</span>")
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, "<span class='danger'>You're sweating profusely.</span>")
		if(2)
			if(DT_PROB(1.5, delta_time))
				affected_mob.vomit(5)
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, "<span class='danger'>You feel nauseous.</span>")
		if(3)
			if(DT_PROB(1.5, delta_time))
				to_chat(affected_mob, "<span class='danger'>You feel faint.</span>")
			if(DT_PROB(2.5, delta_time))
				affected_mob.vomit(5)
			if(DT_PROB(3, delta_time))
				to_chat(affected_mob, "<span class='danger'>You feel nauseous.</span>")
		if(4)
			if(DT_PROB(3, delta_time))
				to_chat(affected_mob, "<span class='danger'>You lose consciousness...</span>")
				affected_mob.visible_message("<span class='warning'>[affected_mob] suddenly collapses!</span>", \
											"<span class='userdanger'>You suddenly collapse!</span>")
				affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5, 170)
				affected_mob.Unconscious(rand(100, 200))
			if(prob(1))
				affected_mob.emote("snore")
