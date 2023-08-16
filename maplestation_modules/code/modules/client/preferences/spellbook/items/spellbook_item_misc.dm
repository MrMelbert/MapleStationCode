GLOBAL_LIST_INIT(spellbook_misc_items, generate_spellbook_items(SPELLBOOK_CATEGORY_MISC))

/datum/spellbook_item/spell/mage_hand
	name = "Mage Hand"
	description = "Magically manipulate an item from a distance."
	lore = "The favorite of lazy magicians and tricksters alike, \
		Mage Hand is a simple spell that allows the caster to manipulate an item from a distance. \
		The spell is often used to retrieve items that are out of reach, play pranks on unsuspecting victims, \
		press some buttons on a distant keyboard, or to simply avoid having to get up from a comfortable chair.\n\
		Due to its simplicity, the spell is often taught to the young as a first spell - and due to this commonality, \
		it is very easily recognized by most."

	category = SPELLBOOK_CATEGORY_MISC

	our_action_typepath = /datum/action/cooldown/spell/apply_mutations/mage_hand
