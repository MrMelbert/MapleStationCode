/mob/living/verb/impede_speech()
	set name = "Impede Speech"
	set desc = "Apply a speech impediment to your character momentarily."
	set category = "IC"

	if(usr != src)
		CRASH("Non-own mob using impede speech verb.")
	if(stat >= UNCONSCIOUS)
		to_chat(src, span_warning("You can't talk right now."))
		return

	var/static/list/impediments
	if(!impediments)
		impediments = list("Cancel" = 1)
		var/list/blacklist = list(/datum/status_effect/speech/stutter/anxiety)
		for(var/datum/status_effect/speech/effect as anything in subtypesof(/datum/status_effect/speech) - blacklist)
			impediments[initial(effect.id)] = effect

	var/picked = tgui_input_list(src, "Select a speech impediment. Lasts 1 minute, also stacks.", "Impede Speech", impediments)
	if(stat >= UNCONSCIOUS || QDELETED(src))
		to_chat(src, span_warning("You can't talk right now."))
		return
	if(picked == "Cancel")
		return

	var/picked_real = impediments[picked]
	if(!ispath(picked_real, /datum/status_effect/speech))
		return

	adjust_timed_status_effect(1 MINUTES, picked_real)
