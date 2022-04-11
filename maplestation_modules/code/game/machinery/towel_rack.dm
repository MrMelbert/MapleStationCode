/// Towel Racks

/// A rack to store towels.
/obj/structure/towel_rack
	name = "towel rack"
	desc = "Warm towels after a nice shower."
	anchored = TRUE
	density = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 150
	// TODO
	icon = 'maplestation_modules/icons/obj/machines/towel_rack.dmi'
	icon_state = "towel_rack"
	/// Max amount of towels we can hold.
	var/max_towels = 6
	/// All of the towels we're holding. Last in first out
	var/list/towels = list()

/obj/structure/towel_rack/Destroy()
	for(var/obj/item/towel/dropped_towel as anything in towels)
		dropped_towel.forceMove(drop_location())
		towels -= dropped_towel

	return ..()

/obj/structure/towel_rack/attackby(obj/item/attacked_item, mob/living/user, params)
	. = ..()

	if(istype(attacked_item, /obj/item/towel))
		add_towel(attacked_item, user)
		return TRUE

	return

/obj/structure/towel_rack/attack_hand(mob/living/user, list/modifiers)
	. = ..()

	if(towels.len)
		remove_towel(user)
		return TRUE

	return

/obj/structure/towel_rack/update_overlays()
	. = ..()
	switch(towels.len)
		if(1 to 3)
			. += "towel_rack_filled_half"
		if(4 to 6)
			. += "towel_rack_filled_full"

/*
 * Add [added_towel] into the rack, if we can.
 *
 * added_towel - the towel we're adding to the rack
 * user - the mob who is inserting the towel
 *
 * return FALSE if we fail to insert the towel, and TRUE otherwise
 */
/obj/structure/towel_rack/proc/add_towel(obj/item/towel/added_towel, mob/living/user)
	if(towels.len >= max_towels)
		to_chat(user, span_warning("[src] is full!"))
		return FALSE

	if(!user.transferItemToLoc(added_towel, src))
		to_chat(user, span_warning("You can't seem to place [added_towel] in [src]!"))
		return FALSE

	to_chat(user, span_notice("You add [added_towel] to [src]."))
	towels += added_towel
	update_appearance()
	return TRUE

/*
 * Remove the last towel from the rack. Last in, first out.
 *
 * user - the mob who is removing the towel
 *
 * returns the towel removed.
 */
/obj/structure/towel_rack/proc/remove_towel(mob/living/user)
	var/obj/item/removed_towel = towels[towels.len]
	if(iscarbon(user))
		var/mob/living/carbon/carbon_user = user
		if(carbon_user.put_in_hands(removed_towel))
			to_chat(user, span_notice("You remove [removed_towel] from [src]."))
		else
			to_chat(user, span_notice("You remove [removed_towel] from [src], dumping it onto the floor."))
	else
		to_chat(user, span_notice("You remove [removed_towel] from [src], dumping it onto the floor."))
		removed_towel.forceMove(drop_location())

	towels -= removed_towel
	update_appearance()
	return removed_towel

/// Preset full towel rack
/obj/structure/towel_rack/full/Initialize()
	. = ..()
	for(var/towel_num in 1 to max_towels)
		towels += new /obj/item/towel(src)
	update_appearance()

/// Preset full beach towel rack
/obj/structure/towel_rack/full_beach/Initialize()
	. = ..()
	for(var/towel_num in 1 to max_towels)
		towels += new /obj/item/towel/beach(src)
	update_appearance()


/// A towel rack that automagically warms the towels inside after a short time.
/// Should probably be a machine and used power, but I can't really care (it's solar powered)
/obj/structure/towel_rack/warmer
	name = "towel warmer rack"
	desc = "Not only does this rack store your towels, but it warms them, too! And it doesn't even require power."
	icon_state = "towel_rack_warmer"

/obj/structure/towel_rack/warmer/update_overlays()
	. = ..()
	if(towels.len)
		. += "towel_rack_heat"

/// Warm up towels after we add them.
/obj/structure/towel_rack/warmer/add_towel(obj/item/towel/added_towel, mob/living/user)
	. = ..()
	if(!.)
		return FALSE

	if(added_towel.cooling_timer_id)
		deltimer(added_towel.cooling_timer_id)
		added_towel.cooling_timer_id = null
	if(!added_towel.warm_towel)
		addtimer(CALLBACK(src, .proc/heat_towel, added_towel), 30 SECONDS)

/*
 * Heat [warmed_towel] (set its warm_towel var to TRUE), called after a timer.
 *
 * warmed_towel - the towel we're warming up
 *
 * returns FALSE if we can't warm anything, TRUE otherwise
 */
/obj/structure/towel_rack/warmer/proc/heat_towel(obj/item/towel/warmed_towel)
	if(!(warmed_towel in towels))
		return FALSE

	warmed_towel.warm_towel = TRUE
	visible_message(span_notice("[src] dings as it finished heating [warmed_towel]."))
	playsound(src, 'sound/machines/ding.ogg', 40)
	return TRUE

/// After we remove towels, cool them off after a time period.
/obj/structure/towel_rack/warmer/remove_towel(mob/living/user)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/towel/removed_towel = .
	if(removed_towel.warm_towel)
		removed_towel.cooling_timer_id = addtimer(CALLBACK(removed_towel, /obj/item/towel.proc/cool_towel), 3 MINUTES, TIMER_STOPPABLE)

/// Preset filled towel warming rack (all the towels are warm, too)
/obj/structure/towel_rack/warmer/full/Initialize()
	. = ..()
	for(var/towel_num in 1 to max_towels)
		var/obj/item/towel/added_towel = new(src)
		added_towel.warm_towel = TRUE
		towels += added_towel
	update_appearance()

/// Above but with beach towels.
/obj/structure/towel_rack/warmer/full_beach/Initialize()
	. = ..()
	for(var/towel_num in 1 to max_towels)
		var/obj/item/towel/beach/added_towel = new(src)
		added_towel.warm_towel = TRUE
		towels += added_towel
	update_appearance()
