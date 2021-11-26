
/datum/cult_theme/ratvarcult
	name = CULT_STYLE_RATVAR
	default_deity = "Rat'var"
	faction = "cult"
	scribing_takes_blood = FALSE
	scribe_sound = 'sound/items/sheath.ogg'
	on_gain_sound = 'sound/magic/clockwork/ark_activation.ogg'
	magic_type = /datum/action/innate/cult/blood_magic/advanced/clock
	magic_subtypes = list(/datum/action/innate/cult/clock_spell, /datum/action/item_action/cult/clock_spell)
	ritual_item = /obj/item/clockwork_slab
	ritual_materials = /obj/item/stack/sheet/bronze/ten
	allowed_runes =  list(
		"Offer",
		"Empower",
		"Teleport",
	)

/datum/cult_theme/ratvarcult/on_chose_breakdown(mob/living/cultist)
	to_chat(cultist, span_heavy_brass("The [name] is a cult that focuses on stealth and cunning."))

/datum/cult_theme/ratvarcult/our_cult_span(message, bold = FALSE, italics = FALSE, large = FALSE)
	if(large)
		return span_large_brass(message)

	if(bold && italics)
		return span_heavy_brass(message)

	if(bold)
		return span_bold(span_brass(message))

	if(italics)
		return span_brasstalics(message)

	return span_brass(message)

/datum/cult_theme/ratvarcult/get_allowed_runes(datum/antagonist/advanced_cult/cultist_datum)
	. = ..()
	var/datum/advanced_antag_datum/cultist/cultist = cultist_datum.linked_advanced_datum
	if(cultist.no_conversion)
		. -= "Offer"
		. -= "Revive"
		. -= "Summon Cultist"
		. -= "Boil Blood"

/datum/cult_theme/ratvarcult/get_start_making_rune_text(mob/living/cultist)
	var/list/text = list()
	text["visible_message"] = span_warning("[cultist] begins outlining out a strange design!")
	text["self_message"] = span_brass("You begin drawing a sigil of Ratvar.")
	return text

/datum/cult_theme/ratvarcult/get_end_making_rune_text(mob/living/cultist)
	var/list/text = list()
	text["visible_message"] = span_warning("[cultist] creates a strange, bright circle.")
	text["self_message"] = span_brass("You finish drawing the arcane markings of Ratvar.")
	return text

/datum/cult_theme/ratvarcult/get_start_invoking_magic_text(added_magic, atom/target)
	return span_brass("You begin to invoke [added_magic][target ? " into [target]":""]...")

/datum/cult_theme/ratvarcult/get_end_invoking_magic_text(added_magic, atom/target)
	return span_brass("[target ? "[target] tocks, as you":"You"] invoke [added_magic]!")
