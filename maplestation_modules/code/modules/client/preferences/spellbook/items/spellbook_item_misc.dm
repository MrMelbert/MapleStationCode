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

/* /datum/spellbook_item/spell/leyline_charge
	name = "Leyline Charge"
	description = "Draw mana straight from the leylines themselves."
	lore = "The most basic method of regenerating mana on your own. \
	Casting this invocation- while focusing- will allow you to regain mana from the leylines themselves. \
	Do not that this is a finnicky way of regaining mana, and you risk overloading if done improperly."

	category = SPELLBOOK_CATEGORY_MISC

	our_action_typepath = /datum/action/cooldown/spell/leyline_charge */ // disabled because leylines are weird

/datum/spellbook_item/spell/meditate
	name = "Magic Meditation"
	description = "Use mental focus to draw mana within yourself"
	lore = "The most basic method of regenerating mana on your own. \
	Casting this invocation- while focusing- will allow you to draw mana from the ambient environment. \
	Do note that this will take a while between casts, and you should still find other methods of regeneration."

	category = SPELLBOOK_CATEGORY_MISC

	our_action_typepath = /datum/action/cooldown/spell/meditate
