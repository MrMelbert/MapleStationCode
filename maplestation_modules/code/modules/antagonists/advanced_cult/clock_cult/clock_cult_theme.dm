// Clockcult ~2~ 3, Electric Boogaloo.
/datum/cult_theme/ratvarcult
	name = CULT_STYLE_RATVAR
	default_deity = "Rat'var"
	faction = "ratvar"
	cultist_hud_name = "clockwork"
	cultist_lead_hud_name = "clockwork_lead"
	cultist_hud_icon = 'maplestation_modules/icons/mob/huds/antag_hud.dmi'
	language = /datum/language/ratvarian
	scribing_takes_blood = FALSE
	scribe_sound = 'sound/items/sheath.ogg' //TODO: maybe a better sound
	on_gain_sound = 'sound/magic/clockwork/ark_activation.ogg'
	magic_type = /datum/action/innate/cult/blood_magic/advanced/clock
	magic_subtypes = list(/datum/action/innate/cult/clock_spell, /datum/action/item_action/cult/clock_spell)
	ritual_item = /obj/item/clockwork_slab
	ritual_materials = /obj/item/stack/sheet/brass/ten
	allowed_runes =  list(
		"Sigil of Transmission",
		"Sigil of Empowering",
		"Sigil of Submission",
		"Sigil of Transgression",
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

/datum/cult_theme/ratvarcult/pick_deconversion_line()
	return pick(list(
		"Un'vy Engine..",
		"Cen'vfr gur zn-puvar..",
		"GUR GV'PX'VAT QB-RF ABG F'GBC!",
		"Hap'rn-fvat..",
		"Gv'px Gb'px..",
		"FNG NAN!",
		"Ur'yc Rat'var.."
	))

/datum/cult_theme/ratvarcult/pick_god_shame_line()
	return pick(list(
		"Do not give in, my return counts on you.",
		"Scour this poison, you must - or else!",
		"All this power, and you still falter?",
		"The cogs will not continue to turn without you.",
	))
