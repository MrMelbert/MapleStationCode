/obj/structure/closet/psychicchamber
	name = "psychic energy accumulation chamber"
	desc = "A specialized psychic chamber (locker) lined with magic materials (reflective metals and trace volite) made to amplify and collect the psychic energy emanated by your brain (make you instensely hallucinate and regenerate mana reserves)"
	icon_state = "abductor"
	icon_door = "abductor"
	can_weld_shut = FALSE
	door_anim_time = 0

/obj/structure/closet/psychicchamber/proc/apply_effects(mob/living/target)
	if(!target.incapacitated(IGNORE_STASIS)) // CHANGE THIS TO CHECK THINGS THAT WOULD PREVENT YOU FROM GETTING GEEKED
		target.apply_status_effect(/datum/status_effect/grouped/stasis, REF(src))
		to_chat(target, span_notice("You feel a cold, numbing sensation..."))
	//RegisterSignal(target, COMSIG_LIVING_EARLY_UNARMED_ATTACK, PROC_REF(skip_to_attack_hand))
