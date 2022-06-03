/datum/action/item_action/cult/clock_spell/item_conversion
	name = "Slab: Brass Touch"
	desc = "Empowers the slab to convert structures and items into brass after a channel."
	examine_hint = "channels on the target structure or item, morphing it into a brass Rat-varian version if possible. Turns iron into brass sheets."
	button_icon_state = "integration_cog"
	invocation = "Gb-hpu bs oen'ff!"
	active_overlay_name = "compromise"
	active_overlay_held_name = "slab_compromise"
	charges = 5
	manually_handle_charges = TRUE
	/// Whether this is currently being channeled
	var/currently_casting = FALSE

/datum/action/item_action/cult/clock_spell/item_conversion/do_atom_spell_effects(atom/hit, mob/living/user)
	if(currently_casting)
		to_chat(user, span_warning("You are currently channeling [src]!"))
		return TRUE

	INVOKE_ASYNC(src, .proc/wrap_convert_atom, hit, user)
	return TRUE

/*
 * Wraps [proc/convert_atom] to ensure [var/currently_casting] is enabled and disabled correctly.
 */
/datum/action/item_action/cult/clock_spell/item_conversion/proc/wrap_convert_atom(atom/hit, mob/living/user)
	currently_casting = TRUE
	convert_atom(hit, user)
	currently_casting = FALSE

/*
 * Call ratvat_act() on [hit] after a two do-afters and some time.
 */
/datum/action/item_action/cult/clock_spell/item_conversion/proc/convert_atom(atom/hit, mob/living/user)

	// We generate these phrases here, becaues ratvar_act qdel's it and it could act funky
	var/end_vis_message = span_brass("[hit] glows a bright blue as it suddenly appears encased in brass!")
	var/end_self_message = span_brass("In a spark of blue, you transform [hit] into brass!")

	var/obj/effect/rep_fab_conversion/conversion_effect = new /obj/effect/rep_fab_conversion(isturf(hit) ? hit : hit.drop_location())
	var/conversion_time = 2 SECONDS

	if(isstructure(hit) || ismachinery(hit))
		conversion_time *= 2
	if(isturf(hit))
		conversion_time *= 1.5

	if(conversion_time > 2 SECONDS)
		playsound(get_turf(hit), 'sound/machines/airlockforced.ogg', 50, TRUE)
		do_sparks(5, TRUE, hit)

	animate(conversion_effect, alpha = 200, time = conversion_time)
	to_chat(user, span_brass("You begin converting [hit] to brass..."))
	user.whisper(invocation, language = /datum/language/common, forced = "cult invocation")

	if(!do_after(user, conversion_time * 2, hit))
		qdel(conversion_effect)
		return

	if(QDELETED(src) || QDELETED(hit) || QDELETED(user))
		qdel(conversion_effect)
		return

	conversion_effect.SpinAnimation(7, 1)
	if(!do_after(user, conversion_time, hit))
		qdel(conversion_effect)
		return

	if(QDELETED(src) || QDELETED(hit) || QDELETED(user))
		qdel(conversion_effect)
		return

	conversion_effect.completion_fade(200)

	// Turfs have special args
	if(isturf(hit))
		var/turf/hit_turf = hit
		hit_turf.ratvar_act(FALSE, TRUE)

	// Everything else is fine though
	else
		hit.ratvar_act()

	hit.visible_message(end_vis_message, ignored_mobs = user)
	to_chat(user, end_self_message)
	animate(conversion_effect, alpha = 0, time = 0.5 SECONDS)
	QDEL_IN(conversion_effect, 0.6 SECONDS)

	if(--charges <= 0)
		qdel(src)
		return

	desc = base_desc + "<br><b><u>Has [charges] use\s remaining</u></b>." // TODO: Doesn't work
