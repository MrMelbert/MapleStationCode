#define SOOTHE_ATTUNEMENT_LIFE 0.5
#define SOOTHE_MANA_COST 20

// Calm Emotions / Soothe, basically just applied pacifism after a short do_after. Can be resisted.
/datum/action/cooldown/spell/pointed/soothe_target
	name = "Soothe"
	desc = "Attempt to calm a target, preventing them from attacking others for a short time and stopping \
		and anger, fear, or doubt they may be feeling. This effect works on sentient and simple-minded creatures alike, \
		but can be resisted by the former."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "soothe"
	sound = 'sound/effects/magic.ogg'

	cooldown_time = 2 MINUTES
	spell_requirements = NONE
	var/mana_cost = SOOTHE_MANA_COST

	school = SCHOOL_PSYCHIC
	antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_MIND

	cast_range = 4

	/// How long it takes to soothe someone, gives them time to resist the effect
	var/cast_time = 5 SECONDS
	/// How long the soothing effect lasts
	var/pacifism_duration = 30 SECONDS

/datum/action/cooldown/spell/pointed/soothe_target/New(Target)
	. = ..()

	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_LIFE] += SOOTHE_ATTUNEMENT_LIFE

	AddComponent(/datum/component/uses_mana/spell, \
		activate_check_failure_callback = CALLBACK(src, PROC_REF(spell_cannot_activate)), \
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \
		mana_required = CALLBACK(src, PROC_REF(get_mana_consumed)), \
		attunements = attunements, \
	)

/datum/action/cooldown/spell/pointed/soothe_target/proc/get_mana_consumed(atom/caster, datum/spell, atom/cast_on)
	var/final_cost = mana_cost
	var/mob/living/living_cast_on = cast_on
	if(!isnull(living_cast_on.mind))
		final_cost *= 2 // costs more on other players because pacifism is kind of annoying...
	return final_cost

/datum/action/cooldown/spell/pointed/soothe_target/is_valid_target(atom/cast_on)
	return isliving(cast_on) && (cast_on != owner)

/datum/action/cooldown/spell/pointed/soothe_target/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return .
	var/mob/caster = usr || owner
	if(DOING_INTERACTION(caster, REF(src)))
		return . | SPELL_CANCEL_CAST

	if(!cast_on.apply_status_effect(/datum/status_effect/being_soothed, cast_time * 2)) // extra long duration for leeway but we remove it after anyways
		cast_on.balloon_alert(caster, "already being soothed!")
		return . | SPELL_CANCEL_CAST

	if(!do_after(
		user = caster,
		delay = 5 SECONDS,
		target = cast_on,
		timed_action_flags = IGNORE_TARGET_LOC_CHANGE|IGNORE_HELD_ITEM|IGNORE_SLOWDOWNS,
		extra_checks = CALLBACK(src, PROC_REF(block_cast), caster, cast_on),
		interaction_key = REF(src),
		hidden = TRUE,
	))
		. |= SPELL_CANCEL_CAST

	cast_on.remove_status_effect(/datum/status_effect/being_soothed)
	return .

/datum/action/cooldown/spell/pointed/soothe_target/proc/block_cast(mob/living/caster, mob/living/cast_on)
	if(QDELETED(src) || QDELETED(caster) || QDELETED(cast_on))
		return FALSE
	if(!cast_on.has_status_effect(/datum/status_effect/being_soothed))
		cast_on.balloon_alert(caster, "cast resisted!")
		return FALSE
	if(get_dist(cast_on, caster) > cast_range)
		cast_on.balloon_alert(caster, "out of range!")
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/soothe_target/cast(mob/living/cast_on)
	. = ..()
	cast_on.apply_status_effect(/datum/status_effect/soothe, pacifism_duration)
	cast_on.cause_pain(BODY_ZONE_HEAD, 5)

// Interregnum effect from while the soothe is being applied that allows the target to resist
/datum/status_effect/being_soothed
	id = "being_magic_soothed"
	alert_type = /atom/movable/screen/alert/status_effect/being_soothed
	tick_interval = -1

/datum/status_effect/being_soothed/on_creation(mob/living/new_owner, new_duration = 10 SECONDS)
	src.duration = new_duration
	return ..()

/datum/status_effect/being_soothed/on_apply()
	if(!isnull(owner.mind))
		// Only sentient mobs can resist the effect
		RegisterSignals(owner, list(COMSIG_LIVING_RESIST), PROC_REF(generic_block))
		RegisterSignals(owner, list(COMSIG_LIVING_UNARMED_ATTACK, COMSIG_MOB_ITEM_ATTACK), PROC_REF(attack_block))
	to_chat(owner, span_hypnophrase("You inexplicably start to feel calmer..."))
	return TRUE

/datum/status_effect/being_soothed/on_remove()
	UnregisterSignal(owner, list(COMSIG_LIVING_RESIST, COMSIG_LIVING_UNARMED_ATTACK, COMSIG_MOB_ITEM_ATTACK))

/datum/status_effect/being_soothed/proc/generic_block(datum/source)
	SIGNAL_HANDLER
	sooth_blocked()
	return RESIST_HANDLED

/datum/status_effect/being_soothed/proc/attack_block(datum/source)
	SIGNAL_HANDLER
	if(owner.combat_mode)
		sooth_blocked()

