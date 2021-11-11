/obj/item/melee/cultblade/dagger/scribe_rune_attempt(mob/living/user)
	if(user.mind.has_antag_datum(/datum/antagonist/advanced_cult))
		advanced_scribe_rune_attempt(user)
	else
		return ..()

/obj/item/melee/cultblade/dagger/proc/advanced_scribe_rune_attempt(mob/living/user)
	var/turf/our_turf = get_turf(user)
	var/chosen_keyword
	var/obj/effect/rune/rune_to_scribe
	var/entered_rune_name
	if(!check_rune_turf(our_turf, user))
		return
	if(!LAZYLEN(GLOB.rune_types))
		return
	var/static/list/advanced_rune_types = GLOB.rune_types.Copy()
	var/datum/antagonist/advanced_cult/cultist = user.mind.has_antag_datum(/datum/antagonist/advanced_cult)
	var/datum/advanced_antag_datum/cultist/adv_cultist = cultist?.linked_advanced_datum
	if(!adv_cultist)
		CRASH("An antagonist is attempted to scribe a rune via advanced_scribe_rune_attempt that shouldn't be!")

	// Consider: adding cosmetic runes
	// to replace these runes being removed
	if(adv_cultist.no_conversion)
		advanced_rune_types -= "Offer" // obviously, no converting
		advanced_rune_types -= "Boil Blood" // requires 3 invokers
		advanced_rune_types -= "Summon Cultist" // useless
		advanced_rune_types -= "Revive" // useless

	advanced_rune_types -= "Apocalypse" // does not work without a summon objective (nar'sie)
	advanced_rune_types -= "Nar'Sie" // nope, nuh uh

	entered_rune_name = input(user, "Choose a rite to scribe.", "Sigils of Power") as null|anything in advanced_rune_types
	if(!src || QDELETED(src) || !Adjacent(user) || user.incapacitated() || !check_rune_turf(our_turf, user))
		return
	rune_to_scribe = GLOB.rune_types[entered_rune_name]
	if(!rune_to_scribe)
		return
	if(initial(rune_to_scribe.req_keyword))
		chosen_keyword = stripped_input(user, "Enter a keyword for the new rune.", "Words of Power")
		if(!chosen_keyword)
			drawing_rune = FALSE
			scribe_rune(user) //Go back a menu!
			return
	our_turf = get_turf(user) //we may have moved. adjust as needed...
	if(!src || QDELETED(src) || !Adjacent(user) || user.incapacitated() || !check_rune_turf(our_turf, user))
		return

	user.visible_message(
		span_warning("[user] [user.blood_volume ? "cuts open [user.p_their()] arm and begins writing in [user.p_their()] own blood":"begins sketching out a strange design"]!"),
		span_cult("You [user.blood_volume ? "slice open your arm and ":""]begin drawing a sigil of the Geometer.")
		)
	if(user.blood_volume)
		user.apply_damage(initial(rune_to_scribe.scribe_damage), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM), wound_bonus = CANT_WOUND) // *cuts arm* *bone explodes* ever have one of those days?

	var/scribe_mod = initial(rune_to_scribe.scribe_delay)
	if(istype(get_turf(user), /turf/open/floor/engine/cult) && !(ispath(rune_to_scribe, /obj/effect/rune/narsie)))
		scribe_mod *= 0.5

	if(!do_after(user, scribe_mod, target = get_turf(user), timed_action_flags = IGNORE_SLOWDOWNS))
		return
	if(!check_rune_turf(our_turf, user))
		return
	user.visible_message(
		span_warning("[user] creates a strange circle[user.blood_volume ? " in [user.p_their()] own blood":""]."),
		span_cult("You finish drawing the arcane markings of the Geometer.")
		)

	var/obj/effect/rune/made_rune = new rune_to_scribe(our_turf, chosen_keyword)
	made_rune.add_mob_blood(user)
	to_chat(user, span_cult("The [lowertext(made_rune.cultist_name)] rune [made_rune.cultist_desc]"))
	SSblackbox.record_feedback("tally", "cult_runes_scribed", 1, made_rune.cultist_name)
