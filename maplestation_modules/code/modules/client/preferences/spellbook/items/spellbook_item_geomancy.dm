GLOBAL_LIST_INIT(spellbook_geomancy_items, generate_spellbook_items(SPELLBOOK_CATEGORY_GEOMANCY))

/datum/spellbook_item/spell/acid_touch
	name = "Acid Touch"
	description = "Empowers your finger with a sticky acid, melting anything (or anyone) you touch."
	lore = "A very volatile spell which has resulted in many a wizard accidentily melting off their own hands. \
		The acid generated is comparable to that of sulfuric acid.\nThis has lead to the spell gaining wide use \
		in the criminal underworld, as it is a very effective way to make entrances or exits, dispose of evidence, \
		or create a distraction."

	category = SPELLBOOK_CATEGORY_GEOMANCY

	our_action_typepath = /datum/action/cooldown/spell/touch/acid_touch