/datum/status_effect/being_soothed/proc/sooth_blocked()
	new /obj/effect/temp_visual/annoyed(owner.loc)
	qdel(src)

/atom/movable/screen/alert/status_effect/being_soothed
	name = "Being Soothed"
	desc = "Some force is being exerted on you, suddenly quieting your rage, fear, and doubt. \
		You can <b>resist</b> this effect, if your feelings are stronger than this force lets on."
	icon_state = "high"
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/alert/status_effect/being_soothed/Click(location, control, params)
	. = ..()
	if(!.)
		return
	if(usr != owner || !isliving(owner))
		return FALSE

	var/mob/living/clicker = owner
	clicker.execute_resist()
	return TRUE

// Soothe effect that prevents attacks and also stops mob AI from attacking
/datum/status_effect/soothe
	id = "magic_soothe"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/soothed
	tick_interval = 5 SECONDS
	remove_on_fullheal = TRUE
	/// List of all traits added via this effect
	var/list/added_traits = list(
		// Will hardly come into play, but fits
		TRAIT_ANTICONVULSANT,
		// No fear
		TRAIT_FEARLESS,
		// No rage
		TRAIT_JOLLY,
		// No madness
		TRAIT_MADNESS_IMMUNE,
		// No fear... again
		TRAIT_NOFEAR_HOLDUPS,
		// No rage... again
		TRAIT_PACIFISM,
		// No madness... again
		TRAIT_RDS_SUPPRESSED,
	)
	/// Tracks if we had [FACTION_NEUTRAL] before adding
	var/had_neutral_before = TRUE
	/// Tracks our sanity level before adding, restores it to the exact value after removing
	var/pre_sanity = -1

/datum/status_effect/soothe/on_creation(mob/living/new_owner, new_duration = 10 SECONDS)
	src.duration = new_duration
	return ..()

/datum/status_effect/soothe/refresh(effect, new_duration = 10 SECONDS)
	duration += new_duration
	to_chat(owner, span_hypnophrase("You feel calmer."))

/datum/status_effect/soothe/on_apply()
	// Some snowflake :tm: behavior, not that this is necessary since pacifism is being added,
	// but seeing as monkeys are the #1 aggressor here I thought why not go the mile
	if(istype(owner.ai_controller, /datum/ai_controller/monkey))
		owner.ai_controller.clear_blackboard_key(BB_MONKEY_CURRENT_ATTACK_TARGET)
		owner.ai_controller.clear_blackboard_key(BB_MONKEY_ENEMIES)
		owner.ai_controller.set_blackboard_key(BB_MONKEY_ENEMIES, list())
		owner.ai_controller.set_blackboard_key(BB_MONKEY_AGGRESSIVE, FALSE)

	if(!(FACTION_NEUTRAL in owner.faction))
		had_neutral_before = FALSE
		owner.faction += FACTION_NEUTRAL

	owner.add_traits(added_traits, TRAIT_STATUS_EFFECT(id))
	if(owner.mob_mood)
		pre_sanity = owner.mob_mood?.sanity
		owner.mob_mood.set_sanity(SANITY_GREAT + 5, maximum = SANITY_MAXIMUM, override = TRUE)
		owner.mob_mood.mood_screen_object?.add_filter(TRAIT_STATUS_EFFECT(id), 2, list("type" = "outline", "color" = "#8c00ff", "size" = 2))
		owner.add_mood_event(TRAIT_STATUS_EFFECT(id), /datum/mood_event/soothed)

	to_chat(owner, span_hypnophrase("You feel calm."))
	return TRUE

/datum/status_effect/soothe/on_remove()
	if(QDELING(owner))
		return

	if(!had_neutral_before)
		owner.faction -= FACTION_NEUTRAL
	owner.remove_traits(added_traits, TRAIT_STATUS_EFFECT(id))

	if(owner.mob_mood)
		owner.mob_mood.set_sanity(pre_sanity, maximum = SANITY_MAXIMUM, override = TRUE)
		owner.mob_mood.mood_screen_object?.remove_filter(TRAIT_STATUS_EFFECT(id))
		owner.clear_mood_event(TRAIT_STATUS_EFFECT(id))

	to_chat(owner, span_danger("The unnatural calm fades away."))

/datum/status_effect/soothe/tick(seconds_per_tick, times_fired)
	var/seconds_between_ticks = initial(tick_interval) / 10

	owner.adjust_confusion(-2 SECONDS * seconds_between_ticks)
	owner.adjust_dizzy(-2 SECONDS * seconds_between_ticks)
	owner.adjust_jitter(-4 SECONDS * seconds_between_ticks)

	owner.mob_mood?.set_sanity(owner.mob_mood.sanity + seconds_between_ticks, maximum = SANITY_GREAT + 5, override = TRUE)

/atom/movable/screen/alert/status_effect/soothed
	name = "Soothed"
	desc = "Some force is being exerted on you, calming you down. All of your rage, fear, and doubt disappear."
	icon_state = "hypnosis"

/datum/mood_event/soothed
	description = "To err is human..."
	mood_change = 25

#undef SOOTHE_ATTUNEMENT_LIFE
#undef SOOTHE_MANA_COST
