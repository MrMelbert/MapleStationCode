#define WHEELCHAIR_PREFERENCE "Wheelchair"
#define CRUTCHES_MED_PREFERENCE "Crutches (Medical)"
#define CRUTCHES_WOOD_PREFERENCE "Crutches (Wooden)"
#define NONE_PREFERENCE "None"

/// Preference for paraplegics to choose how they get around.
/datum/preference/choiced/paraplegic_aid
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "paraplegic_aid"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	should_generate_icons = TRUE

/datum/preference/choiced/paraplegic_aid/create_default_value()
	return WHEELCHAIR_PREFERENCE

/datum/preference/choiced/paraplegic_aid/init_possible_values()
	return list(WHEELCHAIR_PREFERENCE, CRUTCHES_MED_PREFERENCE, CRUTCHES_WOOD_PREFERENCE, NONE_PREFERENCE)

/datum/preference/choiced/paraplegic_aid/icon_for(value)
	switch(value)
		if(WHEELCHAIR_PREFERENCE)
			return icon(/obj/item/wheelchair::icon, /obj/item/wheelchair::icon_state)
		if(CRUTCHES_MED_PREFERENCE)
			return icon(/obj/item/cane/crutch::icon, /obj/item/cane/crutch::icon_state)
		if(CRUTCHES_WOOD_PREFERENCE)
			return icon(/obj/item/cane/crutch/wood::icon, /obj/item/cane/crutch/wood::icon_state)
		if(NONE_PREFERENCE)
			return icon('icons/hud/screen_gen.dmi', "x")

	return icon('icons/effects/random_spawners.dmi', "questionmark")

/datum/preference/choiced/paraplegic_aid/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE

	return /datum/quirk/paraplegic::name in preferences.all_quirks

/datum/preference/choiced/paraplegic_aid/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/quirk_constant_data/paraplegic
	associated_typepath = /datum/quirk/paraplegic
	customization_options = list(/datum/preference/choiced/paraplegic_aid)

// Overrides paraplegic normal add unique to do our own thing
/datum/quirk/paraplegic/add_unique(client/client_source)

	var/wheelchair_type = client_source?.prefs?.read_preference(/datum/preference/choiced/paraplegic_aid) || NONE_PREFERENCE

	switch(wheelchair_type)
		if(WHEELCHAIR_PREFERENCE)
			// Handle late joins being buckled to arrival shuttle chairs.
			quirk_holder.buckled?.unbuckle_mob(quirk_holder)

			var/turf/holder_turf = get_turf(quirk_holder)
			var/obj/structure/chair/spawn_chair = locate() in holder_turf

			var/obj/vehicle/ridden/wheelchair/wheels
			// More than 5k score? you unlock the gamer wheelchair.
			if(client_source?.get_award_status(/datum/award/score/hardcore_random) >= 5000)
				wheels = new /obj/vehicle/ridden/wheelchair/gold(holder_turf)
			else
				wheels = new /obj/vehicle/ridden/wheelchair(holder_turf)

			// Makes spawning on the arrivals shuttle more consistent looking
			if(spawn_chair)
				wheels.setDir(spawn_chair.dir)

			wheels.buckle_mob(quirk_holder)

			// During the spawning process, they may have dropped what they were holding, due to the paralysis
			// So put the things back in their hands.
			for(var/obj/item/dropped_item in holder_turf)
				if(dropped_item.fingerprintslast == quirk_holder.ckey)
					quirk_holder.put_in_hands(dropped_item)

		if(CRUTCHES_MED_PREFERENCE, CRUTCHES_WOOD_PREFERENCE)
			var/crutch_type = wheelchair_type == CRUTCHES_MED_PREFERENCE ? /obj/item/cane/crutch : /obj/item/cane/crutch/wood
			var/turf/holder_turf = get_turf(quirk_holder)
			for(var/hand in quirk_holder.held_items)
				quirk_holder.put_in_hands(new crutch_type(holder_turf))

#undef WHEELCHAIR_PREFERENCE
#undef CRUTCHES_MED_PREFERENCE
#undef CRUTCHES_WOOD_PREFERENCE
#undef NONE_PREFERENCE
