/obj/item/organ/internal/heart/Stop()
	if(!beating)
		return

	. = ..()
	if(!. || !owner)
		return

	owner.apply_status_effect(/datum/status_effect/heart_attack)

/obj/item/organ/internal/heart/Restart()
	if(beating)
		return

	. = ..()
	if(!. || !owner)
		return

	owner.remove_status_effect(/datum/status_effect/heart_attack)

/obj/item/organ/internal/heart/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	if(beating)
		organ_owner.remove_status_effect(/datum/status_effect/heart_attack)

/obj/item/organ/internal/heart/on_mob_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	if(!special)
		organ_owner.apply_status_effect(/datum/status_effect/heart_attack)

// Glands can't stop beating but they are cringe
/obj/item/organ/internal/heart/gland/Stop()
	return FALSE

/*
// I think this is un-necessary, so I'm commenting it out even if it's SUPPOSED to be a thing
/mob/living/carbon/human/setup_organless_effects()
	. = ..()
	// You don't spawn with a heart, so, technically... You spawn with a heart attack
	apply_status_effect(/datum/status_effect/heart_attack)
*/

/obj/item/organ/internal/heart/get_status_text()
	if(!beating && !(organ_flags & ORGAN_FAILING) && owner.needs_heart() && owner.stat != DEAD)
		return "<font color='#cc3333'>Cardiac Arrest - Apply defibrillation!</font>"
	return ..()
