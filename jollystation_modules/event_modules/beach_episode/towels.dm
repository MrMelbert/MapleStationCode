// -- Towels. --
/// do_after key, related to towels
#define DOAFTER_SOURCE_TOWEL "doafter_towel"

// A Towel. Can be used to dry wet floors or people.
/obj/item/towel
	name = "towel"
	desc = "A nice, soft towel you can use to dry things off."
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_OCLOTHING | ITEM_SLOT_HEAD | ITEM_SLOT_ICLOTHING
	item_flags = NOBLUDGEON
	resistance_flags = FLAMMABLE
	max_integrity = 120
	throwforce = 0
	throw_speed = 2
	throw_range = 3
	layer = MOB_LAYER
	// TODO
	icon = 'icons/obj/bedsheets.dmi'
	lefthand_file = 'icons/mob/inhands/misc/bedsheet_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/bedsheet_righthand.dmi'
	icon_state = "sheetwhite"
	inhand_icon_state = "sheetwhite"
	/// Whether our tower is warm and comfy.
	var/warm_towel = FALSE
	/// The timer ID on our towel cooling.
	var/cooling_timer_id

/obj/item/towel/examine(mob/user)
	. = ..()
	if(warm_towel && user.is_holding(src))
		. += "<span class='notice'>It's noticeably warm.</span>"

/obj/item/towel/pre_attack(atom/target, mob/living/user, params)
	. = ..()

	if(isopenturf(target))
		try_dry_floor(target, user)
		return TRUE

	if(isliving(target))
		try_dry_mob(target, user)
		return TRUE

	return

/*
 * Check if our [target_turf] is valid to try to dry and begin a do_after.
 * If the turf is valid, try a do_after, and if successful, call [do_dry_floor].
 *
 * target_turf - the turf we're trying to dry
 * user - the mob drying the turf
 *
 * returns FALSE if the floor is invalid to dry, and TRUE otherwise.
 */
/obj/item/towel/proc/try_dry_floor(turf/open/target_turf, mob/living/user)
	if(DOING_INTERACTION(user, DOAFTER_SOURCE_TOWEL))
		return FALSE

	if(resistance_flags & ON_FIRE)
		return FALSE

	var/turf_wetness = SEND_SIGNAL(target_turf, COMSIG_TURF_IS_WET)
	if(!turf_wetness)
		return FALSE

	if(turf_wetness & (TURF_WET_SUPERLUBE | TURF_WET_PERMAFROST | TURF_WET_ICE))
		to_chat(user, "<span class='warning'>You'll need something stronger than [src] to dry this mess.</span>")
		return FALSE

	to_chat(user, "<span class='notice'>You begin drying off [target_turf] with [src]...</span>")
	visible_message("<span class='notice'>[user] begins drying off [target_turf] with [src]...</span>", ignored_mobs = list(user))
	if(!do_after(user, 2 SECONDS, target = target_turf, interaction_key = DOAFTER_SOURCE_TOWEL))
		to_chat(user, "<span class='warning'>You fail to sop up the mess on [target_turf].</span>")
		return FALSE

	do_dry_floor(target_turf, user)
	return TRUE

/*
 * Actually dry the floor, removing a minute of wetness from [target_turf] and washing it lightly.
 *
 * target_turf - the turf we're drying
 * user - the mob drying the turf
 *
 */
/obj/item/towel/proc/do_dry_floor(turf/open/target_turf, mob/living/user)
	to_chat(user, "<span class='notice'>You dry off [target_turf] with [src].</span>")
	visible_message("<span class='notice'>[user] dries off [target_turf] with [src].</span>", ignored_mobs = list(user))
	target_turf.MakeDry(ALL, TRUE, 1 MINUTES)
	target_turf.wash(CLEAN_WASH)

/*
 * Begin drying off a [target_mob] with [src].
 * If [target_mob] is on fire, call [try_extinguish_mob].
 * Otherwise, begin a do_after, and call [do_dry_mob] afterwards.
 *
 * target_mob - the mob we're trying to dry
 * user - the mob drying the target_mob
 *
 * returns FALSE if the mob is invalid to dry, and TRUE otherwise.
 */
