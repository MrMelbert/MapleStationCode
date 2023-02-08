/datum/mana_holder
	var/max_mana_capacity

	var/datum/mana_group/stored_mana

/datum/mana_holder/New()
	. = ..()

	max_mana_capacity = generate_initial_capacity()
	initialize_mana()

/datum/mana_holder/Destroy(force, ...)
	. = ..()

	qdel(stored_mana)
	stored_mana = null

/datum/mana_holder/proc/adjust_mana(amount, list/incoming_attunements = get_attunements())
	return stored_mana.adjust_mana(amount, incoming_attunements)

/datum/mana_holder/proc/get_attunements()
	return stored_mana.attunements

/datum/mana_holder/proc/get_stored_mana()
	return stored_mana

/datum/mana_holder/proc/initialize_mana()
	stored_mana = new /datum/mana_group(get_initial_mana_amount(), get_initial_attunements())
	return stored_mana

/datum/mana_holder/proc/get_initial_attunements()
	return GLOB.magic_attunements.Copy()

/datum/mana_holder/proc/get_initial_mana_amount()
	return max_mana_capacity

/datum/mana_holder/proc/generate_initial_capacity()
	return 0

// Todo: Move these

/mob/proc/get_base_casting_cost()
	return BASE_STORY_MAGIC_CAST_COST_MULT

/mob/living/carbon/get_base_casting_cost()
	. = ..()
	var/obj/held_item = src.get_active_held_item()
	if (!held_item)
		. *= NO_CATALYST_COST_MULT
