/// Component for items that are used to draw and create runes.
/datum/component/advanced_ritual_item
	/// Whether we are currently being used to draw a rune.
	var/drawing_a_rune = FALSE
	/// Whether we can scrape runes (destroy them / clean them)
	var/can_scrape_runes = TRUE
	/// Whether we can hit cult buildings to unanchor them
	var/can_move_buildings = TRUE

	var/examine_message
	/// What antag datum is required to use this
	var/required_antag_datum
	/// A list of turfs that we scribe runes at double speed on
	var/list/turfs_that_boost_us

/datum/component/advanced_ritual_item/Initialize(
	can_scrape_runes = TRUE,
	can_move_buildings = TRUE,
	examine_message,
	required_antag_datum = /datum/antagonist/advanced_cult,
	turfs_that_boost_us = /turf/open/floor/engine/cult,
	)

	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.examine_message = examine_message
	src.can_scrape_runes = can_scrape_runes
	src.can_move_buildings = can_move_buildings
	src.required_antag_datum = required_antag_datum

	if(islist(turfs_that_boost_us))
		src.turfs_that_boost_us = turfs_that_boost_us
	else if(ispath(turfs_that_boost_us))
		src.turfs_that_boost_us = list(turfs_that_boost_us)

/datum/component/advanced_ritual_item/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, .proc/try_scribe_rune)

	if(examine_message)
		RegisterSignal(parent, COMSIG_PARENT_EXAMINE, .proc/on_examine)

	if(can_scrape_runes || can_move_buildings)
		RegisterSignal(parent, COMSIG_ITEM_ATTACK_OBJ, .proc/try_hit_thing)

/datum/component/advanced_ritual_item/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ITEM_ATTACK_SELF)
	UnregisterSignal(parent, COMSIG_PARENT_EXAMINE)
	UnregisterSignal(parent, COMSIG_ITEM_ATTACK_OBJ)

/*
 * Signal proc for [COMSIG_PARENT_EXAMINE]. Tells the examiner, if they're someone
 * who can use the item (pass the antag check), that it's a valid ritual item.
 */
/datum/component/advanced_ritual_item/proc/on_examine(datum/source, mob/examiner, list/examine_text)
	if(!check_antag_datum(examiner))
		return

	examine_text += examine_message

/*
 * Signal proc for [COMSIG_ITEM_ATTACK_SELF]. Allows the user to scribe runes.
 */
/datum/component/advanced_ritual_item/proc/try_scribe_rune(datum/source, mob/cultist)
	if(!isliving(cultist))
		return

	if(!check_rune_turf(get_turf(cultist), cultist))
		return

	if(!check_antag_datum(cultist))
		return

	if(drawing_a_rune)
		return

	INVOKE_ASYNC(src, .proc/start_scribe_rune, source, cultist)

	return COMPONENT_CANCEL_ATTACK_CHAIN

/*
 * Signal proc for [COMSIG_ITEM_ATTACK_OBJ]. Allows the ritual items to unanchor cult buildings or remove runes.
 */
/datum/component/advanced_ritual_item/proc/try_hit_thing(datum/source, obj/structure/target, mob/cultist)
	if(!isliving(cultist))
		return

	if(!check_antag_datum(cultist))
		return

	if(can_move_buildings)
		if(istype(target, /obj/structure/girder/cult))
			INVOKE_ASYNC(src, .proc/destroy_girder, target, cultist)
			return COMPONENT_NO_AFTERATTACK

		if(istype(target, /obj/structure/destructible/cult))
			INVOKE_ASYNC(src, .proc/unanchor_structure, target, cultist)
			return COMPONENT_NO_AFTERATTACK

	if(can_scrape_runes)
		if(istype(target, /obj/effect/rune))
			INVOKE_ASYNC(src, .proc/scrape_rune, target, cultist)
			return COMPONENT_NO_AFTERATTACK

/*
 * Destoys the target cult girder [cult_girder], acted upon by [cultist].
 */
/datum/component/advanced_ritual_item/proc/destroy_girder(obj/structure/girder/cult/cult_girder, mob/living/cultist)
	cultist.visible_message(
		span_warning("[cultist] strikes [cult_girder] with [parent]!"),
		span_notice("You demolish [cult_girder].")
		)
	new /obj/item/stack/sheet/runed_metal(cult_girder.drop_location(), 1)
	qdel(cult_girder)

/*
 * Unanchors the target cult building [cult_structure], acted upon by [cultist].
 */
/datum/component/advanced_ritual_item/proc/unanchor_structure(obj/structure/cult_structure, mob/living/cultist)
	cult_structure.set_anchored(!cult_structure.anchored)
	to_chat(cultist, span_notice("You [cult_structure.anchored ? "":"un"]secure \the [cult_structure] [cult_structure.anchored ? "to":"from"] the floor."))

/*
 * Removes the targeted rune [rune], acted upon by [cultist].
 */