/obj/item/towel/proc/try_dry_mob(mob/living/target_mob, mob/living/user)
	if(DOING_INTERACTION(user, DOAFTER_SOURCE_TOWEL))
		return FALSE

	if(resistance_flags & ON_FIRE)
		return FALSE

	if(target_mob.on_fire)
		if(target_mob == user)
			return FALSE
		else
			to_chat(user, "<span class='danger'>You try to extinguish the flames on [target_mob] with [src]!</span>")
			if(!do_after(user, 0.75 SECONDS, target = target_mob, interaction_key = DOAFTER_SOURCE_TOWEL))
				return FALSE

			try_extinguish_mob(target_mob, user)
			return TRUE
	else
		to_chat(user, "<span class='notice'>You begin drying off [target_mob == user ? "yourself" : "[target_mob]"] with [src]...</span>")
		visible_message("<span class='notice'>[user] begins drying off [target_mob == user ? "[user.p_them()]self" : "[target_mob]"] with [src]...</span>", ignored_mobs = list(user))
		if(!do_after(user, 2 SECONDS, target = target_mob, interaction_key = DOAFTER_SOURCE_TOWEL))
			return FALSE

		do_dry_mob(target_mob, user)
	return TRUE

/*
 * Actually dry the mob, giving them a moodlet if the towel is warm and washing them.
 * Also removes negative firestacks (wetness).
 *
 * target_mob - the mob we're drying
 * user - the mob drying the target_mob
 */
/obj/item/towel/proc/do_dry_mob(mob/living/target_mob, mob/living/user)
	to_chat(user, "<span class='notice'>You dry off [target_mob == user ? "yourself" : "[target_mob]"] with [src].</span>")
	visible_message("<span class='notice'>[user] dries off [target_mob == user ? "[user.p_them()]self" : "[target_mob]"] with [src].</span>", ignored_mobs = list(user))
	target_mob.wash(CLEAN_WASH)
	target_mob.set_fire_stacks(max(0, target_mob.fire_stacks))
	if(warm_towel)
		SEND_SIGNAL(target_mob, COMSIG_ADD_MOOD_EVENT, "warm_towel", /datum/mood_event/warm_towel)
		if(prob(66)) //66% chance to cool the towel after
			cool_towel()

/*
 * Has a chance to remove some firestacks from [target_mob], or set [src] on fire.
 *
 * target_mob - the mob we're extinguishing
 * user - the mob extinguishing the target_mob
 */
/obj/item/towel/proc/try_extinguish_mob(mob/living/target_mob, mob/living/user)
	var/success_chance = warm_towel ? 40 : 55
	if(prob(success_chance))
		target_mob.adjust_fire_stacks(round(rand(-1, -4))) // at best: about as good as stop, drop, & roll
		to_chat(user, "<span class='danger'>You pat out some of the flames on [target_mob] with [src]!</span>")
		visible_message("<span class='danger'>[user] pats out some of the flames on [target_mob] with [src]!</span>", ignored_mobs = list(user))
	else
		fire_act(target_mob.bodytemperature)
		to_chat(user, "<span class='warning'>[src] bursts into flames!</span>")
		visible_message("<span class='warning'>[src] bursts into flames!</span>", ignored_mobs = list(user))

/// Cool down the towel.
/obj/item/towel/proc/cool_towel()
	warm_towel = FALSE
	cooling_timer_id = null

// BEACH Towel. On right click, can be placed on the ground.
/obj/item/towel/beach
	name = "beach towel"
	desc = "A colorful beach towel you can use to dry yourself off or soak up some rays."

