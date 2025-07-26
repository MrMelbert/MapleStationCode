GLOBAL_LIST_INIT(spellbook_manipulation_items, generate_spellbook_items(SPELLBOOK_CATEGORY_MANIPULATION))

/* /datum/spellbook_item/spell/leyline_charge
	name = "Leyline Charge"
	description = "Draw mana straight from the leylines themselves."
	lore = "The most basic method of regenerating mana on your own. \
	Casting this invocation- while focusing- will allow you to regain mana from the leylines themselves. \
	Do not that this is a finnicky way of regaining mana, and you risk overloading if done improperly."

	category = SPELLBOOK_CATEGORY_MISC

	our_action_typepath = /datum/action/cooldown/spell/leyline_charge */ // disabled because leylines are weirda

/datum/spellbook_item/spell/meditate
	name = "Magic Meditation"
	description = "Use mental focus to draw mana within yourself"
	lore = "The most basic method of regenerating mana on your own. \
	Casting this invocation- while focusing- will allow you to draw mana from the ambient environment. \
	Do note that this will take a while between casts, and you should still find other methods of regeneration."

	category = SPELLBOOK_CATEGORY_MANIPULATION

	our_action_typepath = /datum/action/cooldown/spell/meditate

/datum/spellbook_item/spell/mana_sense
	name = "Mana Sense"
	description = "Sense other mana pools present"
	lore = "Using your magical attunement (or other aptitudes) \
	you can sense if a creature or object has a mana pool present; and what amount of mana the pool has. \
	Do note that this will require a reprieve between casts, and it will take a second to discern the amount of mana a pool has."

	category = SPELLBOOK_CATEGORY_MANIPULATION

	our_action_typepath = /datum/action/cooldown/spell/pointed/mana_sense
