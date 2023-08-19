GLOBAL_LIST_INIT(spellbook_cryokinesis_items, generate_spellbook_items(SPELLBOOK_CATEGORY_CRYOKINESIS))

/datum/spellbook_item/spell/ice_knife
	name = "Ice knife"
	description = "Materialize an explosive shard of ice and fling it at your target."
	lore = "Add later."

	category = SPELLBOOK_CATEGORY_CRYOKINESIS

	our_action_typepath = /datum/action/cooldown/spell/pointed/projectile/ice_knife
