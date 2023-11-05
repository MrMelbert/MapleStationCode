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

/datum/spellbook_item/spell/persuade
	name = "Persuade"
	description = "Persuade someone through psychic trickery and convincing words. \
	Less effective on those who are mindshielded."
	lore = "TO BE WRITTEN"

	category = SPELLBOOK_CATEGORY_MISC
	has_params = TRUE

	our_action_typepath = /datum/action/cooldown/spell/list_target/persuade

/datum/spellbook_item/spell/persuade/generate_customization_params()
	. = list()
	.["emote"] = new /datum/spellbook_customization_entry/boolean("emote", "Emote when Used", "Do you use an emote every time this spell is used? This does make it incredibly obvious. Decreases the casting cost and cooldown time.")
	.["emote_text"] = new /datum/spellbook_customization_entry/any_input("emote_text", "Emote", "The emote to be used on cast if Emote when Used is active.")
	.["emote_hands"] = new /datum/spellbook_customization_entry/boolean("emote_hands", "Emote requires Hands", "Does the spell require hands to emote it? Only works with Emote when Used.")
	.["low_sanity"] = new /datum/spellbook_customization_entry/boolean("low_sanity", "Only Works on Low Sanity", "Does the spell only work if your target is low in mood/sanity? Be aware that you don't know if the spell has worked or not... Decreases the casting cost.")
