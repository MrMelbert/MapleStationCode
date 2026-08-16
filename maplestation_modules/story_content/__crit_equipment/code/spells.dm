// TODO LIST:
// Add "burning out" effect (consciousness modifier most likely, heart issues, literally burning up)
// Add recovery from burning out effect (healing over time? healing from sleeping state?)
// Add enhanced strength
// Add lifesteal
// Add "overdrive" secondary mode (right click on spell icon while already active)
// Fix up mood damage calcs
// Testing

/datum/action/cooldown/spell/spirit_force_camellia
	name = "Spirit Force - A Vengeful Bloom"
	desc = "Utilize the latent wrath within your spirit. It will give you the strength to forge ahead."
	button_icon_state = "charge"

	sound = 'sound/magic/charge.ogg'

	school = SCHOOL_HOLY
	cooldown_time = 60 SECONDS

	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/spirit_force_camellia/cast(mob/living/cast_on)
	. = ..()

	if(cast_on.has_status_effect(/datum/status_effect/spirit_force_camellia))
		cast_on.remove_status_effect(/datum/status_effect/spirit_force_camellia)

	if(cast_on.mob_mood.sanity <= SANITY_UNSTABLE)
		return SPELL_CANCEL_CAST

	cast_on.apply_status_effect(/datum/status_effect/spirit_force_camellia)

/datum/mood_event/spirit_force_camellia
	description = "My spirit is on fire."
	mood_change = 4

/datum/mood_event/spirit_force_camellia/add_effects()
	RegisterSignal(owner, COMSIG_MOB_AFTER_APPLY_DAMAGE, PROC_REF(update_mood))

/datum/mood_event/spirit_force_camellia/remove_effects()
	UnregisterSignal(owner, COMSIG_MOB_AFTER_APPLY_DAMAGE)

/datum/mood_event/spirit_force_camellia/proc/update_mood(atom/source, damage)
	var/old_mood = mood_change
	mood_change -= damage * 0.1 //add a max mood change malus and make it not count negative damage
	if(old_mood != mood_change)
		owner.mob_mood.update_mood()

/datum/status_effect/spirit_force_camellia
	id = "spirit_force_camellia"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/spirit_force_camellia

/datum/status_effect/spirit_force_camellia/on_apply()
	owner.add_mood_event("spirit_force_camellia", /datum/mood_event/spirit_force_camellia)
	owner.add_filter("spirit_force", 2, list("type" = "drop_shadow", "x" = 0, "y" = 1, "color" = COLOR_DARK_RED, "size" = 2))
	owner.add_consciousness_modifier("spirit_force", 0)
	return ..()

/datum/status_effect/spirit_force_camellia/on_remove()
	owner.clear_mood_event("spirit_force_camellia")
	owner.remove_filter("spirit_force")

/datum/status_effect/spirit_force_camellia/tick(seconds_between_ticks)
	. = ..()

	if(owner.mob_mood.sanity <= SANITY_UNSTABLE)
		qdel(src)

/atom/movable/screen/alert/status_effect/spirit_force_camellia
	name = "Spirit Force"
	desc = "You have enhanced power and lifesteal, but this is taxing on your soul. Damage also applies to your mood and consciousness. Low sanity will turn off this spell."
	icon_state = "lightningorb"


/datum/action/cooldown/spell/pointed/unlock_chromatic_world
	name = "Unlock - Chromatic World"
	desc = "The world knows better than to stand in your way. Use on a supported object to unlock it."
	button_icon = 'maplestation_modules/story_content/__crit_equipment/icons/unlock_spell.dmi'
	button_icon_state = "unlock"

	background_icon_state = "bg_default"
	overlay_icon_state = "bg_default_border"

	sound = 'sound/magic/blink.ogg'

	school = SCHOOL_FORBIDDEN
	cooldown_time = 8 SECONDS

	active_msg = "You prepare to unlock a target..."
	deactive_msg = "You dispel your unlocking focus."

	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/pointed/unlock_chromatic_world/is_valid_target(atom/cast_on)
	if(istype(cast_on, /obj/machinery/door/airlock))
		return cast_on

	if(isliving(cast_on))
		var/mob/living/check_him = cast_on

		if(locate(/obj/item/storage/belt/olivia_blade_sheath) in check_him.get_contents())
			return TRUE
		else
			owner.balloon_alert(owner, "nothing to unlock!")
			return FALSE

	else
		return FALSE

/datum/action/cooldown/spell/pointed/unlock_chromatic_world/cast(atom/cast_on)
	. = ..()

	if(istype(cast_on, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/airlock_to_open = cast_on
		airlock_to_open.open(FORCING_DOOR_CHECKS)

	if(isliving(cast_on))
		var/mob/living/check_him = cast_on
		var/obj/item/storage/belt/olivia_blade_sheath/sheath_to_find = locate() in check_him.get_contents()
		if(sheath_to_find.toggle_sheath_lock())
			cast_on.balloon_alert(owner, "blade unlocked!")
		else if (sheath_to_find) // just in case is_valid_target didnt do its job
			cast_on.balloon_alert(owner, "blade locked!")

