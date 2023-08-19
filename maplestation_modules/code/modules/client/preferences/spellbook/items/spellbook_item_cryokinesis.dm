GLOBAL_LIST_INIT(spellbook_cryokinesis_items, generate_spellbook_items(SPELLBOOK_CATEGORY_CRYOKINESIS))

/datum/spellbook_item/spell/ice_knife
	name = "Ice Knife"
	description = "Materialize an explosive shard of ice and fling it at your target."
	lore = "Add later."

	category = SPELLBOOK_CATEGORY_CRYOKINESIS

	our_action_typepath = /datum/action/cooldown/spell/pointed/projectile/ice_knife

/datum/spellbook_item/spell/freeze_person
	name = "Freeze Person"
	description = "Temporarily freeze your target inside solid ice."
	lore = "Add later."

	category = SPELLBOOK_CATEGORY_CRYOKINESIS

	our_action_typepath = /datum/action/cooldown/spell/pointed/freeze_person
