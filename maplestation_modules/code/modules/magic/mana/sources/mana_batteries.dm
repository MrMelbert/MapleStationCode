/obj/item/mana_battery
	name = "generic mana battery"

/obj/item/mana_battery/Initialize(mapload)
	. = ..()

	src.mana_pool = generate_mana_pool()

/obj/item/mana_battery/initialize_mana_pool()
	PRIVATE_PROC(TRUE)

	var/max = generate_max_capacity()
	var/datum/mana_pool/pool = datum/mana_pool(
		maximum_mana_capacity = max,
		softcap = generate_initial_softcap(max),
		exponential_decay_coeff = generate_initial_exp_coeff(),
		max_donation_rate = generate_donation_rate(max),
		recharge_rate = generate_recharge_rate(),
		attunements = generate_initial_attunements(),
		amount = generate_initial_amount(max)
	)

	return modify_mana_pool(pool)

/obj/item/mana_battery/proc/modify_mana_pool(datum/mana_pool/pool)
	RETURN_TYPE(datum/mana_pool)

	return pool

/obj/item/mana_battery/proc/generate_max_capacity()
	return 0

/obj/item/mana_battery/proc/generate_initial_softcap(max)
	return max

/obj/item/mana_battery/proc/generate_initial_exp_coeff()
	return 1

/obj/item/mana_battery/proc/generate_recharge_rate()
	return 0

/obj/item/mana_battery/generate_initial_attunements()
	RETURN_TYPE(/list/attunement)

	return GLOB.default_attunements.Copy()

/obj/item/mana_battery/proc/generate_donation_rate(max)
	return max

/obj/item/mana_battery/proc/generate_initial_amount(max)
	return max

/obj/item/mana_battery/attack_self(mob/user, modifiers)
	. = ..()

	if (.)
		return TRUE

	var/already_transferring = (user in mana_pool.transferring_to)
	var/results
	if (already_transferring)
		results = mana_pool.stop_transfer(user)
	else
		results = mana_pool.start_transfer(user)

// Do not use, basetype
/obj/item/mana_battery/mana_crystal
	name = MAGIC_MATERIAL_NAME + " crystal"
	desc = "placeholder"
	icon = 'icons/obj/magic/crystals.dmi' //placeholder

/obj/item/mana_battery/mana_crystal/generate_max_capacity()
	return MANA_CRYSTAL_BASE_HARDCAP

/obj/item/mana_battery/mana_crystal/generate_donation_rate(max)
	return MANA_CRYSTAL_BASE_DONATION_RATE

/obj/item/mana_battery/mana_crystal/small
	icon_state = '' //placeholder

/obj/item/mana_battery/mana_crystal/small/