/datum/component/advanced_ritual_item/proc/scrape_rune(obj/effect/rune/rune, mob/living/cultist)
	SEND_SOUND(cultist, 'sound/items/sheath.ogg')
	if(!do_after(cultist, rune.erase_time, target = rune))
		return

	if(rune.log_when_erased)
		log_game("[rune.cultist_name] rune erased by [key_name(cultist)] with [parent].")
		message_admins("[ADMIN_LOOKUPFLW(cultist)] erased a [rune.cultist_name] rune with [parent].")

	to_chat(cultist, span_notice("You carefully erase the [lowertext(rune.cultist_name)] rune."))
	qdel(rune)

/*
 * Checks if [target] turf is valid for having a rune placed there, by [cultist].
 */
/datum/component/advanced_ritual_item/proc/check_rune_turf(turf/target, mob/living/cultist)
	if(isspaceturf(target))
		to_chat(cultist, span_warning("You cannot scribe runes in space!"))
		return FALSE
	if(locate(/obj/effect/rune) in target)
		to_chat(cultist, span_cult("There is already a rune here."))
		return FALSE
	var/area/our_area = get_area(target)
	if((!is_station_level(target.z) && !is_mining_level(target.z)) || (our_area && !(our_area.area_flags & CULT_PERMITTED)))
		to_chat(cultist, span_warning("The veil is not weak enough here."))
		return FALSE
	return TRUE

/*
 * Checks if [cultist] has the correct antag datum and cult style.
 */
/datum/component/advanced_ritual_item/proc/check_antag_datum(mob/living/cultist)
	var/datum/antagonist/advanced_cult/cult = cultist.mind.has_antag_datum(required_antag_datum)
	return (cult && istype(parent, cult.cultist_style.ritual_item))

/*
 * Wraps the entire act of [proc/actually_scribe_rune] to ensure it properly enables or disables [var/drawing_a_rune]
 */
/datum/component/advanced_ritual_item/proc/start_scribe_rune(obj/item/tool, mob/living/cultist)
	drawing_a_rune = TRUE
	actually_scribe_rune(tool, cultist)
	drawing_a_rune = FALSE

/*
 * Actually give the [cultist] input to begin scribing a rune with [tool], and scribe it if successful.
 */
/datum/component/advanced_ritual_item/proc/actually_scribe_rune(obj/item/tool, mob/living/cultist)
	var/turf/our_turf = get_turf(cultist)
	var/obj/effect/rune/rune_to_scribe
	var/entered_rune_name
	var/chosen_keyword
	if(!check_rune_turf(our_turf, cultist))
		return FALSE

	var/datum/antagonist/advanced_cult/cultist_antag = cultist.mind.has_antag_datum(/datum/antagonist/advanced_cult)
	var/list/rune_types = cultist_antag.cultist_style.get_allowed_runes(cultist_antag)

	entered_rune_name = input(cultist, "Choose a rite to scribe.", "Sigils of Power") as null|anything in rune_types
	if(!src || QDELETED(src) || !tool.Adjacent(cultist) || cultist.incapacitated() || !check_rune_turf(our_turf, cultist))
		return FALSE

	rune_to_scribe = GLOB.rune_types[entered_rune_name]
	if(!rune_to_scribe)
		return FALSE

	if(initial(rune_to_scribe.req_keyword))
		chosen_keyword = stripped_input(cultist, "Enter a keyword for the new rune.", "Words of Power")
		if(!chosen_keyword)
			return FALSE

	our_turf = get_turf(cultist) //we may have moved. adjust as needed...
	if(!src || QDELETED(src) || !tool.Adjacent(cultist) || cultist.incapacitated() || !check_rune_turf(our_turf, cultist))
		return FALSE

	cultist.visible_message(
		span_warning("[cultist] [cultist.blood_volume ? "cuts open [cultist.p_their()] arm and begins writing in [cultist.p_their()] own blood":"begins sketching out a strange design"]!"),
		span_cult("You [cultist.blood_volume ? "slice open your arm and ":""]begin drawing a sigil of the Geometer.")
		)

	if(cultist.blood_volume)
		cultist.apply_damage(initial(rune_to_scribe.scribe_damage), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM), wound_bonus = CANT_WOUND) // *cuts arm* *bone explodes* ever have one of those days?

	var/scribe_mod = initial(rune_to_scribe.scribe_delay)
	if(our_turf.type in turfs_that_boost_us)
		scribe_mod *= 0.5

	if(!do_after(cultist, scribe_mod, target = get_turf(cultist), timed_action_flags = IGNORE_SLOWDOWNS))
		return FALSE
	if(!check_rune_turf(our_turf, cultist))
		return FALSE

	cultist.visible_message(
		span_warning("[cultist] creates a strange circle[cultist.blood_volume ? " in [cultist.p_their()] own blood":""]."),
		span_cult("You finish drawing the arcane markings of the Geometer.")
		)

	var/obj/effect/rune/made_rune = new rune_to_scribe(our_turf, chosen_keyword)
	made_rune.add_mob_blood(cultist)

	to_chat(cultist, span_cult("The [lowertext(made_rune.cultist_name)] rune [made_rune.cultist_desc]"))
	SSblackbox.record_feedback("tally", "cult_runes_scribed", 1, made_rune.cultist_name)

	return TRUE
