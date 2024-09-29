/mob/living/carbon
	has_initial_mana_pool = TRUE

/mob/living/carbon/get_initial_mana_pool_type()
	return /datum/mana_pool/mob/living/carbon

/datum/mana_pool/mob/living/carbon
	maximum_mana_capacity = CARBON_BASE_MANA_CAPACITY

	exponential_decay_divisor = BASE_CARBON_MANA_EXPONENTIAL_DIVISOR

/mob/living/carbon/initialize_mana_pool()
	var/datum/mana_pool/mob/living/carbon/our_pool = ..()

	//our_pool.set_max_mana((our_pool.maximum_mana_capacity * get_max_mana_capacity_mult()), change_amount = TRUE, change_softcap = TRUE)

	our_pool.softcap *= get_mana_softcap_mult(mana_pool)

	return our_pool

/mob/living/carbon/proc/get_mana_softcap_mult(datum/mana_pool/pool)
	SHOULD_BE_PURE(TRUE)

	var/mult = 1

	if (mob_biotypes & MOB_ROBOTIC)
		mult *= ROBOTIC_MANA_SOFTCAP_MULT

	return mult

/mob/living/carbon/proc/get_max_mana_capacity_mult()
	SHOULD_BE_PURE(TRUE)

	var/mult = 1

	return mult

// i am NOT good with this section of the code so this is likely screwy
/datum/mana_pool/proc/set_statpanel_format()

	var/list/stat_panel_data = list()

	// Pass on what panel we should be displayed in.
	stat_panel_data[PANEL_DISPLAY_PANEL] = "Spells"
	// Also pass on the name of the spell, with some spacing
	stat_panel_data[PANEL_DISPLAY_NAME] = " - Mana Pool Amount"

	var/sc_very_low = (softcap * 0.1)
	var/sc_low = (softcap * 0.3)
	var/sc_medium = (softcap * 0.6)
	var/sc_high = (softcap * 0.8)

	//determines what the status displays, it'll be a generic/non-obvious value as a design choice
	if(amount) // amount is the mana count, as a friendly reminder
		if (amount < sc_very_low)
			stat_panel_data[PANEL_DISPLAY_STATUS] = "VERY LOW"
		else if (amount > sc_very_low && amount < sc_low)
			stat_panel_data[PANEL_DISPLAY_STATUS] = "LOW"
		else if (amount > sc_low && amount < sc_medium)
			stat_panel_data[PANEL_DISPLAY_STATUS] = "MEDIUM"
		else if (amount > sc_medium && amount < sc_high)
			stat_panel_data[PANEL_DISPLAY_STATUS] = "HIGH"
		else if (amount > sc_high && amount <= softcap)
			stat_panel_data[PANEL_DISPLAY_STATUS] = "VERY HIGH"
		else if (amount > softcap)
			stat_panel_data[PANEL_DISPLAY_STATUS] = "OVERLOADED"
	else
		stat_panel_data[PANEL_DISPLAY_STATUS] = "ERROR"

	SEND_SIGNAL(src, COMSIG_ACTION_SET_STATPANEL, stat_panel_data)

	return stat_panel_data

/mob/living/carbon/get_actions_for_statpanel()
	. = ..()
	var/list/data = list()
	if (mana_pool)
		var/list/mana_pool_data = mana_pool.set_statpanel_format()
		if(length(mana_pool_data))
			data += list(list(
				// the panel the action gets displayed to
				mana_pool_data[PANEL_DISPLAY_PANEL],
				// the status of the mana pool
				mana_pool_data[PANEL_DISPLAY_STATUS],
				// superfluous, it *generally* should be "mana pool amount" but i'm leaving in the ability to rename this
				mana_pool_data[PANEL_DISPLAY_NAME],
		))
	. += data
	return .
