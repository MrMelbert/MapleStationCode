/*// doesnt use or catalyse magic, just senses
/datum/action/cooldown/spell/thaumatergic_sense
	/// How much we can discern mana pools from one another, and their contents.
	/// 0: Default. We return the average mana and attunements of all pools.
	/// 1: We return the mana and attunements separately, but we dont specify what theyre from.
	/// 2: We specify what is from what, and name them.
	var/pool_discernment
	/// How precise we are in determining the mana in given pools.
	var/mana_precision
	var/attunement_precision

	var/datum/thaumatergic_sense_tgui_handler/ui_handler

/datum/action/cooldown/spell/thaumatergic_sense/New(Target, original, pool_discernment = 0, mana_precision = 1, attunement_precision = 1)
	. = ..()

	src.pool_discernment = pool_discernment
	src.attunement_precision = attunement_precision

/datum/action/cooldown/spell/thaumatergic_sense/can_cast_spell(feedback)
	. = ..()
	if (!.) return FALSE
	var/list/datum/mana_pool/mana_pools = owner.get_available_mana()
	if (mana_pools.len == 0)
		if (feedback)
			to_chat(owner, span_warning("You sense no accessable magic in range..."))
			return FALSE
	return TRUE

/datum/action/cooldown/spell/thaumatergic_sense/cast(atom/cast_on)
	. = ..()

	if (ui_handler)
		ui_handler = new /datum/thaumatergic_sense_tgui_handler
	ui_handler.ui_interact(usr)

	var/list/datum/mana_pool/mana_pools = owner.get_available_mana()
	if (mana_pools.len == 0)
		if (feedback)
			to_chat(owner, span_warning("You sense no accessable magic in range..."))
			return FALSE
	var/mana = get_raw_mana_of_pools(mana_pools)
	mana = rand(mana*mana_precision, mana*SAFE_DIVIDE(1, mana_precision))

	if (pool_discernment == THAUMATERGIC_SENSE_POOL_DISCERNMENT_LEVEL_ZERO)
		var/list/datum/attunement/average_attunements = list()
		for (var/datum/mana_pool/pool as anything in mana_pools)
			for (var/datum/attunement/iterated_attunement as anything in pool.attunements)
				average_attunements[iterated_attunement] += rand(pool.attunements[iterated_attunement]*attunement_precision, pool.attunements[iterated_attunement]*SAVE_DIVIDE(1, attunement_precision))
		var/average_attunements_string = ""
		for (var/datum/attunement/iterated_attunement as anything in average_attunements)
			average_attunements[iterated_attunement] /= mana_pools.len
			average_attunements += "[iterated_attunement]: [average_attunements[iterated_attunement]]"

		to_chat(owner, span_blue("Total mana: [mana]. Average attunements: [average_attunements_string]"))
		return TRUE

/datum/thaumatergic_sense_tgui_handler

/datum/thaumatergic_sense_tgui_handler/ui_state(mob/user)
	return GLOB.conscious_state

/datum/thaumatergic_sense_tgui_handler/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_thaumatergicSense")
		ui.open()

/datum/thaumatergic_sense_tgui_handler/ui_data(mob/user)
	. = ..()

	. = list()

	var/should_differentiate_pools_at_all = (pool_discernment != THAUMATERGIC_SENSE_POOL_DISCERNMENT_LEVEL_ZERO)
	.["should_differentiate_pools_at_all"] = should_differentiate_pools_at_all



*/
