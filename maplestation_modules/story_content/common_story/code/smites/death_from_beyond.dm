/// Slashes up the target like bloodless, but SLOWLY
/datum/smite/death_from_beyond
	name = "Death from Beyond"
	var/strength
	var/how_many = 1

/datum/smite/death_from_beyond/configure(client/user)
	var/static/list/knowledge_forbidenness = list("Low", "Moderate", "High", "DEATH")
	strength = input(user, "How much do you hate this person?") in knowledge_forbidenness

/datum/smite/death_from_beyond/effect(client/user, mob/living/target)
	. = ..()
	if(!iscarbon(target))
		to_chat(user, span_warning("This must be used on a carbon mob."), confidential = TRUE)
		return
	var/mob/living/carbon/carbon_target = target

	switch(strength)
		if("Low")
			how_many = 3
		if("Moderate")
			how_many = 4
		if("High")
			how_many = 5
		if("DEATH")
			how_many = 10

	to_chat(target, span_boldwarning("Cuts rapidly appear all over you as entities from beyond start attacking you!"))

	ultra_murder(carbon_target)

/datum/smite/death_from_beyond/proc/ultra_murder(mob/living/carbon/carbon_target)
	var/picked_severity
	switch(strength)
		if("Low")
			picked_severity = pick_weight(list(
				WOUND_SEVERITY_MODERATE = 2,
				WOUND_SEVERITY_SEVERE = 1,
			))
		if("Moderate")
			picked_severity = pick_weight(list(
				WOUND_SEVERITY_MODERATE = 1,
				WOUND_SEVERITY_SEVERE = 2,
				WOUND_SEVERITY_CRITICAL = 1,
			))
		if("High")
			picked_severity = pick_weight(list(
				WOUND_SEVERITY_MODERATE = 1,
				WOUND_SEVERITY_SEVERE = 1,
				WOUND_SEVERITY_CRITICAL = 3,
			))
		if("DEATH")
			picked_severity = WOUND_SEVERITY_CRITICAL

	carbon_target.cause_wound_of_type_and_severity(WOUND_SLASH, null, picked_severity)
	how_many--
	if(how_many > 0)
		addtimer(CALLBACK(src, PROC_REF(ultra_murder), carbon_target), rand(0.5 SECONDS, 1 SECONDS), TIMER_DELETE_ME)
