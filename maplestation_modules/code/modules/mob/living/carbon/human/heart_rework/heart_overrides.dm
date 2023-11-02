/mob/living/carbon/human/setup_organless_effects()
	. = ..()
	// You don't spawn with a heart, so, technically... You spawn with a heart attack
	apply_status_effect(/datum/status_effect/heart_attack)

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

/obj/item/organ/internal/heart/on_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	if(beating)
		organ_owner.remove_status_effect(/datum/status_effect/heart_attack)

/obj/item/organ/internal/heart/on_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	if(!special)
		organ_owner.apply_status_effect(/datum/status_effect/heart_attack)

// Glands can't stop beating but they are cringe
/obj/item/organ/internal/heart/gland/Stop()
	return FALSE
