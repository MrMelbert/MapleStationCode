/// Drugginess / "high" effect, makes your screen rainbow
/datum/status_effect/drugginess
	id = "drugged"
	alert_type = /atom/movable/screen/alert/status_effect/high
	remove_on_fullheal = TRUE

	var/mood_type = /datum/mood_event/high
	var/granted_language = /datum/language/beachbum

/datum/status_effect/drugginess/on_creation(mob/living/new_owner, duration = 10 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/drugginess/on_apply()
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(remove_drugginess))

	owner.add_mood_event(id, mood_type)
	owner.overlay_fullscreen(id, /atom/movable/screen/fullscreen/high)
	owner.sound_environment_override = SOUND_ENVIRONMENT_DRUGGED
	if(granted_language)
		owner.grant_language(granted_language, source = id)
	return TRUE

/datum/status_effect/drugginess/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)

	owner.clear_mood_event(id)
	owner.clear_fullscreen(id)
	if(owner.sound_environment_override == SOUND_ENVIRONMENT_DRUGGED)
		owner.sound_environment_override = SOUND_ENVIRONMENT_NONE
	if(granted_language)
		owner.remove_language(granted_language, source = id)

/// Removes all of our drugginess (self delete) on signal
/datum/status_effect/drugginess/proc/remove_drugginess(datum/source, admin_revive)
	SIGNAL_HANDLER

	qdel(src)

/// The status effect for "drugginess"
/atom/movable/screen/alert/status_effect/high
	name = "High"
	desc = "Whoa man, you're tripping balls! Careful you don't get addicted... if you aren't already."
	icon_state = "high"