/obj/item/towel/beach/pre_attack_secondary(atom/target, mob/living/user, params)
	. = ..()

	if(isfloorturf(target))
		try_place_towel(target, user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	return

/*
 * Check if our [target_turf] is valid to place our towel on.
 * If the turf is valid, begin a do_after, and if the turf is valid still after the do_after call [do_place_towel].
 *
 * target_turf - the turf we're trying to place our towel on
 * user - the mob placing the towel
 *
 * returns FALSE if the towel cannot be placed, and TRUE otherwise
 */
/obj/item/towel/beach/proc/try_place_towel(turf/open/floor/target_turf, mob/living/user)
	if(DOING_INTERACTION(user, DOAFTER_SOURCE_TOWEL))
		return FALSE

	if(resistance_flags & ON_FIRE)
		return FALSE

	if(!check_towel_location(target_turf, user))
		return FALSE

	to_chat(user, "<span class='notice'>You begin placing [src] onto [target_turf]...</span>")
	visible_message("<span class='notice'>[user] begins placing [src] onto [target_turf]...</span>", ignored_mobs = list(user))
	if(!do_after(user, 3 SECONDS, target = target_turf, interaction_key = DOAFTER_SOURCE_TOWEL))
		return FALSE

	if(!check_towel_location(target_turf, user))
		return FALSE

	do_place_towel(target_turf, user)
	return TRUE

/*
 * Check if our [target_turf] contains invalid atmos.
 *
 * target_turf - the turf we're checking
 * user - the mob who initiated the check
 *
 * returns FALSE if our turf contains invalid atoms, TRUE otherwise.
 */
/obj/item/towel/beach/proc/check_towel_location(turf/open/floor/target_turf, mob/living/user)
	for(var/atom/blocker in target_turf)
		if(isliving(blocker))
			if(blocker == user)
				to_chat(user, "<span class='warning'>You can't lay [src] out on [target_turf] while you're standing there.</span>")
			else
				to_chat(user, "<span class='warning'>You can't place [src] on [target_turf] while [blocker] is in the way.</span>")
			return FALSE

		if(blocker.density)
			to_chat(user, "<span class='warning'>You can't place [src] on [target_turf], something is in the way.</span>")
			return FALSE

	return TRUE

/*
 * Actually place our towel on [target_turf].
 *
 * target_turf - the turf we're putting the towel
 * user - the mob who placed the towel
 */
/obj/item/towel/beach/proc/do_place_towel(turf/open/floor/target_turf, mob/living/user)
	to_chat(user, "<span class='notice'>You spread out [src] across [target_turf].</span>")
	visible_message("<span class='notice'>[user] places [src] onto [target_turf].</span>", ignored_mobs = list(user))
	new /obj/structure/beach_towel(target_turf, src)

/// Structure that represents the Beach towel item placed down.
/obj/structure/beach_towel
	name = "beach towel"
	desc = "A beach towel spread out over the floor, for maximum comfort and mimimum sand contact while soaking up the rays."
	density = FALSE
	anchored = TRUE
	// TODO
	icon = 'icons/obj/fluff.dmi'
	icon_state = "railing"
	/// The beach towel we came from
	var/obj/item/towel/beach/our_towel = null

/obj/structure/beach_towel/Initialize(mapload, obj/item/towel/beach/new_towel)
	. = ..()
	if(!our_towel)
		if(mapload || !new_towel)
			our_towel = new(src)
		else
			our_towel = new_towel
			new_towel.forceMove(src)
	name = our_towel.name

/obj/structure/beach_towel/Destroy()
	if(our_towel)
		our_towel.forceMove(drop_location())
		our_towel = null
	return ..()

/// On click-drag, try to pick up the towel.
/obj/structure/beach_towel/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	. = ..()
	var/mob/living/carbon/picker_up = usr

	if(!istype(picker_up))
		return

	if(over != picker_up)
		return

	try_pick_up(picker_up)
/*
 * Attempt to pick up the towel. Run through a few checks and a do-after, then call [do_pick_up]
 *
 * picker_up - the mob who is trying to pick up the towel.
 *
 * return FALSE if we cannot pick up the towel and TRUE otherwise
 */
/obj/structure/beach_towel/proc/try_pick_up(mob/living/carbon/picker_up)
	if(!picker_up.canUseTopic(src, BE_CLOSE, FALSE, NO_TK, TRUE, FALSE))
		return FALSE

	var/turf/our_turf = get_turf(src)
	if(locate(/mob/living) in our_turf)
		to_chat(picker_up, "<span class='warning'>There's something on [src]!</span>")
		return FALSE

	if(DOING_INTERACTION_WITH_TARGET(picker_up, src))
		return FALSE

	to_chat(picker_up, "<span class='notice'>You begin folding up [src]...</span>")
	visible_message("<span class='notice'>[picker_up] begins folding up [src]...</span>", ignored_mobs = list(picker_up))
	if(!do_after(picker_up, 4 SECONDS, target = src))
		return FALSE

	do_pick_up(picker_up)
	return TRUE

/*
 * Actually pick up the towel, moving the item to [picker_up], and deleting [src].
 * If any mobs walk onto the towel while being picked up, give them a slip.
 *
 * picker_up - the mob who is picking up the towel.
 */
/obj/structure/beach_towel/proc/do_pick_up(mob/living/carbon/picker_up)
	var/turf/our_turf = get_turf(src)
	var/mob/living/slipped_up_mob = locate(/mob/living) in our_turf

	if(slipped_up_mob) // If someone steps on our towel right after we start picking it up, knock 'em over
		slipped_up_mob.Knockdown(15)
		to_chat(slipped_up_mob, "<span class='danger'>[src] gets pulled up right as you step on it, knocking you over!</span>")
		visible_message("<span class='danger'>[src] is pulled out from right under [slipped_up_mob], knocking them over!</span>", ignored_mobs = list(slipped_up_mob))

	if(picker_up.put_in_hands(our_towel))
		to_chat(picker_up, "<span class='notice'>You fold up [src] off [our_turf].</span>")
		visible_message("<span class='notice'>[picker_up] fold up [src] off [our_turf].</span>", ignored_mobs = list(picker_up))
	else
		our_towel.forceMove(drop_location())
		to_chat(picker_up, "<span class='notice'>You go to fold up [src] from [our_turf], but your hands are full, leaving it considerably less kempt that it was before.</span>")
		visible_message("<span class='notice'>[picker_up] tries to fold up [src] from [our_turf], but ends up leaving it considerably less kempt that it was before.</span>", ignored_mobs = list(picker_up))

	our_towel = null
	qdel(src)

/// A rack to store towels.
/obj/structure/towel_rack
	name = "towel rack"
	desc = "Warm towels after a nice shower."
	anchored = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 150
	// TODO
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
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
		to_chat(user, "<span class='warning'>[src] is full!</span>")
		return FALSE

	if(!user.transferItemToLoc(added_towel, src))
		to_chat(user, "<span class='warning'>You can't seem to place [added_towel] in [src]!</span>")
		return FALSE

	to_chat(user, "<span class='notice'>You add [added_towel] to [src].</span>")
	towels += added_towel
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
			to_chat(user, "<span class='notice'>You remove [removed_towel] from [src].</span>")
		else
			to_chat(user, "<span class='notice'>You remove [removed_towel] from [src], dumping it onto the floor.</span>")
	else
		to_chat(user, "<span class='notice'>You remove [removed_towel] from [src], dumping it onto the floor.</span>")
		removed_towel.forceMove(drop_location())

	towels -= removed_towel
	return removed_towel

/// Preset filled towel rack.
/obj/structure/towel_rack/full

/obj/structure/towel_rack/full/Initialize()
	. = ..()
	for(var/towel_num in 1 to max_towels)
		towels += new /obj/item/towel(src)

/// A towel rack that automagically warms the towels inside after a short time.
/// Should probably be a machine and used power, but I can't really care (it's solar powered)
/obj/structure/towel_rack/warmer
	name = "towel warmer rack"
	desc = "Not only does this rack store your towels, but it warms them, too! And it doesn't even require power."

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
	visible_message("<span class='notice'>[src] dings as it finished heating [warmed_towel].")
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

/// Preset filled tower warming rack (all the towels are warm, too)
/obj/structure/towel_rack/warmer/full

/obj/structure/towel_rack/warmer/full/Initialize()
	. = ..()
	for(var/towel_num in 1 to max_towels)
		var/obj/item/towel/added_towel = new(src)
		added_towel.warm_towel = TRUE
		towels += added_towel

/datum/mood_event/warm_towel
	description = "<span class='nicegreen'>Warm towels are cosy.</span>\n"
	mood_change = 4
	timeout = 3 MINUTES

#undef DOAFTER_SOURCE_TOWEL
