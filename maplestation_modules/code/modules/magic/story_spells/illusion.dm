#define ILLUSION_ATTUNEMENT_LIGHT 0.5
#define ILLUSION_MANA_COST 25

/datum/action/cooldown/spell/pointed/illusion
	name = "Illusion"
	desc = "Summon an illusion at the target location. Less effective in dark areas."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "illusion"
	sound = 'sound/effects/magic.ogg'

	cooldown_time = 2 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	var/mana_cost = ILLUSION_MANA_COST

	school = SCHOOL_CONJURATION

	active_msg = "You prepare to summon an illusion."
	deactive_msg = "You stop preparing to summon an illusion."
	aim_assist = FALSE
	cast_range = 20 // For camera memes

	/// Duration of the illusionary mob
	var/conjured_duration = 8 MINUTES
	/// HP of the illusionary mob
	var/conjured_hp = 10

/datum/action/cooldown/spell/pointed/illusion/New(Target)
	. = ..()

	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_LIGHT] += ILLUSION_ATTUNEMENT_LIGHT

	AddComponent(/datum/component/uses_mana/spell, \
		activate_check_failure_callback = CALLBACK(src, PROC_REF(spell_cannot_activate)), \
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \
		mana_required = mana_cost, \
		attunements = attunements, \
	)

/datum/action/cooldown/spell/pointed/illusion/Remove(mob/living/remove_from)
	. = ..()
	remove_from.remove_status_effect(/datum/status_effect/maintaining_illusion)

/datum/action/cooldown/spell/pointed/illusion/is_valid_target(atom/cast_on)
	var/turf/castturf = get_turf(cast_on)
	return isopenturf(castturf) && !isgroundlessturf(castturf)

/datum/action/cooldown/spell/pointed/illusion/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = usr || owner
	caster.remove_status_effect(/datum/status_effect/maintaining_illusion) // One at a time

	var/turf/castturf = get_turf(cast_on)
	var/mob/copy_target = select_copy_target()
	var/mob/living/simple_animal/hostile/illusion/conjured/decoy = new(castturf)
	if(!isnull(copy_target))
		decoy.Copy_Parent(copy_target, conjured_duration, conjured_hp)
		decoy.face_atom(caster || copy_target)

	decoy.spin(0.4 SECONDS, 0.1 SECONDS)
	// alpha is based on how bright the turf is. Darker = weaker illusion
	decoy.alpha = 0
	animate(decoy, alpha = clamp(255 * castturf.get_lumcount(), 75, 225), time = 0.2 SECONDS)

	// with a snap of course
	caster.emote("snap")
	caster.face_atom(castturf)
	caster.apply_status_effect(/datum/status_effect/maintaining_illusion, decoy)

/// Determines what mob to copy for the illusion
/datum/action/cooldown/spell/pointed/illusion/proc/select_copy_target()
	RETURN_TYPE(/mob)
	return owner

/// Status effect that tracks the current illusion being maintained
/datum/status_effect/maintaining_illusion
	id = "maintaining_illusion"
	tick_interval = -1 // Or maybe we tick and give it a mana cost, to sustain it?
	alert_type = /atom/movable/screen/alert/status_effect/maintaining_illusion

	/// Whether we've initiated fade out and thus are about to stop maintaining shortly
	VAR_FINAL/fading = FALSE
	/// Reference to the illusion being maintained
	VAR_FINAL/mob/living/simple_animal/hostile/illusion/conjured/copy
	/// List of generic signals that, when caught, will break the illusion
	var/static/list/generic_break_signals = list(
		COMSIG_LIVING_DEATH,
		SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED),
	)

/datum/status_effect/maintaining_illusion/on_creation(mob/living/new_owner, mob/living/simple_animal/hostile/illusion/conjured/copy)
	. = ..()
	if(!.)
		return

	ASSERT(istype(copy))
	src.copy = copy
	RegisterSignal(copy, COMSIG_QDELETING, PROC_REF(copy_gone))

/datum/status_effect/maintaining_illusion/on_apply()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(check_distance))
	RegisterSignals(owner, generic_break_signals, PROC_REF(break_illusion))
	return TRUE

/datum/status_effect/maintaining_illusion/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, generic_break_signals)
	fade_out_copy()

/datum/status_effect/maintaining_illusion/Destroy()
	. = ..()
	copy = null // Has to come after parent call, because on_remove is called in parent

/datum/status_effect/maintaining_illusion/proc/fade_out_copy()
	if(fading || QDELETED(copy))
		return

	fading = TRUE
	animate(copy, time = 0.5 SECONDS, alpha = 0, easing = CUBIC_EASING)
	addtimer(CALLBACK(copy, TYPE_PROC_REF(/mob/living, death), 0.5 SECONDS))
	UnregisterSignal(copy, COMSIG_QDELETING)

	if(!QDELING(src))
		qdel(src)

/datum/status_effect/maintaining_illusion/proc/break_illusion(mob/living/source, ...)
	SIGNAL_HANDLER

	if(source.stat <= SOFT_CRIT)
		source.balloon_alert(source, "the illusion breaks!")
	fade_out_copy()

/datum/status_effect/maintaining_illusion/proc/check_distance(mob/living/source, ...)
	SIGNAL_HANDLER

	// The metric behind this number: Is there enough distance such that,
	// on Metastation, you can put an illusion in Medbay Lobby and go to the bar.
	if(get_dist(source, copy) <= 32)
		return

	break_illusion(source)

/datum/status_effect/maintaining_illusion/proc/copy_gone(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/atom/movable/screen/alert/status_effect/maintaining_illusion
	name = "Maintaining Illusion"
	desc = "You're maintaining an illusion. Moving too far away or a lapse in concentration will break it. \
		Or you can click this to cancel it."
	icon = 'maplestation_modules/icons/hud/screen_alert.dmi'
	icon_state = "illusion"

/atom/movable/screen/alert/status_effect/maintaining_illusion/Click(location, control, params)
	. = ..()
	if(!.)
		return
	var/datum/status_effect/maintaining_illusion/effect = attached_effect
	effect.fade_out_copy()

// Illusion subtype for summon illusion
/mob/living/simple_animal/hostile/illusion/conjured
	desc = "An illusion! What are you hiding..?"
	AIStatus = AI_OFF
	density = FALSE
	melee_damage_lower = 0
	melee_damage_upper = 0
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	move_force = INFINITY
	move_resist = INFINITY
	pull_force = INFINITY
	sentience_type = SENTIENCE_BOSS
	// I wanted to make these illusion react to emotes (wave to wave, frown to swears, etc) but maybe later

#undef ILLUSION_ATTUNEMENT_LIGHT
#undef ILLUSION_MANA_COST
