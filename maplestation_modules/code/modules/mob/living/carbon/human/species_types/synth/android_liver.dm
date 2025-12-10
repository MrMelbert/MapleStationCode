/obj/item/organ/liver/android
	name = "android liver"
	desc = "An electronic device designed to mimic the functions of a human liver. Immune to most toxins, though its filtering capabilities are limited."
	icon_state = /obj/item/organ/liver/cybernetic/tier2::icon_state
	filterToxins = FALSE
	organ_flags = ORGAN_ROBOTIC|ORGAN_UNREMOVABLE // future todo : if this is ever removable, we need to handle toxins another way

	var/toxicty = 0

/obj/item/organ/liver/android/handle_chemical(mob/living/carbon/organ_owner, datum/reagent/chem, seconds_per_tick, times_fired)
	if(organ_flags & ORGAN_FAILING)
		return NONE

	// we don't take tox damage from toxins! instead, it builds up toxicity that has adverse effects later
	if(istype(chem, /datum/reagent/toxin))
		var/datum/reagent/toxin/toxin_chem = chem
		increase_toxicity(toxin_chem.toxpwr * seconds_per_tick)

	return NONE

/obj/item/organ/liver/android/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(!toxicty)
		return
	if(owner?.reagents?.has_reagent(/datum/reagent/toxin, check_subtypes = TRUE))
		return
	decrease_toxicity(0.1 * seconds_per_tick)

/obj/item/organ/liver/android/proc/increase_toxicity(amount)
	toxicty += amount
	update_toxicity()

/obj/item/organ/liver/android/proc/decrease_toxicity(amount)
	if(!toxicty)
		return

	toxicty = max(0, toxicty - amount)
	update_toxicity()

/obj/item/organ/liver/android/proc/update_toxicity()
	return // add effects later
