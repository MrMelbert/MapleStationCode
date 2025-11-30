// Stellar oculory. A more technomagic themed altar, which generates mana from exposure to starlight, based heavily off of starlight regeneration.
#define COMSIG_STELLAR_OCULORY_PULSE_MANA "oculory_pulse_mana"

/datum/mana_pool/magic_altar/stellar
	maximum_mana_capacity = 225
	softcap = 225 // identical to max cap, as it its a passive generator, and not an active one.
	amount = 0
	max_donation_rate_per_second = 4

/obj/machinery/power/magic_contraption/stellar
	name = "stellar oculory"
	desc = "an advanced machine which focuses starlight into mana for use."
	icon_state = "stellar"
	base_icon_state = "stellar"
	circuit = /obj/item/circuitboard/machine/stellar_oculory
	var/active = TRUE

	var/pulse_delay = 20 SECONDS
	var/last_pulse = 0

	var/high_pulse_value = 25 // full starlight
	var/medium_pulse_value = 15 // partial starlight
	var/low_pulse_value = 5 // basically a pity value

	var/starlight_check_range = 3

/obj/machinery/power/magic_contraption/stellar/get_initial_mana_pool_type()
	return /datum/mana_pool/magic_altar/stellar

/obj/machinery/power/magic_contraption/stellar/interact(mob/user)
	if(active)
		active = FALSE
		icon_state = "stellar_inactive"
		return balloon_alert(user, "deactivated")
	if(!active)
		active = TRUE
		icon_state = "stellar"
		return balloon_alert(user, "activated")

/obj/machinery/power/magic_contraption/stellar/process(seconds_per_tick)
	if(!active)
		return
	if(!check_delay())
		return
	if(mana_pool.maximum_mana_capacity == mana_pool.amount)
		return
	var/starlight_level = src.checkstarlight(starlight_check_range)
	pulse_mana(starlight_level)

/obj/machinery/power/magic_contraption/stellar/proc/check_delay()
	if((last_pulse + pulse_delay) <= world.time)
		return TRUE
	return FALSE

/obj/machinery/power/magic_contraption/stellar/proc/pulse_mana(starlight_level)
	var/pulse_value = 0
	switch(starlight_level)
		if(FULL_STARLIGHT)
			pulse_value = high_pulse_value
		if(PARTIAL_STARLIGHT)
			pulse_value = medium_pulse_value
		if(NO_STARLIGHT)
			pulse_value = low_pulse_value
	// anims here
	// also update sprite
	mana_pool.amount += pulse_value
	last_pulse = world.time

/obj/item/circuitboard/machine/stellar_oculory
	name = "\improper Stellar oculory (Machine Board)"
	greyscale_colors = CIRCUIT_COLOR_MAGIC
	build_path = /obj/machinery/power/magic_contraption/stellar
	req_components = list(
		/datum/stock_part/capacitor/tier3 = 3,
		/datum/stock_part/servo/tier3 = 1,
		/obj/item/stack/sheet/mineral/gold = 2,
		/obj/item/mana_battery/mana_crystal/standard = 1,
	)
