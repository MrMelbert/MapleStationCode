#define EQUILIBRIUM_MANA_COST 20
#define SENSE_HEARING "Hearing"
#define SENSE_SIGHT "Sight"
#define SENSE_TOUCH "Touch"
#define SENSE_TASTE "Taste"
/// Enhance one sense at the cost of another (Give a buff & debuff)
/datum/action/cooldown/spell/list_target/sense_equilibrium
	name = "Sense Equilibrium"
	desc = "Divert pathways in a person's brain from one area to another, enhancing one at the cost of the other."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "senses"

	school = SCHOOL_PSYCHIC
	spell_requirements = SPELL_REQUIRES_MIND
	antimagic_flags = MAGIC_RESISTANCE_MIND
	cooldown_time = 4 MINUTES
	/// Costs this much to use
	var/mana_cost = EQUILIBRIUM_MANA_COST

	choose_target_message = "Choose a target to mentally rearrange."
	/// Do we allow the caster to specify which boon the sense gets?
	var/is_greater = FALSE
	/// Are we picking from the boons or the debuffs?
	var/is_boon = TRUE
	/// The length that the boon & debuff last
	var/spell_duration = 3 MINUTES
	/// List of senses
	var/static/list/all_senses = list(
		SENSE_HEARING,
		SENSE_SIGHT,
		SENSE_TOUCH,
		SENSE_TASTE,
	)
	/// The possible enhancements you can give to a person
	var/static/list/possible_boons = list(
		SENSE_HEARING = list(
			"Language Comprehension" = /datum/status_effect/language_comprehension,
			"Echolocation" = /datum/status_effect/basic_echolocation,
			"Enhanced Eavesdropping" = /datum/status_effect/trait_effect/eavesdropping,
		),
		SENSE_SIGHT = list(
			"Night Vision" = /datum/status_effect/night_vision,
			"Structural Inference" = /datum/status_effect/mesons,
			"Medicinal Attunement" = /datum/status_effect/temporary_hud/med,
			"Electrical Attunement" = /datum/status_effect/temporary_hud/diag,
			"Bureaucratic Inference" = /datum/status_effect/temporary_hud/sec,
			"Enhanced Empathy" = /datum/status_effect/trait_effect/empath,
		),
		SENSE_TOUCH = list(
			"Self-Awareness" = /datum/status_effect/trait_effect/self_aware,
			"Strong Hugger" = /datum/status_effect/trait_effect/good_hugs,
			"Spatial Awareness" = /datum/status_effect/trait_effect/light_step,
			"Sturdy Stance" = /datum/status_effect/trait_effect/push_immunity,
			"Quick Hands" = /datum/status_effect/trait_effect/quick_hands,
		),
		SENSE_TASTE = list(
			"Enhanced Palette" = /datum/status_effect/trait_effect/enhanced_tastebuds,
			"Ananas Affinity" = /datum/status_effect/ananas_affinity,
			"Ananas Aversion" = /datum/status_effect/ananas_aversion,
		),
	)
	/// The possible debuffs that can be applied to a person
	var/static/list/possible_detriments = list(
		SENSE_HEARING = list(
			"Deafened" = /datum/status_effect/trait_effect/deafened,
			"Silenced Speech" = /datum/status_effect/silenced,
			"Language Reshuffling" = /datum/status_effect/tower_of_babel/equilibrium,
			"Auditory Distress" = /datum/status_effect/sudden_phobia,
			"Stuttering" = /datum/status_effect/speech/stutter,
			"Inside Voice" = /datum/status_effect/trait_effect/whispering,
		),
		SENSE_SIGHT = list(
			"Blindness" = /datum/status_effect/temporary_blindness,
			"Colorblindness" = /datum/status_effect/color_blindness,
			"Prosopagnosia" = /datum/status_effect/prosopagnosia,
			"Hallucinations" = /datum/status_effect/hallucination,
			"Blurry Vision" = /datum/status_effect/eye_blur,
			"Nightmare Vision" = /datum/status_effect/nightmare_vision,
			"Illiteracy" = /datum/status_effect/trait_effect/illiterate,
		),
		SENSE_TOUCH = list(
			"Hyperalgesia" = /datum/status_effect/hyperalgesia,
			"Analgesia" = /datum/status_effect/grouped/screwy_hud/fake_healthy/equilibrium,
			"Decreased Motor Skills" = /datum/status_effect/confusion,
			"Clumsiness" = /datum/status_effect/trait_effect/clumsiness,
			"Hemiplegia" = /datum/status_effect/trait_effect/hemiplegia,
			"Discoordinated" = /datum/status_effect/discoordinated/equilibrium,
			"Thermal Deregulation" = /datum/status_effect/thermal_weakness,
		),
		SENSE_TASTE = list(
			"Ageusia" = /datum/status_effect/trait_effect/tasteless,
			"Ananas Affinity" = /datum/status_effect/ananas_affinity,
			"Ananas Aversion" = /datum/status_effect/ananas_aversion,
			"Reversed Palette" = /datum/status_effect/reversed_palette,
		),
	)
	/// The sense we're going to apply the boon to
	var/list/sense_to_edit
	/// If we're using Greater, then we also pass the boon
	var/specific_boon

