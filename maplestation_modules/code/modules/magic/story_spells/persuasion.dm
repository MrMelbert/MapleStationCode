#define PERSUASION_POWER_NONE 0
#define PERSUASION_POWER_WEAK 1
#define PERSUASION_POWER_NORMAL 2
#define PERSUASION_POWER_STRONG 3

/datum/component/uses_mana/story_spell/persuade

/datum/component/uses_mana/story_spell/persuade/get_mana_required(atom/caster, atom/cast_on, ...)
	var/datum/action/cooldown/spell/list_target/persuade/persuade_spell = parent
	return ..() * persuade_spell.persuasion_cost

/// Effectively a mind trick, allows persuading weaker wills. Pretty much an HRP only spell.
/datum/action/cooldown/spell/list_target/persuade
	name = "Persuade"
	desc = "Utilize a small amount of psychic trickery to persuade weak wills."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "mage_hand"
	sound = null

	choose_target_message = "Choose a target to persuade."

	//Lowered to 1 second if emote_when_used is TRUE on apply_params
	cooldown_time = 3 SECONDS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	school = SCHOOL_CONJURATION
	antimagic_flags = MAGIC_RESISTANCE_MIND

	///The message to send on cast.
	var/message
	///Cost of the spell, lowered on apply_params if emote_when_used or only_low_sanity are TRUE
	var/persuasion_cost = 30
	///The default persuasion power. Set to STRONG or 3 for an admin-only version that is immune to mindshields
	var/default_persuasion_power = PERSUASION_POWER_NORMAL
	///The spell does an emote whenever it's utilized, giving it away.
	var/emote_when_used = FALSE
	///If the emote requires hands, it won't activate if this is TRUE and the user happens to have no available hands.
	var/emote_requires_hands = FALSE
	///The emote used whenever this spell is used and emote_when_used is TRUE.
	var/emote_text = "waves their hand."
	///The spell only works if the recipient has low sanity. Doesn't give any feedback to the caster if it fails.
	var/only_low_sanity = FALSE

/datum/spellbook_item/spell/persuade/apply_params(datum/action/cooldown/spell/list_target/persuade/our_spell, emote, emote_text, emote_hands, low_sanity)
	if(emote)
		our_spell.persuasion_cost -= 10
		our_spell.cooldown_time = 1 SECONDS
		our_spell.emote_when_used = TRUE
		our_spell.emote_text = emote_text
	if(emote_hands)
		our_spell.emote_requires_hands = TRUE
	if(low_sanity)
		our_spell.persuasion_cost -= 10
		our_spell.only_low_sanity = TRUE
	return

/datum/action/cooldown/spell/list_target/persuade/New(Target)
	. = ..()
	AddComponent(/datum/component/uses_mana/story_spell/persuade)

/datum/action/cooldown/spell/list_target/persuade/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	message = tgui_input_text(owner, "What message to convince with?", "Persuade")
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST

	if(get_dist(cast_on, owner) > target_radius)
		owner.balloon_alert(owner, "they're too far!")
		return . | SPELL_CANCEL_CAST

	if(!message)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/list_target/persuade/cast(mob/living/cast_on)
	. = ..()

	if(emote_when_used && emote_requires_hands)
		if(iscarbon(owner))
			var/mob/living/carbon/carbon_owner = owner
			if(carbon_owner.usable_hands > 0)
				owner.visible_message(emote_text, visible_message_flags = EMOTE_MESSAGE)
			else
				owner.balloon_alert(owner, "requires a free hand!")
				return
	else if(emote_when_used && !emote_requires_hands)
		owner.visible_message(emote_text, visible_message_flags = EMOTE_MESSAGE)

	var/persuasion_power = default_persuasion_power
	if(only_low_sanity)
		var/cast_on_sanity = cast_on.mob_mood?.sanity
		switch(cast_on_sanity)
			if(SANITY_DISTURBED to SANITY_NEUTRAL) //feeling decent
				persuasion_power = PERSUASION_POWER_WEAK
			if(SANITY_NEUTRAL to INFINITY) // feeling great!
				persuasion_power = PERSUASION_POWER_NONE

	if(HAS_TRAIT(cast_on, TRAIT_MINDSHIELD)) //lower power by 1 if mindshielded
		persuasion_power = max(persuasion_power - 1, 0)

	switch(persuasion_power)
		if(PERSUASION_POWER_WEAK)
			to_chat(cast_on, span_hypnophrase("You feel a weak compulsion to follow the next set of words... It feels easy to resist, however."))
		if(PERSUASION_POWER_NORMAL, PERSUASION_POWER_STRONG)
			to_chat(cast_on, span_hypnophrase("You feel a compulsion to follow the next set of words..."))

	if(!owner.say(message, sanitize = FALSE)) //if we sanitize it breaks apostrophes
		return
	message_admins("[ADMIN_LOOKUPFLW(owner)] said '[message]' with Persuade, affecting [cast_on], with a persuasion power of [persuasion_power].")
	log_directed_talk(owner, cast_on, message, LOG_SAY, name)
