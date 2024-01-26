/// Subtype of autosurgeons that only function if used on missing or heavily damaged organs.
/obj/item/autosurgeon/only_on_damaged_organs
	surgery_speed = 1.25
	/// What organ slot do we check for damage?
	var/slot_to_check

/obj/item/autosurgeon/only_on_damaged_organs/attack_self(mob/user)
	return // cringe but this shouldn't be instant-use

/obj/item/autosurgeon/only_on_damaged_organs/load_organ(obj/item/organ/loaded_organ, mob/living/user)
	if(loaded_organ.slot == slot_to_check)
		return ..()

	to_chat(user, span_alert("[src] is not compatible with [loaded_organ]."))
	return FALSE

/obj/item/autosurgeon/only_on_damaged_organs/use_autosurgeon(mob/living/target, mob/living/user, implant_time)
	var/obj/item/organ/organ_to_check = target.get_organ_slot(slot_to_check)
	if(isnull(organ_to_check) || organ_to_check.damage >= organ_to_check.high_threshold)
		return ..()

	audible_message(span_warning("[src] buzzes: [target]'s [organ_to_check] is not damaged enough to warrant replacement."))
	playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
	return FALSE

/obj/item/autosurgeon/only_on_damaged_organs/lungs
	name = "lung emergency autosurgeon"
	desc = "A device that automatically implants a new set of lungs. \
		Only works on patients with heavily damaged or missing lungs."
	slot_to_check = ORGAN_SLOT_LUNGS

/obj/item/autosurgeon/only_on_damaged_organs/liver
	name = "liver emergency autosurgeon"
	desc = "A device that automatically implants a new liver. \
		Only works on patients with heavily damaged or missing livers."
	slot_to_check = ORGAN_SLOT_LIVER
