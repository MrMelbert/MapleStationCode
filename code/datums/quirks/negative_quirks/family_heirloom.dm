/datum/quirk/item_quirk/family_heirloom
	name = "Family Heirloom"
	desc = "You are the current owner of an heirloom, passed down for generations. \
		The heirloom is based on your species, job, or one you selected in the loadout. \
		You have to keep it safe!"
	icon = FA_ICON_TOOLBOX
	value = -2
	medical_record_text = "Patient demonstrates an unnatural attachment to a family heirloom."
	hardcore_value = 1
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES|QUIRK_MOODLET_BASED|QUIRK_CHANGES_APPEARANCE
	/// A weak reference to our heirloom.
	var/datum/weakref/heirloom
	mail_goodies = list(/obj/item/storage/briefcase/secure)

/datum/quirk/item_quirk/family_heirloom/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/heirloom_type

	var/list/loadout = get_active_loadout(client_source?.prefs)
	var/loadout_heirloom = FALSE
	for(var/item_path in loadout)
		if(loadout[item_path][INFO_HEIRLOOM])
			heirloom_type = item_path
			loadout_heirloom = TRUE
			break

	if(!loadout_heirloom && !GLOB.holy_weapon_type && quirk_holder.mind?.holy_role)
		for(var/obj/item/nullrod/rod in GLOB.steal_item_handler.objectives_by_path[/obj/item/nullrod])
			var/turf/rod_turf = get_turf(rod)
			if(!is_station_level(rod_turf.z))
				continue
			heirloom = WEAKREF(rod)
			LAZYADD(where_items_spawned, span_boldnotice("Your [rod.name] can be found in your office. It is your precious family heirloom, keep it safe!"))
			return

	var/datum/species/holder_species = human_holder.dna?.species
	var/datum/job/holder_job = human_holder.mind?.assigned_role
	if(holder_species && LAZYLEN(holder_species.family_heirlooms) && prob(50))
		heirloom_type = pick(holder_species.family_heirlooms)
	else if(holder_job && LAZYLEN(holder_job.family_heirlooms))
		heirloom_type = pick(holder_job.family_heirlooms)

	// If we didn't find an heirloom somehow, throw them a generic one
	heirloom_type ||= pick(/obj/item/toy/cards/deck, /obj/item/lighter, /obj/item/dice/d20)

	var/obj/item/new_heirloom = new heirloom_type(get_turf(human_holder))
	heirloom = WEAKREF(new_heirloom)

	if(loadout_heirloom)
		var/datum/loadout_item/relevant_item = GLOB.all_loadout_datums[heirloom_type]
		relevant_item?.on_equip_item(new_heirloom, client_source?.prefs, loadout, human_holder)

	var/list/spawn_locations = list()
	// specific slots
	if(new_heirloom.slot_flags & ITEM_SLOT_HEAD)
		spawn_locations[LOCATION_HEAD] = ITEM_SLOT_HEAD
	if(new_heirloom.slot_flags & ITEM_SLOT_OCLOTHING)
		spawn_locations["around your body"] = ITEM_SLOT_OCLOTHING
	if(new_heirloom.slot_flags & ITEM_SLOT_EYES)
		spawn_locations[LOCATION_EYES] = ITEM_SLOT_EYES
	if(new_heirloom.slot_flags & ITEM_SLOT_EARS)
		spawn_locations["covering your ears"] = ITEM_SLOT_EARS
	if(new_heirloom.slot_flags & ITEM_SLOT_GLOVES)
		spawn_locations["covering your hands"] = ITEM_SLOT_GLOVES
	if(new_heirloom.slot_flags & ITEM_SLOT_NECK)
		spawn_locations[LOCATION_NECK] = ITEM_SLOT_NECK
	if(new_heirloom.slot_flags & ITEM_SLOT_MASK)
		spawn_locations["covering your face"] = ITEM_SLOT_MASK
	if(new_heirloom.slot_flags & ITEM_SLOT_FEET)
		spawn_locations["covering your feet"] = ITEM_SLOT_FEET
	if(new_heirloom.slot_flags & ITEM_SLOT_BELT)
		spawn_locations["around your waist"] = ITEM_SLOT_BELT
	// defaults / accessories can just go to backpack, that's fine
	spawn_locations[LOCATION_LPOCKET] = ITEM_SLOT_LPOCKET
	spawn_locations[LOCATION_RPOCKET] = ITEM_SLOT_RPOCKET
	spawn_locations[LOCATION_BACKPACK] = ITEM_SLOT_BACKPACK
	spawn_locations[LOCATION_HANDS] = ITEM_SLOT_HANDS

	give_item_to_holder(
		new_heirloom,
		spawn_locations,
		flavour_text = "This is a precious family heirloom, passed down from generation to generation. Keep it safe!",
		notify_player = TRUE,
	)

/datum/quirk/item_quirk/family_heirloom/post_add()
	var/list/names = splittext(quirk_holder.real_name, " ")
	var/family_name = names[names.len]

	var/obj/item/family_heirloom = heirloom?.resolve()
	if(isnull(family_heirloom))
		to_chat(quirk_holder, span_boldnotice("A wave of existential dread runs over you as you realize your precious family heirloom is missing. Perhaps the Gods will show mercy on your cursed soul?"))
		return
	family_heirloom.AddComponent(/datum/component/heirloom, quirk_holder.mind, family_name)
	return ..()

/datum/quirk/item_quirk/family_heirloom/process()
	if(HAS_TRAIT(quirk_holder, TRAIT_KNOCKEDOUT))
		return

	var/obj/family_heirloom = heirloom?.resolve()

	if(family_heirloom && get(family_heirloom.loc, /mob/living/carbon/human) == quirk_holder)
		quirk_holder.clear_mood_event("family_heirloom_missing")
		quirk_holder.add_mood_event("family_heirloom", /datum/mood_event/family_heirloom)
	else
		quirk_holder.clear_mood_event("family_heirloom")
		quirk_holder.add_mood_event("family_heirloom_missing", /datum/mood_event/family_heirloom_missing)

/datum/quirk/item_quirk/family_heirloom/remove()
	quirk_holder.clear_mood_event("family_heirloom_missing")
	quirk_holder.clear_mood_event("family_heirloom")
