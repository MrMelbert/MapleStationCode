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

/obj/item/organ/internal/heart/get_status_text(advanced, add_tooltips)
	if(!beating && !(organ_flags & ORGAN_FAILING) && owner.needs_heart() && owner.stat != DEAD)
		. = "<font color='#cc3333'>Cardiac Arrest</font>"
		if(add_tooltips)
			. = span_tooltip("Apply defibrillation immediately. Similar electric shocks may work in emergencies.", .)
		return .
	return ..()
