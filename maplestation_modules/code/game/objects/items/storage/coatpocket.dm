/datum/storage/coatpocket
	max_slots = 3
	max_specific_storage = WEIGHT_CLASS_SMALL

/datum/storage/coatpocket/can_insert(obj/item/to_insert, mob/user, messages, force)
	. = ..()
	if(!.)
		return FALSE
	if(to_insert.atom_storage && to_insert.w_class >= max_specific_storage)
		if(messages && user)
			parent.balloon_alert(user, "too big!")
		return FALSE
	return TRUE
