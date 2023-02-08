/mob/proc/get_base_casting_cost()
	return BASE_STORY_MAGIC_CAST_COST_MULT

/mob/living/carbon/get_base_casting_cost()
	. = ..()
	var/obj/held_item = src.get_active_held_item()
	if (!held_item)
		. *= NO_CATALYST_COST_MULT
