// Magic altars: the general term for structures that are used as part of a process for generating mana
// this is where the base types of non-special ones and relevant documentation will be stored

/datum/mana_pool/magic_altar
	amount = 500
	max_donation_rate_per_second = 2 // pretty slow, but a solid source of mana

/datum/mana_pool/magic_altar/can_transfer(datum/mana_pool/target_pool)
	if (QDELETED(target_pool.parent))
		return FALSE
	var/obj/structure/magic_altar/altar = parent

	if (altar.loc == target_pool.parent.loc) // yeah sure i copypasta from battery code, but if you manage to occupy the same tile as an altar you deserve a guranteed transfer
		return TRUE

	if (get_dist(altar, target_pool.parent) > altar.max_allowed_transfer_distance)
		return FALSE
	return ..()

/obj/structure/magic_altar/
	name = "magic altar basetype"
	desc = "an honestly quite dull magic altar; actually better question, why is this visible in game? if you or an admin/coder aren't testing stuff this shouldn't be here"
	icon = 'maplestation_modules/icons/obj/magic/altars.dmi'
	icon_state = "goner"
	has_initial_mana_pool = TRUE
	var/max_allowed_transfer_distance = MAGIC_ALTAR_MAX_TRANSFER_DISTANCE

/obj/structure/magic_altar/get_initial_mana_pool_type()
	return /datum/mana_pool/magic_altar
