GLOBAL_LIST_INIT(spellbook_thermokinesis_items, generate_spellbook_items(SPELLBOOK_CATEGORY_THERMOKINESIS))

/datum/spellbook_item/convect
	name = "Convect"
	description = "Manipulate the temperature of anything you can touch."
	lore = "Often considered the precursor to all thermal magic, convect is one of the most important fundumentals of thermokinesis, \
	and while one can use thermal magic without knowing convect, it is considered abnormal - though not unheard of."
	category = SPELLBOOK_CATEGORY_THERMOKINESIS

/datum/spellbook_item/convect/apply(mob/living/carbon/human/target, list/params)
	. = ..()

	var/datum/action/cooldown/spell/pointed/convect/convect_spell = new /datum/action/cooldown/spell/pointed/convect(target.mind || target)
	convect_spell.Grant(target)

/datum/spellbook_item/convect/get_entry_type()
	return SPELLBOOK_SPELL
