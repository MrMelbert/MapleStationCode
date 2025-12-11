/obj/item/organ/liver/android
	name = "android filtration system"
	desc = "An electronic device which filters toxins out of a synthetic's cooling, fueling, and power systems. \
		An excess of toxins may cause the filters to clog, resulting in reduced performance until flushed with clean fluids."
	icon_state = /obj/item/organ/liver/cybernetic/tier2::icon_state
	filterToxins = FALSE
	organ_flags = ORGAN_ROBOTIC|ORGAN_UNREMOVABLE // future todo : if this is ever removable, we need to handle toxins another way

	alcohol_tolerance = 0

	var/toxicty = 0
	var/last_toxic_warning = 0

/obj/item/organ/liver/android/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	apply_organ_damage(10 / severity)

/obj/item/organ/liver/android/handle_chemical(mob/living/carbon/organ_owner, datum/reagent/chem, seconds_per_tick, times_fired)
	if(organ_flags & ORGAN_FAILING)
		return NONE

	// we don't take tox damage from toxins! instead, it builds up toxicity that has adverse effects later
	if(istype(chem, /datum/reagent/toxin))
		var/datum/reagent/toxin/toxin_chem = chem
		increase_toxicity(toxin_chem.toxpwr * seconds_per_tick)

	if(chem.chemical_flags & REAGENT_CLEANS)
		decrease_toxicity(0.5 * seconds_per_tick)

	return NONE

/obj/item/organ/liver/android/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(!toxicty)
		return
	owner.adjust_body_temperature(0.5 KELVIN * (toxicty / 50) * seconds_per_tick, max_temp = owner.bodytemp_heat_damage_limit * 1.5) // overheating from toxicity
	if(owner?.reagents?.has_reagent(/datum/reagent/toxin, check_subtypes = TRUE))
		return
	if(organ_flags & (ORGAN_FAILING|ORGAN_EMP))
		return
	decrease_toxicity(0.1 * seconds_per_tick)

/obj/item/organ/liver/android/proc/increase_toxicity(amount)
	toxicty = min(100, toxicty + amount)
	update_toxicity()

	switch(toxicty)
		if(66 to 100)
			if(last_toxic_warning != 3)
				last_toxic_warning = 3
				to_chat(owner, span_warning("Warning: Toxicity levels critical. Flushing systems with water or cleanser is advised."))
		if(33 to 66)
			if(last_toxic_warning != 2)
				last_toxic_warning = 2
				to_chat(owner, span_warning("Caution: Elevated toxicity levels detected. Consider flushing systems with water or cleanser."))
		if(16 to 33)
			if(last_toxic_warning != 1)
				last_toxic_warning = 1
				to_chat(owner, span_warning("Notice: Mild toxicity levels present. Regular maintenance recommended."))

/obj/item/organ/liver/android/proc/decrease_toxicity(amount)
	if(!toxicty)
		return

	toxicty = max(0, toxicty - amount)
	update_toxicity()

	switch(toxicty)
		if(0 to 16)
			if(last_toxic_warning > 0)
				last_toxic_warning = 0
				to_chat(owner, span_notice("Notice: Toxicity flush complete. Systems operating within normal parameters."))
		if(16 to 33)
			if(last_toxic_warning > 1)
				last_toxic_warning = 1
				to_chat(owner, span_notice("Notice: Toxicity levels have lowered to levels within reason. Continued maintenance recommended."))
		if(33 to 66)
			if(last_toxic_warning > 2)
				last_toxic_warning = 2
				to_chat(owner, span_notice("Caution: Toxicity levels have decreased but remain elevated. Further flushing recommended."))

/obj/item/organ/liver/android/proc/update_toxicity(mob/living/carbon/organ_owner = owner)
	switch(toxicty)
		if(66 to 100)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/android_toxicity/high)
			owner.add_mood_event("toxicity", /datum/mood_event/android_filters_major)
		if(33 to 66)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/android_toxicity/low)
			owner.add_mood_event("toxicity", /datum/mood_event/android_filters_minor)
		else
			owner.remove_movespeed_modifier(/datum/movespeed_modifier/android_toxicity)
			owner.clear_mood_event("toxicity")

	if(toxicty > 33)
		owner.add_max_consciousness_value("toxicity", 133 - toxicty)
	else
		owner.remove_max_consciousness_value("toxicity")

/obj/item/organ/liver/android/on_mob_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	update_toxicity(organ_owner)
	RegisterSignal(organ_owner, COMSIG_LIVING_HEALTHSCAN, PROC_REF(on_scan))

/obj/item/organ/liver/android/on_mob_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	organ_owner.remove_movespeed_modifier(/datum/movespeed_modifier/android_toxicity)
	organ_owner.clear_mood_event("toxicity")
	organ_owner.remove_max_consciousness_value("toxicity")
	UnregisterSignal(organ_owner, COMSIG_LIVING_HEALTHSCAN)

/obj/item/organ/liver/android/proc/on_scan(datum/source, list/render_list, advanced, mob/user, mode, tochat)
	SIGNAL_HANDLER

	if(toxicty < 33)
		return
	render_list += "<span class='alert ml-1'>"
	render_list += conditional_tooltip("Filtration systems clogged.", "Flush system with cleansing reagents, such as water or cleaner.", tochat)
	render_list += "</span><br>"

/datum/movespeed_modifier/android_toxicity
	id = "android_toxicity"

/datum/movespeed_modifier/android_toxicity/low
	multiplicative_slowdown = 1.1

/datum/movespeed_modifier/android_toxicity/high
	multiplicative_slowdown = 1.25

/datum/mood_event/android_filters_major
	description = "Filtration systems are clogged with toxins. I should flush them out with cleaner."
	mood_change = -12

/datum/mood_event/android_filters_minor
	description = "Filtration systems are partially clogged. A flush with cleaner would be beneficial."
	mood_change = -4
