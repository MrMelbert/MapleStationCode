/// Should return a list of all mana pools that this datum can access at the given moment. Defaults to returning leylines.
/datum/proc/get_available_mana(list/datum/attunement/attunements = GLOB.default_attunements)
	RETURN_TYPE(/list/datum/mana_pool)
	return SSmagic.get_all_leyline_mana()

/// If this mob is casting/using something that costs mana, it should always multiply the cost against this.
/mob/proc/get_casting_cost_mult()
	return BASE_STORY_MAGIC_CAST_COST_MULT

/mob/living/carbon/get_casting_cost_mult()
	. = ..()
	var/obj/item/held_item = get_active_held_item() || get_inactive_held_item()
	if (isnull(held_item) || (held_item.item_flags & (ABSTRACT|HAND_ITEM)))
		. *= NO_CATALYST_COST_MULT
