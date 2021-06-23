/datum/disease/hypothermia
	name = "Hypothermia"
	max_stages = 4
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
		if(1)
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, "<span class='danger'>You shiver.</span>")
			if(DT_PROB(1, delta_time))
				to_chat(affected_mob, "<span class='danger'>You feel cold.</span>")
		if(2)
			if(DT_PROB(0.5, delta_time))
				to_chat(affected_mob, "<span class='danger'>Your appendages feel numb.</span>")
			if(DT_PROB(1.5, delta_time))
				to_chat(affected_mob, "<span class='danger'>You shiver more.</span>")
		if(3)
			if(DT_PROB(1.5, delta_time))
				to_chat(affected_mob, "<span class='danger'>Your appendages feel numb.</span>")
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, "<span class='danger'>You shiver violently.</span>")
			//Damage proc to a random limb, burn damage, DT_PROB(1)
			//Movement speed multiplier, possibly a 0.8
		if(4)
			if(DT_PROB(0.5, delta_time))
				to_chat(affected_mob, "<span class='danger'>Your appendages feel numb.</span>")
			if(DT_PROB(1.5, delta_time))
				to_chat(affected_mob, "<span class='danger'>You shiver more.</span>")
			//Damage proc to a random limb, burn damage, DT_PROB(2), increased burn damage per tick
			//Chance to disable a random limb (scale with damage?)
			//Movement speed multiplier, possibly a 0.55
