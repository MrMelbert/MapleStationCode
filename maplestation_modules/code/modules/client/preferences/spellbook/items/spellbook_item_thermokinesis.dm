GLOBAL_LIST_INIT(spellbook_thermokinesis_items, generate_spellbook_items(SPELLBOOK_CATEGORY_THERMOKINESIS))

/datum/spellbook_item/spell/convect
	name = "Convect"
	description = "Manipulate the temperature of anything you can touch."
	lore = "Often considered the precursor to all thermal magic, convect is one of the most important fundumentals of thermokinesis. \
	An extremely common spell, at least for thermomancers, it is well known among the wider magic community and rather typical.\n\
	Latently available to some, with that latency being why it's so common. Those that learn through the latency typically require training to consistantly control it.\n\
	This latency, linked with it's relative simplicity of casting, causes stories of previous thaumic blanks suddenly bursting into flames/\
	freezing themselves (often due to intense emotion, though triggers can be diverse) to be common among the magic community.\n\
	While exceptions exist, most users can only manipulate temperature in the direction of their thermokinetic school/predisposition (fire/ice or both)."

	category = SPELLBOOK_CATEGORY_THERMOKINESIS

	our_action_typepath = /datum/action/cooldown/spell/pointed/convect

/datum/spellbook_item/spell/finger_flame
	name = "Finger Flame"
	description = "With a snap, conjures a small flame at the tip of your fingers."
	lore = "More of a party trick than a real spell, Finger Flame is known far and wide as the showiest trick in a thermomancer's book. \
		While not particularly useful, it's a fantastic way to get attention, intimidate someone, demonstrate your powers, or light a cigarette.\n\
		Its low potency makes Finger Flame hardly expensive or tiresome to cast and maintain, \
		making it a good way to practice your control over fire (or rather, to practice avoiding burning yourself)."

	category = SPELLBOOK_CATEGORY_THERMOKINESIS

	our_action_typepath = /datum/action/cooldown/spell/touch/finger_flame/mana
