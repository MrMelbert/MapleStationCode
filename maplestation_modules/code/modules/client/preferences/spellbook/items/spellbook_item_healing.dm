GLOBAL_LIST_INIT(spellbook_healing_items, generate_spellbook_items(SPELLBOOK_CATEGORY_LIFE_MAGIC))

/datum/spellbook_item/spell/healing_touch
	name = "Healing Touch"
	description = "Lay your hands upon a target to heal their wounds."
	lore = "Often called for the action taken while invoking, \"Lay on Hands\", this spell is a staple of any healer's arsenal. \
		Healing Touch is often used by chaplains and priests to aid the ailing and wounded they encounter in their duties. \
		However, that's not to say that its use is exclusively for the holy, as some medical practitioners \
		(especially those who find themselves on the frontier, where supplies are scarce) \
		have been known to utilize it occasionally to expedite their work - \
		though many still find physical tools or chemicals to be more reliable, and thus, it's use is not as common as one might think."

	category = SPELLBOOK_CATEGORY_LIFE_MAGIC

	our_action_typepath = /datum/action/cooldown/spell/touch/healing_touch

/datum/spellbook_item/spell/soothe
	name = "Soothe"
	description = "Attempt to soothe a target, stopping them from feeling rage, fear, doubt, or similar emotions for a short time. \
		This effect can be resisted by sentient targets, but also works on more simple-minded creatures."
	lore = "A spell that is often used by by clergical figures, psychologists, or nurses to calm down those who cannot be reasoned with \
		due to its ability to provide tranquility to those in a state of panic or fear. \n\
		Likewise, those who work with animals may use it to pacify a rampaging beast or settle a frightened pet.\n\
		However, its ability to be resisted by sentient creatures who are in extreme mental duress, especially anger, \
		means it is not always reliable - and thus - conventional methods are often preferred."

	category = SPELLBOOK_CATEGORY_LIFE_MAGIC

	our_action_typepath = /datum/action/cooldown/spell/pointed/soothe_target
