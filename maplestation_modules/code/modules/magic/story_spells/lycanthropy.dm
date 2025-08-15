// the many spells that are used to turn into versions of a werewolf

/datum/action/cooldown/spell/shapeshift/lycanthrope // use this for the simplemob forms, like standard wolves
	name = "Wolf Form"
	desc = "Channel the wolf within yourself and turn into one of your possible forms. \
		Be careful, for you can still die within this form."
	invocation = "RAAAAAAAAWR!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE
	possible_shapes = list(
		/mob/living/simple_animal/hostile/asteroid/wolf, // room to add other forms
	)

/datum/action/cooldown/spell/werewolf_form
	name = "Werewolf Change"
	desc = "Change to and from your full werewolf form. \
	You will gain the full effects of this, both negative and positive."

	invocation = "Grrrh-"
	invocation_type = INVOCATION_SHOUT

	spell_requirements = SPELL_REQUIRES_HUMAN
	cooldown_time = 10 SECONDS // so it can't be spammed

	button_icon = 'maplestation_modules/icons/mob/actions/actions_advspells.dmi'
	button_icon_state = "moon"

	var/datum/species/owner_base_species // what species we are other than a werewolf
	var/list/base_features = list("mcolor" = "#FFFFFF")
	// yes this might cause other implications, such as mass species change, or with synths (synthcode moment) but i'll look into it later down the line

/datum/action/cooldown/spell/werewolf_form/Grant(mob/grant_to)
		. = ..()
		var/mob/living/carbon/human/lycanthrope = grant_to
		owner_base_species = lycanthrope.dna.species
		base_features = lycanthrope.dna.features.Copy()
		ADD_TRAIT(owner, TRAIT_WEREWOLF, TRAIT_GENERIC) // todo: move this to a datum (eg, like antag/heretic)


/datum/action/cooldown/spell/werewolf_form/cast(atom/movable/cast_on)
	. = ..()
	var/mob/living/carbon/human/lycanthrope = owner
	if(istype(lycanthrope.dna.species, /datum/species/werewolf))
		lycanthrope.balloon_alert(cast_on, "changing back")
		lycanthrope.dna.features = base_features
		lycanthrope.set_species(owner_base_species)
	else
		to_chat(lycanthrope, span_green("You call upon the wolf within yourself, preparing to change shape..."))
		lycanthrope.set_jitter_if_lower(3 SECONDS)
		if(!do_after(lycanthrope, 3 SECONDS))
			to_chat(lycanthrope, span_warning("Your focus is broken, and your body returns to its original state."))
			return
		base_features = lycanthrope.dna.features.Copy()
		owner_base_species = lycanthrope.dna.species
		lycanthrope.set_species(/datum/species/werewolf)
		lycanthrope.say("ARRRROOOOO!!", forced = "spell ([src])")

/datum/action/cooldown/spell/werewolf_rage
	name = "Lycanthropic Rage"
	desc = "Enrage"
	invocation = "GRRR-!!" // todo: this sucks
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_HUMAN
	cooldown_time = 3 MINUTES
	button_icon_state = "splattercasting"
	/// The radius around us that we frighten people.
	var/scare_radius = 6

/datum/action/cooldown/spell/werewolf_rage/before_cast(mob/living/user)
	..()
	if(user.has_status_effect(/datum/status_effect/werewolf_rage))
		user.balloon_alert(user, "already raging!")
		return SPELL_CANCEL_CAST

/datum/action/cooldown/spell/werewolf_rage/cast(mob/living/user)
	..()

	to_chat(user, span_green("You begin to dredge up the supernatural fury that boils within your body..."))
	if(is_species(user, /datum/species/werewolf))
		for(var/mob/living/carbon/human/nearby_human in view(scare_radius, user))
			if(HAS_TRAIT(nearby_human, TRAIT_WEREWOLF) || HAS_TRAIT(nearby_human, TRAIT_MINDSHIELD) || HAS_TRAIT(nearby_human, TRAIT_DEAF) || HAS_TRAIT(nearby_human, TRAIT_FEARLESS) || nearby_human == user)
				continue
			to_chat(nearby_human, span_warning("You feel an unknown, primal terror building up within you..."))

	if(!do_after(user, 2 SECONDS))
		to_chat(user, span_warning("Your focus is broken, and you settle back down."))
		return

	to_chat(user, span_notice("You release the supernatural wrath within you!"))
	user.apply_status_effect(/datum/status_effect/werewolf_rage)

	if(is_species(user, /datum/species/werewolf))
		user.say("RRRRAGGGGHHHH!!", forced = "spell ([src])")
		playsound(user.loc, 'sound/creatures/space_dragon_roar.ogg', 40, use_reverb = TRUE)
		// hearing a werewolf violently howl- and enter its enraged state, forces unprotected normal humans to panic
		for(var/mob/living/carbon/human/nearby_human in view(scare_radius, user))
			if(nearby_human == user)
				continue
			// if you are: mentally protected, fearless, deaf, or a werewolf yourself (or the person who used this) you aren't affected.
			if(HAS_TRAIT(nearby_human, TRAIT_WEREWOLF) || HAS_TRAIT(nearby_human, TRAIT_MINDSHIELD) || HAS_TRAIT(nearby_human, TRAIT_DEAF) || HAS_TRAIT(nearby_human, TRAIT_FEARLESS))
				to_chat(nearby_human, span_warning("You feel something horrible pass over you."))
				continue

			to_chat(nearby_human, span_danger("Your mind recoils as it is filled with a primordial terror!"))
			// if you aren't, you'll become dizzy and jittery, alongside get a -5 negative moodlet
			nearby_human.set_jitter_if_lower(7 SECONDS)
			nearby_human.set_dizzy_if_lower(3 SECONDS)
			nearby_human.add_mood_event("werewolf_delirium", /datum/mood_event/werewolf_delirium)
			// and a chance to involuntarily scream
			if(prob(4))
				nearby_human.emote("scream")
	else
		user.say("REEEEEEEEE!!!!", forced = "spell([src])")
		playsound(user.loc, 'sound/effects/reee.ogg', 40, use_reverb = TRUE)

/datum/status_effect/werewolf_rage
	id = "blooddrunk"
	duration = 60
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/werewolf_rage

/atom/movable/screen/alert/status_effect/werewolf_rage
	name = "Lycanthropic Rage"
	desc = "You are filled with a supernatural rage! Your pulse thunders in your ears!"
	icon_state = "blooddrunk"

/datum/status_effect/werewolf_rage/on_apply()
	owner.add_movespeed_mod_immunities(id, /datum/movespeed_modifier/damage_slowdown)
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.physiology.brute_mod *= 0.8
		human_owner.physiology.burn_mod *= 0.8
		human_owner.physiology.tox_mod *= 0.8
	owner.playsound_local(get_turf(owner), 'sound/effects/singlebeat.ogg', 40, 1, use_reverb = FALSE)
	return TRUE

/datum/status_effect/werewolf_rage/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.physiology.brute_mod *= 1.25
		human_owner.physiology.burn_mod *= 1.25
		human_owner.physiology.tox_mod *= 1.25
	owner.remove_movespeed_mod_immunities(id, /datum/movespeed_modifier/damage_slowdown)
