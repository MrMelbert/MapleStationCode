// -- Blood magic business. --
/// Simple define for "remove spell" in the input list.
#define REMOVE_SPELL_ENTRY "(REMOVE SPELL)"

/datum/action/innate/cult
	/// Spells that are not included in the spell list by default.
	var/blacklisted_by_default = FALSE

/datum/action/innate/cult/blood_magic/advanced
	/// LAZYLIST of all spells the user can pick from.
	var/list/all_allowed_spell_types
	/// Max number of spells the user can prepare without a rune.
	var/runeless_limit = ADV_CULTIST_MAX_SPELLS_NORUNE
	/// Max number of spells the user can prepare with a rune.
	var/rune_limit = ADV_CULTIST_MAX_SPELLS_RUNE
	/// What type of rune strengthins our channel?
	var/rune_that_empowers_us = /obj/effect/rune/empower

/datum/action/innate/cult/blood_magic/advanced/Activate()
	var/datum/antagonist/advanced_cult/our_cultist = owner?.mind?.has_antag_datum(/datum/antagonist/advanced_cult, TRUE)
	var/datum/cult_theme/our_theme = our_cultist?.cultist_style

	if(!our_cultist || !our_theme)
		return FALSE

	var/rune = locate(rune_that_empowers_us) in range(1, owner)
	var/limit = (rune ? rune_limit : runeless_limit)
	if(spells.len >= limit)
		if(rune)
			to_chat(owner, our_theme.our_cult_span("You cannot store more than [rune_limit] spells. <b>Pick a spell to remove.</b>", italics = TRUE))
		else
			to_chat(owner, our_theme.our_cult_span("You cannot store more than [runeless_limit] spells without an empowering rune! <b>Pick a spell to remove.</b>", italics = TRUE))
		var/removed_spell = input(owner, "Choose a spell to remove.", "Current Spells") as null|anything in spells
		if(removed_spell)
			qdel(removed_spell)
		return

	var/entered_spell_name
	var/datum/action/innate/cult/added_spell
	var/list/possible_spells = list()

	if(!LAZYLEN(all_allowed_spell_types))
		to_chat(owner, "Something went wrong - you don't have any spells to pick from. Contact an admin!")
		CRASH("[owner] - [type] action found no allowed spell types to chose from!")

	possible_spells += REMOVE_SPELL_ENTRY
	entered_spell_name = input(owner, "Pick a spell to prepare...", "Spell Choices") as null|anything in all_allowed_spell_types
	if(entered_spell_name == REMOVE_SPELL_ENTRY)
		var/removed_spell = input(owner, "Choose a spell to remove.", "Current Spells") as null|anything in spells
		if(removed_spell)
			qdel(removed_spell)
		return

	added_spell = all_allowed_spell_types[entered_spell_name]
	if(QDELETED(src) || owner.incapacitated() || !added_spell || (rune && !(rune in range(1, owner))) || (spells.len >= limit))
		return

	var/requires_item = ispath(added_spell, /datum/action/item_action)
	var/obj/item/ritual_item

	if(requires_item)
		ritual_item = owner.is_holding_item_of_type(our_theme.ritual_item)
		if(!ritual_item)
			to_chat(owner, our_theme.our_cult_span("This type of magic needs to be invoked into a ritual item!", italics = TRUE))
			return

	to_chat(owner, our_theme.get_start_invoking_magic_text(initial(added_spell.name), ritual_item))
	SEND_SOUND(owner, sound(our_theme.scribe_sound, 0, 1, 10))

	if(channeling)
		to_chat(owner, our_theme.our_cult_span("You are already invoking magic!"))
		return

	channeling = TRUE
	if(!do_after(owner, (rune ? 5 SECONDS : 10 SECONDS), target = owner))
		channeling = FALSE
		return

	if(QDELETED(src) || owner.incapacitated() || (rune && !(rune in range(1, owner))) || (spells.len >= limit))
		channeling = FALSE
		return

	if(requires_item && (QDELETED(ritual_item) || !owner.is_holding(ritual_item)))
		channeling = FALSE
		return

	if(our_theme.scribing_takes_blood && ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.bleed(rune ? 10 : 40)
		human_owner.cause_pain(pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM), 8)

	var/datum/action/new_spell
	if(requires_item)
		new_spell = new added_spell(ritual_item, src)
		new_spell.Grant(owner)
	else
		new_spell = new added_spell(owner)
		new_spell.Grant(owner, src)

	spells += new_spell
	Positioning()

	to_chat(owner, our_theme.get_end_invoking_magic_text(new_spell.name, ritual_item))
	channeling = FALSE

#undef REMOVE_SPELL_ENTRY
