GLOBAL_LIST_INIT(spellbook_lumenomancy_items, generate_spellbook_items(SPELLBOOK_CATEGORY_LUMENOMANCY))

/datum/spellbook_item/spell/flare
	name = "Flare"
	description = "Conjure lumens into a glob to be held or thrown to light an area."
	lore = "A simple application of lumenomancy, although quite complex enough for those new to magic to have the resulting globule sustain itself for so long. \n\
	An extremely common spell, used to gauge a child's power if they are able to even emit a moment of light, it is well known among the wider magic community.\n\
	Effort is taken to understand lumens and conjuring it out of mana. Those that study might prefer to focus on another school of magic, causing them to skip proper flare casting.\n\
	A relatively safe spell that dissipates by itself under normal circumstances, the nebulous construct leaves no residue so clean up isn't needed.\n\
	Considered to be a helpful spell, its short lived life is mostly used to help locate more permanent lighting options.\n\
	For those interested in the lumenomancy school/predisposition use this spell to further self-study of luminosity and the ability to warp its directions."

	category = SPELLBOOK_CATEGORY_LUMENOMANCY

	our_action_typepath = /datum/action/cooldown/spell/conjure_item/flare
