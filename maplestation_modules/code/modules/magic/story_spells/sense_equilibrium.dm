#define EQUILIBRIUM_MANA_COST 25
#define SENSE_HEARING "Hearing"
#define SENSE_SIGHT "Sight"
#define SENSE_TOUCH "Touch"
#define SENSE_TASTE "Taste"
/// Enhance one sense at the cost of another
/datum/action/cooldown/spell/list_target/sense_equilibrium
	name = "Sense Equilibrium"
	desc = "Divert pathways in a person's brain from one area to another, enhancing one at the cost of the other."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "senses"

	school = SCHOOL_PSYCHIC
	spell_requirements = SPELL_REQUIRES_MIND
	antimagic_flags = MAGIC_RESISTANCE_MIND
	cooldown_time = 5 MINUTES
	/// Costs this much to use
	var/mana_cost = EQUILIBRIUM_MANA_COST

	choose_target_message = "Choose a target to mentally rearrange."
	/// Do we allow the caster to specify which boon the sense gets?
	var/is_greater = FALSE
	/// Are we picking from the boons or the debuffs?
	var/is_boon = TRUE
	/// The length that the boon & debuff last
	var/spell_duration = 3 MINUTES
	/// The possible enhancements you can give to a person
	var/static/list/possible_boons = list(
		SENSE_HEARING = list(
			"Language Comprehension" = /datum/status_effect/language_comprehension,
			"Echolocation" = /datum/status_effect/basic_echolocation,
			"Enhanced Eavesdropping" = /datum/status_effect/trait_effect/eavesdropping,
		),
		SENSE_SIGHT = list(
			"Night Vision" = /datum/status_effect/night_vision,
			"Structural Inferrence" = /datum/status_effect/mesons,
			"Medicinal Attunement" = /datum/status_effect/temporary_hud/med,
			"Electrical Attunement" = /datum/status_effect/temporary_hud/diag,
			"Beurocratic Inferrence" = /datum/status_effect/temporary_hud/sec,
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
			"Suttering" = /datum/status_effect/speech/stutter,
			"Inside Voice" = /datum/status_effect/trait_effect/whispering,
		),
		SENSE_SIGHT = list(
			"Blindness" = /datum/status_effect/temporary_blindness,
			"Colorblindness" = /datum/status_effect/color_blindness,
			"Prosopagnosia" = /datum/status_effect/trait_effect/prosopagnosia,
			"Hallucinations" = /datum/status_effect/hallucination,
			"Blurry Vision" = /datum/status_effect/eye_blur,
			"Nightmare Vision" = /datum/status_effect/nightmare_vision,
			"Illiteracy" = /datum/status_effect/trait_effect/illiterate,
		),
		SENSE_TOUCH = list(
			"Hyperalgesia", /datum/status_effect/hyperalgesia,
			"Congenital Analgesia" = /datum/status_effect/grouped/screwy_hud/fake_healthy/equilibrium,
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
	var/list/boon_to_apply
	/// If we're using Greater, then we also pass the boon
	var/specific_boon

/// Variant that lets you be more specific at a higher cost & lower duration
/datum/action/cooldown/spell/list_target/sense_equilibrium/apply_params(/datum/action/cooldown/spell/list_target/sense_equilibrium/our_spell, greater)
	if(greater)
		our_spell.mana_cost = EQUILIBRIUM_MANA_COST * 2
		our_spell.is_greater = TRUE
		our_spell.spell_duration = 1.5 MINUTES
		our_spell.name = "Greater Sense Equilibrium"
		our_spell.desc = "Divert pathways in a person's brain from one area to another, enhancing the first at the cost of a second. \
		This variant allows the caster to pinpoint specific effects on the chosen sense, at the cost of higher mana drain and lower effect duration."
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

	if(get_dist(cast_on, owner) > target_radius)
		owner.balloon_alert(owner, "they're too far!")
		return . | SPELL_CANCEL_CAST
	var/check_type = tgui_alert(user, "Positive or Negative?","Help or Hinder", list("Positive", "Negative"))
	if(check_type == "Negative")
		is_boon = FALSE
	boon_to_apply = tgui_input_list(owner, "Enhance which sense?", "Sense Equilibrium", is_boon ? possible_boons : possible_detriments)
	if(is_greater)
		specific_boon = tgui_input_list(owner, "Which boon to apply?", "Greater Sense Equilibrium", boon_to_apply)
	if(!boon_to_apply || (is_greater && !specific_boon))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/// If the debuff is the same sense as the buff, reroll until we hit a sense we're not already using
/datum/action/cooldown/spell/list_target/sense_equilibrium/proc/roll_for_opposite()
	var/sense_to_debuff = pick(is_boon ? possible_detriments : possible_boons)
	while(sense_to_debuff == boon_to_apply)
		sense_to_debuff = pick(is_boon ? possible_detriments : possible_boons)
	return pick(sense_to_debuff)

/datum/action/cooldown/spell/list_target/sense_equilibrium/cast(mob/living/cast_on)
	. = ..()
	owner.emote("snap")
	if(!specific_boon)
		specific_boon = pick(boon_to_apply)
	var/sense_to_debuff = roll_for_debuff()

	if(!cast_on.can_block_magic(antimagic_flags, charge_cost = 1))
		cast_on.balloon_alert(cast_on, "you feel different")
		to_chat(cast_on, span_notice("Something's giving you a headache..."))
		cast_on.set_timed_status_effect(spell_duration, specific_boon, TRUE)
		cast_on.set_timed_status_effect(spell_duration, sense_to_debuff, TRUE)
		to_chat(owner, span_notice("[cast_on] gained [LAZYFIND(specific_boon)] and [LAZYFIND(sense_to_debuff)]!"))
	else
		owner.balloon_alert(owner, "spell blocked!")
		to_chat(owner, span_warning("Something blocked your attempt to rewire [cast_on]'s brain!"))


#undef EQUILIBRIUM_MANA_COST
#undef SENSE_HEARING
#undef SENSE_SIGHT
#undef SENSE_TOUCH
#undef SENSE_TASTE
#undef SENSE_SMELL
