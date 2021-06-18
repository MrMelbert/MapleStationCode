/datum/disease/hypothermia
	name = "Hypothermia"
	max_stages = 3
	spread_text = "None"
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	cure_text = "Warm the body up with careful monitoring."
	agent = "Long exposure to extremely cold conditions."
	viable_mobtypes = list(/mob/living/carbon/human)
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	desc = "Sever exposure to the cold. If subject is suffering from frostbite, amputation may be required."
	severity = DISEASE_SEVERITY_HARMFUL
	bypasses_immunity = TRUE

/datum/disease/hyperthermia/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return
	switch(stage)
		if(1 to 2)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, "<span class='danger'>You feel exceptionally hot.</span>")
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, "<span class='danger'>You feel nauseous.</span>")
			if(DT_PROB(0.5, delta_time))
				to_chat(affected_mob, "<span class='danger'>You're sweating profusely.</span>")
			if(DT_PROB(2.5, delta_time))
				affected_mob.vomit(95)
		if(3)
			if(DT_PROB(3, delta_time))
				to_chat(affected_mob, "<span class='danger'>You lose consciousness...</span>")
				affected_mob.visible_message("<span class='warning'>[affected_mob] suddenly collapses!</span>", \
											"<span class='userdanger'>You suddenly collapse!</span>")
				affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5, 170)
				affected_mob.Unconscious(rand(100, 200))
			if(prob(1))
				affected_mob.emote("snore")
