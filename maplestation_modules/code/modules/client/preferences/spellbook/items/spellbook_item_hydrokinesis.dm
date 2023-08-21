GLOBAL_LIST_INIT(spellbook_hydrokinesis_items, generate_spellbook_items(SPELLBOOK_CATEGORY_HYDROKINESIS))

/datum/spellbook_item/spell/soft_and_wet
	name = "Water Control"
	description = "Wet a dry spot, or dry a wet spot, from a distance. \
		Wetting a requires a water source - you can draw upon condensation in your surroundings, or supply your own."
	lore = "Quite a mundane spell, Water Control does just that - control water, in whatever form it may be in. Except ice. \
		It allows you to break apart water molecules into vapor or condense them into liquid. \
		Hydromancers are often seen using this spell to put out fires, much to the chagrin of thermomancers."

	category = SPELLBOOK_CATEGORY_HYDROKINESIS

	our_action_typepath = /datum/action/cooldown/spell/pointed/soft_and_wet
