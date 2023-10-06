// The same as gold just with a slower metabolism rate, to make using the Hand of Midas easier.
/datum/reagent/gold/cursed
	name = "Cursed Gold"
	metabolization_rate = 0.2 * REAGENTS_METABOLISM

///////////////////

/// Actionspeeds
/datum/actionspeed_modifier/status_effect/midas_blight
	id = ACTIONSPEED_ID_MIDAS_BLIGHT

/datum/actionspeed_modifier/status_effect/midas_blight/soft
	multiplicative_slowdown = 0.25

/datum/actionspeed_modifier/status_effect/midas_blight/medium
	multiplicative_slowdown = 0.75

/datum/actionspeed_modifier/status_effect/midas_blight/hard
	multiplicative_slowdown = 1.5

/datum/actionspeed_modifier/status_effect/midas_blight/gold
	multiplicative_slowdown = 2

/// Movementspeeds
/datum/movespeed_modifier/status_effect/midas_blight
	id = MOVESPEED_ID_MIDAS_BLIGHT

/datum/movespeed_modifier/status_effect/midas_blight/soft
	multiplicative_slowdown = 0.25

/datum/movespeed_modifier/status_effect/midas_blight/medium
	multiplicative_slowdown = 0.75

/datum/movespeed_modifier/status_effect/midas_blight/hard
	multiplicative_slowdown = 1.5

/datum/movespeed_modifier/status_effect/midas_blight/gold
	multiplicative_slowdown = 2


///////////////////

/datum/status_effect/midas_blight
	id = "midas_blight"
	alert_type = /atom/movable/screen/alert/status_effect/midas_blight
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 0.2 SECONDS
	remove_on_fullheal = TRUE

	/// The visual overlay state, helps tell both you and enemies how much gold is in your system
	var/midas_state = "midas_1"
	/// How fast the gold in a person's system scales.
	var/goldscale = 30 // x2.8 - Gives ~ 15u for 1 second

/datum/status_effect/midas_blight/on_creation(mob/living/new_owner, duration = 1)
	// Duration is already input in SECONDS
	src.duration = duration
	RegisterSignal(new_owner, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(on_update_overlays))
	return ..()

/atom/movable/screen/alert/status_effect/midas_blight
	name = "Midas Blight"
	desc = "Your blood is being turned to gold, slowing your movements!"
	icon_state = "midas_blight"
	icon = 'maplestation_modules/temp_changes/midas_gun/midas_icons.dmi'

/datum/status_effect/midas_blight/tick(seconds_between_ticks)
	var/mob/living/carbon/human/victim = owner
	// We're transmuting blood, time to lose some.
	if(victim.blood_volume > BLOOD_VOLUME_SURVIVE + 50 && !HAS_TRAIT(victim, TRAIT_NOBLOOD))
		victim.blood_volume -= 5 * seconds_between_ticks
	// This has been hell to try and balance so that you'll actually get anything out of it
	victim.reagents.add_reagent(/datum/reagent/gold/cursed, amount = seconds_between_ticks * goldscale, no_react = TRUE)
	var/current_gold_amount = victim.reagents.get_reagent_amount(/datum/reagent/gold)
	switch(current_gold_amount)
		if(-INFINITY to 50)
			victim.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/midas_blight/soft, update = TRUE)
			victim.add_actionspeed_modifier(/datum/actionspeed_modifier/status_effect/midas_blight/soft, update = TRUE)
			midas_state = "midas_1"
		if(50 to 100)
			victim.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/midas_blight/medium, update = TRUE)
			victim.add_actionspeed_modifier(/datum/actionspeed_modifier/status_effect/midas_blight/medium, update = TRUE)
			midas_state = "midas_2"
		if(100 to 200)
			victim.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/midas_blight/hard, update = TRUE)
			victim.add_actionspeed_modifier(/datum/actionspeed_modifier/status_effect/midas_blight/hard, update = TRUE)
			midas_state = "midas_3"
		if(200 to INFINITY)
			victim.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/midas_blight/gold, update = TRUE)
			victim.add_actionspeed_modifier(/datum/actionspeed_modifier/status_effect/midas_blight/gold, update = TRUE)
			midas_state = "midas_4"
	victim.update_icon()
	if(victim.stat == DEAD)
		qdel(src) // Dead people stop being turned to gold. Don't want people sitting on dead bodies.

/datum/status_effect/midas_blight/proc/on_update_overlays(atom/parent_atom, list/overlays)
	SIGNAL_HANDLER

	if(midas_state)
		var/mutable_appearance/midas_overlay = mutable_appearance('maplestation_modules/temp_changes/midas_gun/midas_icons.dmi', midas_state)
		midas_overlay.blend_mode = BLEND_MULTIPLY
		overlays += midas_overlay

/datum/status_effect/midas_blight/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_MIDAS_BLIGHT, update = TRUE)
	owner.remove_actionspeed_modifier(ACTIONSPEED_ID_MIDAS_BLIGHT, update = TRUE)
	UnregisterSignal(owner, COMSIG_ATOM_UPDATE_OVERLAYS)
	owner.update_icon()
