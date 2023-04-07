GLOBAL_LIST_INIT(spellbook_aeromancy_items, generate_spellbook_items(SPELLBOOK_CATEGORY_AEROMANCY))

/datum/spellbook_item/spell/airhike
	name = "Air hike"
	description = "Force wind beneath one's feet for a boost of movement where one is facing to jump over 2 tiles or to jump up a Zlevel and a tile ahead."
	lore = "A somewhat intermediate spell not from its complexity, but applying proper force that won't have the user spin out of control. \
	A spell that is often grown out of due to its unwieldly application, at least for aeromancers, it is known as a party trick or crude application in the magic community, but it is useful in a pinch.\n\
	A common experiment for early aeromancers after wondering if applying force to oneself is possible. Those that learn through experimentation require training to consistantly control it, eventually moving onto finer control or dropping it after one too many crashes.\n\
	Most scholars might prefer students not to spend too much time blasting themselves wildly due to injuries slowing down or stopping proper study.\n\
	If given a proper clear area, some might argue its a safe way to explain distance, the idea of self as a target, and points of force which can be applied to spells that require finesse.\n\
	The name was given due to mages that appeared to walk on air itself, and like climbing a mountain side, if caution is not taken would be fatigued and fall from their height."

	category = SPELLBOOK_CATEGORY_AEROMANCY

	our_action_typepath = /datum/action/cooldown/spell/airhike
