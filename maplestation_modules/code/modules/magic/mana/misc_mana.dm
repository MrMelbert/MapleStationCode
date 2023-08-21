/// Should return a list of all mana pools that this datum can access at the given moment. Defaults to returning leylines.
/datum/proc/get_available_mana(list/datum/attunement/attunements = GLOB.default_attunements)
	RETURN_TYPE(/list/datum/mana_pool)
	return SSmagic.get_all_leyline_mana()

/// If this mob is casting/using something that costs mana, it should always multiply the cost against this.
/mob/proc/get_casting_cost_mult()
	return BASE_STORY_MAGIC_CAST_COST_MULT

/mob/living/carbon/get_casting_cost_mult()
	. = ..()
	for(var/obj/item/held_item in held_items)
		if (held_item.item_flags & (ABSTRACT|HAND_ITEM))
			continue
		// valid catalyst, apply no multiplier
		return

	// no catalyst, it costs more.
	. *= NO_CATALYST_COST_MULT
