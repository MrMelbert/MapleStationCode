GLOBAL_LIST_INIT(spellbook_cryokinesis_items, generate_spellbook_items(SPELLBOOK_CATEGORY_CRYOKINESIS))

/datum/spellbook_item/spell/ice_knife
	name = "Ice Knife"
	description = "Materialize an explosive shard of ice and fling it at your target."
	lore = "The favored tool of Frost Mages, Clowns, and Frost Clowns, Ice Knives are dull implements first created as an attempt to conjure weaponry, later better repurposed as throwing weapons and tools of mischief; creating floors of slippery ice wherever it hits."

	category = SPELLBOOK_CATEGORY_CRYOKINESIS

	our_action_typepath = /datum/action/cooldown/spell/pointed/projectile/ice_knife

/datum/spellbook_item/spell/freeze_person
	name = "Freeze Person"
	description = "A well known and effective spell that encases your victim in a target of enchanted ice."
	lore = "Iconic and infamous, Freeze Person has been used to great effect to solidify opponents, victims, and other targets of mages for centuries.\
	Though it is quite useful to stop someone in their tracks, the ice around them is resistant enough to protect them from incoming attacks.\
	Just be careful you know exactly what this spell is before casting it."

	category = SPELLBOOK_CATEGORY_CRYOKINESIS

	our_action_typepath = /datum/action/cooldown/spell/pointed/freeze_person
