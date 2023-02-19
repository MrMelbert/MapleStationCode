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

	has_params = TRUE

/datum/spellbook_item/spell/convect/generate_customization_params()
	. = list()
	.["test"] = new /datum/spellbook_customization_entry/any_input(
		key = "test",
		name = "test ONE",
		default_value = "gawef"
	)
	.["dawawd"] = new /datum/spellbook_customization_entry/numeric/numeric_input(
		key = "dawawd",
		name = "test TWO",
		default_value = 0,
		max_value = 100,
		min_value = 0,
		min_increment = 1
	)
	.["dawawdawdd"] = new /datum/spellbook_customization_entry/boolean(
		key = "dawawdawdd",
		name = "test TWO",
		default_value = FALSE,
	)
	.["zx"] = new /datum/spellbook_customization_entry/numeric/slider(
		key = "zx",
		name = "test TWO",
		default_value = 0,
		max_value = 100,
		min_value = 0,
		min_increment = 1
	)
