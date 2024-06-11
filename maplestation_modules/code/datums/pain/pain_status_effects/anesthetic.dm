/// Anesthetics, for use in surgery - to stop pain.
/datum/status_effect/grouped/anesthetic
	id = "anesthetics"
	alert_type = /atom/movable/screen/alert/status_effect/anesthetics
	var/applied_at = -1

/datum/status_effect/grouped/anesthetic/on_creation(mob/living/new_owner, source)
	if(!istype(get_area(new_owner), /area/station/medical))
		// if we're NOT in medical, give no alert. N2O floods or whatever.
		alert_type = null

	return ..()

/datum/status_effect/grouped/anesthetic/on_apply()
	. = ..()
	// Melbert todo : you can't breathe while under anesthetic, so we need a pump or vent or something (TRAIT_ASSISTED_BREATHING)
	RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_KNOCKEDOUT), PROC_REF(try_removal))
	LAZYSET(owner.max_consciousness_values, type, 10)
	applied_at = world.time

/datum/status_effect/grouped/anesthetic/on_remove()
	. = ..()
	UnregisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_KNOCKEDOUT))
	if(!QDELETED(owner))
		LAZYREMOVE(owner.max_consciousness_values, type)
		owner.apply_status_effect(/datum/status_effect/anesthesia_grog, applied_at)

/datum/status_effect/grouped/anesthetic/get_examine_text()
	return span_warning("[owner.p_Theyre()] out cold.")

/datum/status_effect/grouped/anesthetic/proc/try_removal(datum/source)
	SIGNAL_HANDLER

	if(HAS_TRAIT_NOT_FROM(owner, TRAIT_KNOCKEDOUT, STAT_TRAIT))
		return

	qdel(src)

/atom/movable/screen/alert/status_effect/anesthetics
	name = "Anesthetic"
	desc = "Everything's woozy... The world goes dark... You're on anesthetics. \
		Good luck in surgery! If it's actually surgery, that is."
	icon_state = "paralysis"

/datum/status_effect/anesthesia_grog
	id = "anesthesia_grog"
	duration = 4 MINUTES
	alert_type = null
	var/strength = 0

/datum/status_effect/anesthesia_grog/on_creation(mob/living/new_owner, anesthesia_appied_at)
	strength = (world.time - anesthesia_appied_at > 1 MINUTES) ? -100 : -60
	return ..()

/datum/status_effect/anesthesia_grog/on_apply()
	LAZYSET(owner.max_consciousness_values, type, strength)
	to_chat(owner, span_warning("You feel[strength <= -100 ? " ":" a bit "]groggy..."))
	return TRUE

/datum/status_effect/anesthesia_grog/on_remove()
	LAZYREMOVE(owner.max_consciousness_values, type)
