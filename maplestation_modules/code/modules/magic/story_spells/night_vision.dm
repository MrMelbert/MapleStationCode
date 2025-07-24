#define EYESOFNIGHT_ATTUNEMENT_DARK 0.5
#define EYESOFNIGHT_MANA_COST 20

/datum/action/cooldown/spell/eyes_of_night
	name = "Eyes Of Night"
	desc = "Strengthens your ability to see through darkness, making the world seem brighter."
	button_icon = 'icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "augmented_eyesight"

	cooldown_time = 30 SECONDS // should generally match duration, as this costs mana to use
	spell_requirements = NONE
	var/mana_cost = EYESOFNIGHT_MANA_COST

	/// The duration of the night vision
	var/vision_duration = 30 SECONDS


/datum/action/cooldown/spell/eyes_of_night/New(Target)
	. = ..()

	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_DARK] += EYESOFNIGHT_ATTUNEMENT_DARK

	AddComponent(/datum/component/uses_mana/spell, \
		activate_check_failure_callback = CALLBACK(src, PROC_REF(spell_cannot_activate)), \
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \
		mana_required = mana_cost, \
		attunements = attunements, \
	)

/datum/action/cooldown/spell/eyes_of_night/Remove(mob/living/remove_from)
	REMOVE_TRAIT(remove_from, TRAIT_TRUE_NIGHT_VISION, MAGIC_TRAIT)
	remove_from.update_sight()
	return ..()

/datum/action/cooldown/spell/eyes_of_night/is_valid_target(atom/cast_on)
	return isliving(cast_on) && !HAS_TRAIT(cast_on, TRAIT_THERMAL_VISION)

/datum/action/cooldown/spell/eyes_of_night/cast(mob/living/cast_on)
	. = ..()
	ADD_TRAIT(cast_on, TRAIT_TRUE_NIGHT_VISION, MAGIC_TRAIT)
	cast_on.update_sight()
	to_chat(cast_on, span_info("You focus your eyes intensely, the shadows around you slowly withdrawing"))
	addtimer(CALLBACK(src, PROC_REF(deactivate), cast_on), vision_duration)

/datum/action/cooldown/spell/eyes_of_night/proc/deactivate(mob/living/cast_on)
	if(QDELETED(cast_on) || !HAS_TRAIT_FROM(cast_on, TRAIT_TRUE_NIGHT_VISION, MAGIC_TRAIT))
		return

	REMOVE_TRAIT(cast_on, TRAIT_TRUE_NIGHT_VISION, MAGIC_TRAIT)
	cast_on.update_sight()
	to_chat(cast_on, span_info("You blink a few times, your vision returning to normal."))

