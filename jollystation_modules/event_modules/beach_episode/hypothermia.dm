/datum/disease/hypothermia
	name = "Hypothermia"
	max_stages = 6
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	cure_text = "Warm the body up with careful monitoring."
	agent = "Long exposure to extremely cold conditions."
	viable_mobtypes = list(/mob/living/carbon/human)
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	desc = "Sever exposure to the cold. If subject is suffering from frostbite, amputation may be required."
	severity = DISEASE_SEVERITY_HARMFUL
	bypasses_immunity = TRUE

/datum/disease/hypothermia/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return
	switch(stage)
		if(1)
			if(DT_PROB(2.5, delta_time))
				to_chat(affected_mob, span_danger("You shiver."))
			if(DT_PROB(3, delta_time))
				to_chat(affected_mob, span_danger("You feel cold."))
		if(2)
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, span_danger("Your appendages feel numb."))
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, span_danger("You shiver more."))
		if(3)
			if(DT_PROB(1, delta_time))
				affected_mob.cause_pain(pick(BODY_ZONE_L_ARM), 2, BURN)
			if(DT_PROB(1, delta_time))
				affected_mob.cause_pain(BODY_ZONE_R_ARM, 2, BURN)
			if(DT_PROB(1, delta_time))
				affected_mob.cause_pain(BODY_ZONE_L_LEG, 2, BURN)
			if(DT_PROB(1, delta_time))
				affected_mob.cause_pain(BODY_ZONE_R_LEG, 2, BURN)
			if(DT_PROB(3, delta_time))
				to_chat(affected_mob, span_danger("Your appendages feel numb."))
			if(DT_PROB(2, delta_time))
				to_chat(affected_mob, span_danger("You shiver more."))
			if(DT_PROB(10, delta_time))
				affected_mob.add_movespeed_modifier(/datum/movespeed_modifier/hypothermia/stage_three)
		if(4)
			if(DT_PROB(4, delta_time))
				to_chat(affected_mob, span_danger("Your appendages feel numb."))
			if(DT_PROB(3, delta_time))
				to_chat(affected_mob, span_danger("Your nose feel numb."))
			if(DT_PROB(3, delta_time))
				to_chat(affected_mob, span_danger("Your fingers feel numb."))
			if(DT_PROB(3, delta_time))
				to_chat(affected_mob, span_danger("Your feet feel numb."))
			if(DT_PROB(3.5, delta_time))
				to_chat(affected_mob, span_danger("You shiver violently."))
		if(5)
			if(DT_PROB(10, delta_time))
				affected_mob.add_movespeed_modifier(/datum/movespeed_modifier/hypothermia/stage_four)
		if(6)
			if(DT_PROB(1, delta_time))
				affected_mob.apply_damage(7, BURN, pick(BODY_ZONE_L_ARM))
			if(DT_PROB(1, delta_time))
				affected_mob.apply_damage(7, BURN, pick(BODY_ZONE_R_ARM))
			if(DT_PROB(1, delta_time))
				affected_mob.apply_damage(7, BURN, pick(BODY_ZONE_L_LEG))
			if(DT_PROB(1, delta_time))
				affected_mob.apply_damage(7, BURN, pick(BODY_ZONE_R_LEG))

