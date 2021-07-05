/datum/element/cold_pack
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/pain_heal_rate = 0
	var/pain_modifier_on_limb = 1

/datum/element/cold_pack/Attach(obj/target, pain_heal_rate = 0, pain_modifier_on_limb = 1)
	. = ..()

	if(!isobj(target))
		return ELEMENT_INCOMPATIBLE

	src.pain_heal_rate = pain_heal_rate
	src.pain_modifier_on_limb = pain_modifier_on_limb

	//COMSIG_ITEM_ATTACK_SECONDARY
