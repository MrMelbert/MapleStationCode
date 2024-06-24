/obj/effect/decal/cleanable
	gender = PLURAL
	layer = FLOOR_CLEAN_LAYER
	var/list/random_icon_states = null
	///I'm sorry but cleanable/blood code is ass, and so is blood_DNA
	var/blood_state = ""
	///0-100, amount of blood in this decal, used for making footprints and affecting the alpha of bloody footprints
	var/bloodiness = 0
	///When two of these are on a same tile or do we need to merge them into just one?
	var/mergeable_decal = TRUE
	var/beauty = 0
	///The type of cleaning required to clean the decal. See __DEFINES/cleaning.dm for the options
	var/clean_type = CLEAN_TYPE_LIGHT_DECAL
	///The reagent this decal holds. Leave blank for none.
	var/datum/reagent/decal_reagent
	///The amount of reagent this decal holds, if decal_reagent is defined
	var/reagent_amount = 0

/// Creates a cleanable decal on a turf
/// Use this if your decal is one of one, and thus we should not spawn it if it's there already
/// Returns either the existing cleanable, the one we created, or null if we can't spawn on that turf
/turf/proc/spawn_unique_cleanable(obj/effect/decal/cleanable/cleanable_type)
	// There is no need to spam unique cleanables, they don't stack and it just chews cpu
	var/obj/effect/decal/cleanable/existing = locate(cleanable_type) in src
	if(existing)
		return existing
	return new cleanable_type(src)

/obj/effect/decal/cleanable/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	if (random_icon_states && (icon_state == initial(icon_state)) && length(random_icon_states) > 0)
		icon_state = pick(random_icon_states)
	create_reagents(300)
	if(decal_reagent)
		reagents.add_reagent(decal_reagent, reagent_amount)
	if(loc && isturf(loc))
		for(var/obj/effect/decal/cleanable/C in loc)
			if(C != src && C.type == type && !QDELETED(C))
				if (replace_decal(C))
					handle_merge_decal(C)
					return INITIALIZE_HINT_QDEL

	if(LAZYLEN(diseases))
		var/list/datum/disease/diseases_to_add = list()
		for(var/datum/disease/D in diseases)
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_FLUIDS)
				diseases_to_add += D
		if(LAZYLEN(diseases_to_add))
			AddComponent(/datum/component/infective, diseases_to_add)

	AddElement(/datum/element/beauty, beauty)

	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_created", 1, name)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	if(bloodiness)
		update_appearance()

/obj/effect/decal/cleanable/Destroy()
	var/turf/T = get_turf(src)
	if(T && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_destroyed", 1, name)
	return ..()

/obj/effect/decal/cleanable/proc/replace_decal(obj/effect/decal/cleanable/C) // Returns true if we should give up in favor of the pre-existing decal
	if(mergeable_decal)
		return TRUE

/// Increments or decrements the bloodiness value
/obj/effect/decal/cleanable/proc/adjust_bloodiness(by_amount)
	if(by_amount == 0)
		return FALSE
	if(QDELING(src))
		return FALSE

	bloodiness = clamp((bloodiness + by_amount), 0, BLOOD_POOL_MAX)
	update_appearance()
	return TRUE

/// Called before attempting to scoop up reagents from this decal to only load reagents when necessary
/obj/effect/decal/cleanable/proc/lazy_init_reagents()
	return

#ifdef TESTING
/obj/effect/decal/cleanable/update_overlays()
	. = ..()
	if(bloodiness)
		var/mutable_appearance/blah_text = new()
		blah_text.maptext = MAPTEXT_TINY_UNICODE("[bloodiness]")
		blah_text.appearance_flags |= (KEEP_APART|RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM)
		. += blah_text
#endif

/obj/effect/decal/cleanable/attackby(obj/item/W, mob/user, params)
	if((istype(W, /obj/item/reagent_containers/cup) && !istype(W, /obj/item/reagent_containers/cup/rag)) || istype(W, /obj/item/reagent_containers/cup/glass))
		if(src.reagents && W.reagents)
			lazy_init_reagents()
			. = 1 //so the containers don't splash their content on the src while scooping.
			if(!src.reagents.total_volume)
				to_chat(user, span_notice("[src] isn't thick enough to scoop up!"))
				return
			if(W.reagents.total_volume >= W.reagents.maximum_volume)
				to_chat(user, span_notice("[W] is full!"))
				return
			to_chat(user, span_notice("You scoop up [src] into [W]!"))
			reagents.trans_to(W, reagents.total_volume, transferred_by = user)
			if(!reagents.total_volume) //scooped up all of it
				qdel(src)
				return
	if(W.get_temperature()) //todo: make heating a reagent holder proc
		if(istype(W, /obj/item/clothing/mask/cigarette))
			return
		else
			var/hotness = W.get_temperature()
			reagents.expose_temperature(hotness)
			to_chat(user, span_notice("You heat [name] with [W]!"))
	else
		return ..()

/obj/effect/decal/cleanable/fire_act(exposed_temperature, exposed_volume)
	if(reagents)
		reagents.expose_temperature(exposed_temperature)
	..()


//Add "bloodiness" of this blood's type, to the human's shoes
//This is on /cleanable because fuck this ancient mess
/obj/effect/decal/cleanable/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(isliving(AM) && bloodiness >= 40)
		SEND_SIGNAL(AM, COMSIG_STEP_ON_BLOOD, src)
		update_appearance()

/obj/effect/decal/cleanable/wash(clean_types)
	. = ..()
	if (. || (clean_types & clean_type))
		qdel(src)
		return TRUE
	return .

/**
 * Checks if this decal is a valid decal that can be blood crawled in.
 */
/obj/effect/decal/cleanable/proc/can_bloodcrawl_in()
	return decal_reagent == /datum/reagent/blood

/obj/effect/decal/cleanable/proc/handle_merge_decal(obj/effect/decal/cleanable/merger)
	if(!merger)
		return
	if(merger.reagents && reagents)
		reagents.trans_to(merger, reagents.total_volume)
