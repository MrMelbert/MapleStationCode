
/datum/cult_theme/narsie
	name = CULT_STYLE_NARSIE
	default_deity = "Nar'sie"
	faction = "cult"
	language = /datum/language/narsie
	scribe_sound = 'sound/weapons/slice.ogg'
	on_gain_sound = 'sound/ambience/antag/bloodcult.ogg'
	magic_type = /datum/action/innate/cult/blood_magic/advanced
	magic_subtypes = list(/datum/action/innate/cult/blood_spell)
	ritual_item = /obj/item/melee/cultblade/advanced_dagger
	ritual_materials = /obj/item/stack/sheet/runed_metal/ten
	allowed_runes =  list(
		"Sanctimonious Offer",
		"Empower",
		"Teleport",
		"Revive",
		"Barrier",
		"Summon Cultist",
		"Boil Blood",
		"Spirit Realm"
	)

/datum/cult_theme/narsie/on_chose_breakdown(mob/living/cultist)
	to_chat(cultist, span_cultbold("The [name] is a cult that focuses on strength and brute force."))

/datum/cult_theme/narsie/our_cult_span(message, bold = FALSE, italics = FALSE, large = FALSE)
	if(large)
		return span_cultlarge(message)

	if(bold && italics)
		return span_cultboldtalic(message)

	if(bold)
		return span_cultbold(message)

	if(italics)
		return span_cultitalic(message)

	return span_cult(message)

/datum/cult_theme/narsie/on_cultist_made(datum/antagonist/advanced_cult/cultist_datum, mob/living/cultist)
	. = ..()
	if(!ishuman(cultist))
		return

	var/datum/team/advanced_cult/our_team = cultist_datum.get_team()
	if(our_team.cult_risen)
		our_team.arise_given_cultist(cultist, no_sound = TRUE)
	if(our_team.cult_ascendent)
		our_team.ascend_given_cultist(cultist, no_sound = TRUE)

/datum/cult_theme/narsie/on_cultist_lost(datum/antagonist/advanced_cult/cultist_datum, mob/living/cultist)
	. = ..()
	if(!ishuman(cultist))
		return

	cultist.RemoveElement(/datum/element/cult_eyes)
	cultist.RemoveElement(/datum/element/cult_halo)

/datum/cult_theme/narsie/on_cultist_team_made(datum/team/advanced_cult/cult_team, datum/mind/lead_cultist)
	. = ..()
	var/datum/action/innate/cult/arise_the_cult/arise_action = new(lead_cultist.current)
	arise_action.Grant(lead_cultist.current)
	LAZYADD(cult_team.leader_actions, arise_action)

	var/datum/action/innate/cult/ascend_the_cult/ascend_action = new(lead_cultist.current)
	ascend_action.Grant(lead_cultist.current)
	LAZYADD(cult_team.leader_actions, ascend_action)

/datum/cult_theme/narsie/get_allowed_runes(datum/antagonist/advanced_cult/cultist_datum)
	. = ..()
	var/datum/advanced_antag_datum/cultist/cultist = cultist_datum.linked_advanced_datum
	if(!cultist?.conversion_allowed) // If the cultist has no linked datum, it's a convertee, so it's safe to assume conversion is allowed
		. -= "Revive"
		. -= "Summon Cultist"
		. -= "Boil Blood"

/datum/cult_theme/narsie/get_start_making_rune_text(mob/living/cultist)
	var/list/text = list()
	text["visible_message"] = span_warning("[cultist] [cultist.blood_volume ? "cuts open [cultist.p_their()] arm and begins writing in [cultist.p_their()] own blood":"begins sketching out a strange design"]!")
	text["self_message"] = span_cult("You [cultist.blood_volume ? "slice open your arm and ":""]begin drawing a sigil of the Geometer.")
	return text

/datum/cult_theme/narsie/get_end_making_rune_text(mob/living/cultist)
	var/list/text = list()
	text["visible_message"] = span_warning("[cultist] creates a strange circle[cultist.blood_volume ? " in [cultist.p_their()] own blood":""].")
	text["self_message"] = span_cult("You finish drawing the arcane markings of the Geometer.")
	return text

/datum/cult_theme/narsie/get_start_invoking_magic_text(added_magic, atom/target)
	return span_cult("You begin to carve the unnatural symbols for the spell [added_magic] into your flesh!")

/datum/cult_theme/narsie/get_end_invoking_magic_text(added_magic, atom/target)
	return span_cult("Your wounds glow with power, you have prepared a [added_magic] invocation!")

/datum/cult_theme/narsie/pick_deconversion_line()
	return pick(list(
		"Av'te Nar'Sie..",
		"Pa'lid Mors..",
		"INO INO ORA ANA!",
		"SAT ANA!",
		"Daim'niodeis Arc'iai Le'eones..",
		"R'ge Na'sie..",
		"Diabo us Vo'iscum..",
		"Eld' Mon Nobis..",
	))

/datum/cult_theme/narsie/pick_god_shame_line()
	return pick(list(
		"Your blood is your bond - you are nothing without it",
		"Do not forget your place",
		"All that power, and you still fail?",
		"If you cannot scour this poison, I shall scour your meager life!",
	))
