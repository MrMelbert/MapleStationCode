GLOBAL_LIST_INIT(spellbook_thermokinesis_items, generate_spellbook_items(SPELLBOOK_CATEGORY_THERMOKINESIS))

/datum/spellbook_item/spell/convect
	name = "Convect"
	description = "Manipulate the temperature of anything you can touch."
	lore = "Often considered the precursor to all thermal magic, convect is one of the most important fundumentals of thermokinesis. \
	An extremely common spell, at least for thermomancers, it is well known among the wider magic community and rather typical.\n\
	Latently available to some, with that latency being why it's so common. Those that learn through the latency typically require training to consistantly control it.\n\
	While exceptions exist, most users can only manipulate temperature in the direction of their thermokinetic school/predisposition (fire/ice or both)."

	category = SPELLBOOK_CATEGORY_THERMOKINESIS

	our_action_typepath = /datum/action/cooldown/spell/pointed/convect
