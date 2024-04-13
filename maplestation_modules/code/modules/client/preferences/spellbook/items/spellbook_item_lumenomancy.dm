GLOBAL_LIST_INIT(spellbook_lumenomancy_items, generate_spellbook_items(SPELLBOOK_CATEGORY_LUMENOMANCY))

/datum/spellbook_item/spell/conjure_item/flare
	name = "Flare"
	description = "Conjure lumens into a glob to be held or thrown to light an area."
	lore = "A simple application of lumenomancy, although quite complex enough for those new to magic to have the resulting globule sustain itself for so long. \n\
	An extremely common spell, used to gauge a child's power if they are able to even emit a moment of light, it is well known among the wider magic community.\n\
	Effort is taken to understand lumens and conjuring it out of mana. Those that study might prefer to focus on another school of magic, causing them to skip proper flare casting.\n\
	A relatively safe spell that dissipates by itself under normal circumstances, the nebulous construct leaves no residue so clean up isn't needed.\n\
	Considered to be a helpful spell, its short lived life is mostly used to help locate more permanent lighting options.\n\
	Those interested in the lumenomancy school/predisposition use this spell to further their understanding of luminosity and their ability to warp its directions."

	category = SPELLBOOK_CATEGORY_LUMENOMANCY
	has_params = TRUE

	our_action_typepath = /datum/action/cooldown/spell/conjure_item/flare
// Customization to allow lesser flare
/datum/spellbook_item/spell/conjure_item/flare/generate_customization_params()
	. = list()
	.["lesser"] = new /datum/spellbook_customization_entry/boolean("lesser", "Lesser, weaker, somewhat cheaper version", "A cheap less lasting flare that fizzles out faster than normally, along with a considerable cooldown between casts, for those just learning magic or unable to grasp the full concept of luminosity.")

/datum/spellbook_item/spell/illusion
	name = "Illusion"
	description = "Summon an illusionary clone of yourself at the target location. Looks identical to you, \
		but will not hold up to physical scrutiny. Has a long range, but lasts for only a short time, and is less effective in darker areas."
	lore = "Sometimes known as \"Mirror Image\" by more advanced pracitioners, Illusion is a well practiced spell which bends the light \
		in such a way to create an almost perfect copy of the caster. Of course, being effectively an advanced trick of the light, \
		the illusion is not capable of much besides being used to confuse and distract or otherwise look pretty."

	category = SPELLBOOK_CATEGORY_LUMENOMANCY

	our_action_typepath = /datum/action/cooldown/spell/pointed/illusion
