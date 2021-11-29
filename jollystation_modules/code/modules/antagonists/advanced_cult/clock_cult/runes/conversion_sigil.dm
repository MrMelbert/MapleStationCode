/obj/effect/rune/clock_convert
	name = "sigil"
	desc = "An odd collection of symbols that glint when shined light upon."
	cultist_name = "Sigil of Submission"
	cultist_desc = "subject a non-cultist to the power of Rat'var, converting the victim to your cult. If you opted out of conversion, or the victim is mindshielded, subjects them to torment instead."
	invocation = "Fho'zvg Gb Engine!"
	icon = 'jollystation_modules/icons/effects/clockwork_effects.dmi'
	icon_state = "sigilsubmission"
	color = RUNE_COLOR_OFFER

/obj/effect/rune/clock_convert/invoke(list/invokers)
	var/mob/living/user = invokers[1]
	if(rune_in_use)
		to_chat(user, span_warning("The [cultist_name] is currently in use!"))
		return

	var/list/myriad_targets = list()
	for(var/mob/living/potential_convertee in get_turf(src))
		if(IS_CULTIST(potential_convertee))
			continue

		myriad_targets |= potential_convertee

	if(!myriad_targets.len)
		fail_invoke()
		return

	visible_message(span_warning("[src] pulses a mesmerizing purple!"))
	var/mob/living/convertee = pick(myriad_targets)

	INVOKE_ASYNC(src, .proc/invoke_wrapper, convertee, user)

	. = ..()

/obj/effect/rune/clock_convert/proc/invoke_wrapper(mob/living/convertee, mob/living/user)
	rune_in_use = TRUE
	invoke_process(convertee, user)
	rune_in_use = FALSE

	revert_color()

/obj/effect/rune/clock_convert/proc/invoke_process(mob/living/convertee, mob/living/user)
	var/datum/antagonist/advanced_cult/cultist = user.mind.has_antag_datum(/datum/antagonist/advanced_cult, TRUE)
	var/datum/team/advanced_cult/cult_team = cultist?.get_team()
	if(!cultist || !cult_team)
		stack_trace("[user] attempted to convert someone to their cult, but had no [cultist ? "cult team":"cult antag datum"]!")
		to_chat(user, span_warning("For some reason or another, you could not begin to invoke the [cultist_name]. Contact your local god!"))
		return

	switch(cult_team.can_join_cult(convertee))
		if(CONVERSION_NOT_ALLOWED)
			var/list/invocations = list(
				"Zl wbhearl vf zl bja...",
				"Ohg Engine'f Yv'tug Fuv-arf...",
				"Vagb Lbhe Zvaq, Urer'gvp!",
			)
			if(!invoke_do_afters(convertee, user, invocations))
				return FALSE

			do_torment(convertee, user, protected = FALSE)
		if(CONVERSION_FAILED)
			var/list/invocations = list(
				"Engine'f Yv'tug Vf Haf'gbc-cnoyr...",
				"Ab Fuv'ryq Abe Zvaq Pna Erf'v-fg.",
				"Rzoen'pr Gur Yv'tug, Urer'gvp!",
				"Lbh Pna'abg Rf-pncr Uvf Tybel!",
			)
			if(!invoke_do_afters(convertee, user, invocations))
				return FALSE

			do_torment(convertee, user, protected = TRUE)
		if(CONVERSION_SUCCESS)
			var/list/invocations = list(
				"Ongur Va Gur Yv'tug Bs Engine!",
				"Fhozvg Gb Gurve Juvz!",
				"Zrepl Jvyy Or Tvira Ba Uvf Nev'iny.",
				"Fheeraqre, Jrnx-Zvaq'rq!",
			)
			if(!invoke_do_afters(convertee, user, invocations))
				return FALSE

			do_convert(convertee, user, cult_team)

	return TRUE

/obj/effect/rune/clock_convert/proc/invoke_do_afters(mob/living/convertee, mob/living/user, list/invocations)
	for(var/i in 1 to invocations.len)
		animate(src, color = COLOR_MAGENTA, time = 2 SECONDS)
		addtimer(CALLBACK(src, /atom/proc/update_atom_colour), 2 SECONDS)
		addtimer(CALLBACK(src, .proc/revert_color, 2 SECONDS), 3 SECONDS)
		if(!do_after(user, 6 SECONDS, convertee))
			fail_invoke()
			return FALSE

		if(QDELETED(user) || QDELETED(convertee) || QDELETED(src))
			return FALSE

		if(!IS_CULTIST(user) || !user.Adjacent(src) || !(convertee in get_turf(src)))
			fail_invoke()
			return FALSE

		if(anti_cult_magic_check(convertee, user))
			fail_invoke()
			return FALSE

		if(convertee.getStaminaLoss() <= 100)
			convertee.apply_damage(50, STAMINA, BODY_ZONE_CHEST)
		convertee.stuttering += 10
		user.say(invocations[i], language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")

	return TRUE

/obj/effect/rune/clock_convert/proc/revert_color(duration = 5)
	animate(src, color = initial(color), time = duration)
	addtimer(CALLBACK(src, /atom/proc/update_atom_colour), duration)

/obj/effect/rune/clock_convert/proc/do_convert(mob/living/convertee, mob/living/user, datum/team/advanced_cult/cult)
	if(!cult)
		CRASH("[type] - do_convert attempted without a destination cult team!")

	if(cult.can_join_cult(convertee) != CONVERSION_SUCCESS)
		return FALSE

	convertee.heal_and_revive(50, span_warning("[convertee] writhes in pain as the sigil below [convertee.p_them()] flashes!"))
	to_chat(convertee, span_heavy_brass("AAAAAAAAAAAAAA-"))

	var/datum/antagonist/advanced_cult/new_cultist = convertee.mind.add_antag_datum(/datum/antagonist/advanced_cult/convertee)
	if(!new_cultist)
		CRASH("[type] - do_convert failed to add an antag datum onto [convertee.mind]!")

	new_cultist.team = cult
	new_cultist.finalize_antag()

	convertee.Unconscious(10 SECONDS)
	to_chat(convertee, span_heavy_brass("Your eyes twitch. Your head throbs. You can hear every machine around you tick at once. The veil of reality has been ripped away and something evil takes root."))
	to_chat(convertee, span_brasstalics("Assist your new compatriots in their unceasing work. Your goal is theirs, and theirs is yours."))
	if(ishuman(convertee))
		var/mob/living/carbon/human/human_convertee = convertee
		human_convertee.uncuff()
		human_convertee.stuttering = 0

	return TRUE

/obj/effect/rune/clock_convert/proc/do_torment(mob/living/convertee, mob/living/user, protected)
	//if(cult.can_join_cult(convertee) == CONVERSION_SUCCESS)
	//	return FALSE
