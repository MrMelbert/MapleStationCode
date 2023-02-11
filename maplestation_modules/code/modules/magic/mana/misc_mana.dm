/// Should return a list of all mana pools that this datum can access at the given moment. Defaults to returning leylines.
/datum/proc/get_available_mana(list/datum/attunement/attunements = GLOB.default_attunements.Copy())
	RETURN_TYPE(/list/datum/mana_pool)
	return SSmagic.get_all_leyline_mana()

/// If this mob is casting/using something that costs mana, it should always multiply the cost against this.
/mob/proc/get_casting_cost_mult()
	return BASE_STORY_MAGIC_CAST_COST_MULT

/mob/living/carbon/get_casting_cost_mult()
	. = ..()
	var/obj/held_item = src.get_active_held_item()
	if (!held_item)
		. *= NO_CATALYST_COST_MULT