/// Variant that lets you be more specific at a higher cost & lower duration
/datum/spellbook_item/spell/sense_equilibrium/apply_params(datum/action/cooldown/spell/list_target/sense_equilibrium/our_spell, greater)
	if(greater)
		our_spell.mana_cost = round(EQUILIBRIUM_MANA_COST * 1.5)
		our_spell.is_greater = TRUE
		our_spell.spell_duration = 1.5 MINUTES
		our_spell.name = "Greater Sense Equilibrium"
		our_spell.desc = "Divert specific pathways in a person's brain from one area to another, enhancing the first at the cost of a second."
	return

/datum/action/cooldown/spell/list_target/sense_equilibrium/New(Target, original)
	. = ..()
	AddComponent(/datum/component/uses_mana/spell, \
		activate_check_failure_callback = CALLBACK(src, PROC_REF(spell_cannot_activate)), \
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \
		mana_required = mana_cost, \
	)

/datum/action/cooldown/spell/list_target/sense_equilibrium/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST

	if(!ishuman(cast_on))
		owner.balloon_alert(owner, "target must be humanoid!")
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	if(get_dist(cast_on, owner) > target_radius)
		owner.balloon_alert(owner, "too far!")
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST
	var/check_type = tgui_alert(owner, "Positive or Negative?", "Help or Hinder", list("Positive", "Negative"))
	is_boon = (check_type == "Positive")
	sense_to_edit = tgui_input_list(owner, "Enhance which sense?", "Sense Equilibrium", all_senses)
	if(is_greater)
		specific_boon = tgui_input_list(owner, "Which boon to apply?", "Greater Sense Equilibrium", is_boon ? possible_boons[sense_to_edit] : possible_detriments[sense_to_edit])
	if(!sense_to_edit || (is_greater && !specific_boon) || QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/// If the debuff is the same sense as the buff, reroll until we hit a sense we're not already using
/datum/action/cooldown/spell/list_target/sense_equilibrium/proc/roll_for_opposite()
	var/sense_to_debuff = pick(all_senses)
	while(sense_to_debuff == sense_to_edit)
		sense_to_debuff = pick(all_senses)
	return sense_to_debuff

/// Horrifying spaghetti because we need to juggle 2 assoc lists
/datum/action/cooldown/spell/list_target/sense_equilibrium/cast(mob/living/cast_on)
	. = ..()
	var/main_effect = is_boon ? possible_boons[sense_to_edit] : possible_detriments[sense_to_edit]
	if(!specific_boon)
		specific_boon = pick(is_boon ? possible_boons[sense_to_edit] : possible_detriments[sense_to_edit])

	var/debuffed_sense = roll_for_opposite()
	var/secondary_effect = is_boon ? possible_detriments[debuffed_sense] : possible_boons[debuffed_sense]
	var/sense_to_debuff_key = pick(secondary_effect)

	var/datum/status_effect/specific_boon_datum = main_effect[specific_boon]
	var/datum/status_effect/sense_to_debuff = secondary_effect[sense_to_debuff_key]
	owner.emote("snap")
	if(!cast_on.can_block_magic(antimagic_flags, charge_cost = 1))
		cast_on.balloon_alert(cast_on, "you feel different")
		to_chat(cast_on, span_warning("Something's giving you a headache..."))
		cast_on.set_timed_status_effect(spell_duration, specific_boon_datum, TRUE)
		cast_on.set_timed_status_effect(spell_duration, sense_to_debuff, TRUE)
		to_chat(owner, span_notice("[cast_on] gained [specific_boon] and [sense_to_debuff_key]!"))

		// Mood event related stuff
		var/is_psych = FALSE
		if(ishuman(cast_on))
			var/mob/living/carbon/human/human_cast = cast_on
			is_psych = istype(human_cast?.mind?.assigned_role.type, /datum/job/psychologist)

		cast_on.add_mood_event("sense_equilibrium", /datum/mood_event/sense_equilibrium, sense_to_edit, debuffed_sense, is_psych, spell_duration)

	else
		owner.balloon_alert(owner, "spell blocked!")
		to_chat(owner, span_warning("Something blocked your attempt to rewire [cast_on]'s brain!"))
	sense_to_edit = null
	specific_boon = null

/datum/mood_event/sense_equilibrium
	description = "I have the worst headache..."
	mood_change = -2
	timeout = 1 MINUTES

/datum/mood_event/sense_equilibrium/add_effects(first_sense, second_sense, is_psych, spell_duration)
	/// Not actually sure if this happens in time for the mood datum to use this instead of the normal
	timeout = spell_duration
	/// If the person knows a thing or two about brains, they should know what's going on with themselves.
	if(is_psych)
		description = "I feel like my [first_sense] is crossed with my [second_sense]... It's giving me a headache!"

#undef EQUILIBRIUM_MANA_COST
#undef SENSE_HEARING
#undef SENSE_SIGHT
#undef SENSE_TOUCH
#undef SENSE_TASTE
