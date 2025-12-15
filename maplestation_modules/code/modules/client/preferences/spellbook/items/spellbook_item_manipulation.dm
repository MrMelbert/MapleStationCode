GLOBAL_LIST_INIT(spellbook_manipulation_items, generate_spellbook_items(SPELLBOOK_CATEGORY_MANIPULATION))

/datum/spellbook_item/spell/meditate
	name = "Magic Meditation"
	description = "Use mental focus to draw mana within yourself"
	lore = "The most basic method of regenerating mana on your own. \
	Casting this invocation- while focusing- will allow you to draw mana from the ambient environment. \
	Do note that this will take a while between casts, and you should still find other methods of regeneration. \
	This can be empowered through various means, such as via a cloth mat."

	category = SPELLBOOK_CATEGORY_MANIPULATION

	our_action_typepath = /datum/action/cooldown/spell/charged/meditate

/datum/spellbook_item/spell/mana_sense
	name = "Mana Sense"
	description = "Sense other mana pools present"
	lore = "Using your magical attunement (or other aptitudes) \
	you can sense if a creature or object has a mana pool present; and what amount of mana the pool has. \
	Do note that this will require a reprieve between casts, and it will take a second to discern the amount of mana a pool has."

	category = SPELLBOOK_CATEGORY_MANIPULATION

	our_action_typepath = /datum/action/cooldown/spell/pointed/mana_sense

/datum/spellbook_item/spell/lesser_splattercasting
	name = "Lesser Splattercasting"
	description = "Sacrifice some of your vital essence to regain mana"
	lore = "A more consistent, but risky, form of regenerating magic. \
	This method mana charging is often seen used among many blood or sacrificial focused cults. \
	Often this spell is a sort of 'gateway drug' for many to begin practicing the dark arts of blood magic."

	category = SPELLBOOK_CATEGORY_MANIPULATION

	our_action_typepath = /datum/action/cooldown/spell/charged/meditate/lesser_splattercasting
