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
