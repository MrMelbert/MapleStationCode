GLOBAL_LIST_INIT(spellbook_lumenomancy_items, generate_spellbook_items(SPELLBOOK_CATEGORY_LUMENOMANCY))

/datum/spellbook_item/spell/flare
	name = "Flare"
	description = "Conjure lumens into a glob to be held or thrown to light an area."
	lore = " This is Flare pay no attention to the rest words WIP.Often considered the precursor to all thermal magic, convect is one of the most important fundumentals of thermokinesis. \
	An extremely common spell, at least for thermomancers, it is well known among the wider magic community and rather typical.\n\
	Latently available to some, with that latency being why it's so common. Those that learn through the latency typically require training to consistantly control it.\n\
	This latency, linked with it's relative simplicity of casting, causes stories of previous thaumic blanks suddenly bursting into flames/\
	freezing themselves (often due to intense emotion, though triggers can be diverse) to be common among the magic community.\n\
	While exceptions exist, most users can only manipulate temperature in the direction of their thermokinetic school/predisposition (fire/ice or both)."

	category = SPELLBOOK_CATEGORY_LUMENOMANCY

	our_action_typepath = /datum/action/cooldown/spell/conjure_item/flare
