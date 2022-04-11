/// Component for advanced ritual items
/datum/component/cult_ritual_item/advanced
	/// The type of girder we can one-hit.
	var/girder_type
	/// Our types of buildings we can anchor or unanchor.
	var/cult_building_type

/datum/component/cult_ritual_item/advanced/Initialize(
		examine_message,
		action = /datum/action/item_action/cult_dagger,
		turfs_that_boost_us = /turf/open/floor/engine/cult,
		girder_type = /obj/structure/girder/cult,
		cult_building_type = /obj/structure/destructible/cult,
		)

	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return

	src.girder_type = girder_type
	src.cult_building_type = cult_building_type

/datum/component/cult_ritual_item/advanced/try_hit_object(datum/source, obj/structure/target, mob/cultist)
	if(!isliving(cultist) || !IS_CULTIST(cultist))
		return

	if(istype(target, girder_type))
		INVOKE_ASYNC(src, .proc/do_destroy_girder, target, cultist)
		return COMPONENT_NO_AFTERATTACK

	if(istype(target, cult_building_type))
		INVOKE_ASYNC(src, .proc/do_unanchor_structure, target, cultist)
		return COMPONENT_NO_AFTERATTACK

/datum/component/cult_ritual_item/advanced/do_destroy_girder(obj/structure/girder/cult_girder, mob/living/cultist)
	playsound(cult_girder, 'sound/weapons/resonator_blast.ogg', 40, TRUE, ignore_walls = FALSE)
	cultist.visible_message(
		span_warning("[cultist] strikes [cult_girder] with [parent]!"),
		span_notice("You demolish [cult_girder].")
		)
	cult_girder.deconstruct()

/datum/component/cult_ritual_item/advanced/do_scribe_rune(obj/item/tool, mob/living/cultist)
	var/turf/our_turf = get_turf(cultist)
	var/obj/effect/rune/rune_to_scribe
	var/entered_rune_name
	var/chosen_keyword

	var/datum/antagonist/advanced_cult/user_antag = cultist.mind.has_antag_datum(/datum/antagonist/advanced_cult, TRUE)
	var/datum/cult_theme/our_theme = user_antag?.cultist_style
	if(!user_antag || !our_theme)
		stack_trace("[type] - [cultist] attempted to scribe a rune, but did not have an associated [user_antag ? "cult team":"cult antag datum"]!")
		return FALSE

	var/list/allowed_runes = our_theme.get_allowed_runes(user_antag)
	if(!LAZYLEN(allowed_runes))
		to_chat(cultist, "There appears to be no runes to scribe. Contact your god about this!")
		stack_trace("[type] - [cultist] attempted to scribe a rune, but the global rune list is empty!")
		return FALSE

	entered_rune_name = input(cultist, "Choose a rite to scribe.", "Sigils of Power") as null|anything in allowed_runes
	if(!entered_rune_name || !can_scribe_rune(tool, cultist))
		return FALSE

	rune_to_scribe = GLOB.rune_types[entered_rune_name]
	if(!ispath(rune_to_scribe))
		stack_trace("[type] - [cultist] attempted to scribe a rune, but did not find a path from the global rune list!")
		return FALSE

	if(initial(rune_to_scribe.req_keyword))
		chosen_keyword = stripped_input(cultist, "Enter a keyword for the new rune.", "Words of Power")
		if(!chosen_keyword)
			drawing_a_rune = FALSE
			start_scribe_rune(tool, cultist)
			return FALSE

	our_turf = get_turf(cultist) //we may have moved. adjust as needed...

	if(!can_scribe_rune(tool, cultist))
		return FALSE

	if(ispath(rune_to_scribe, /obj/effect/rune/summon) && (!is_station_level(our_turf.z) || istype(get_area(cultist), /area/space)))
		to_chat(cultist, span_cultitalic("The veil is not weak enough here to summon a cultist, you must be on station!"))
		return

	var/list/start_message = our_theme.get_start_making_rune_text(cultist)
	cultist.visible_message(start_message["visible_message"], start_message["self_message"])

	if(our_theme.scribing_takes_blood && cultist.blood_volume)
		cultist.apply_damage(initial(rune_to_scribe.scribe_damage), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM), wound_bonus = CANT_WOUND) // *cuts arm* *bone explodes* ever have one of those days?

	var/scribe_mod = initial(rune_to_scribe.scribe_delay)
	if(!initial(rune_to_scribe.no_scribe_boost) && (our_turf.type in turfs_that_boost_us))
		scribe_mod *= 0.5

	SEND_SOUND(cultist, sound(our_theme.scribe_sound, 0, 1, 10))
	if(!do_after(cultist, scribe_mod, target = get_turf(cultist), timed_action_flags = IGNORE_SLOWDOWNS))
		cleanup_shields()
		return FALSE
	if(!can_scribe_rune(tool, cultist))
		cleanup_shields()
		return FALSE

	var/list/end_message = our_theme.get_end_making_rune_text(cultist)
	cultist.visible_message(end_message["visible_message"], end_message["self_message"])

	cleanup_shields()
	var/obj/effect/rune/made_rune = new rune_to_scribe(our_turf, chosen_keyword)
	if(our_theme.scribing_takes_blood)
		made_rune.add_mob_blood(cultist)

	to_chat(cultist, our_theme.our_cult_span("The [lowertext(made_rune.cultist_name)] rune [made_rune.cultist_desc]"))
	SSblackbox.record_feedback("tally", "cult_runes_scribed", 1, made_rune.cultist_name)

	return TRUE
