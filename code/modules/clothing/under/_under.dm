/obj/item/clothing/under
	name = "under"
	icon = 'icons/obj/clothing/under/default.dmi'
	worn_icon = 'icons/mob/clothing/under/default.dmi'
	lefthand_file = 'icons/mob/inhands/clothing/suits_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/suits_righthand.dmi'
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	slot_flags = ITEM_SLOT_ICLOTHING
	armor_type = /datum/armor/clothing_under
	equip_sound = 'sound/items/equip/jumpsuit_equip.ogg'
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound = 'sound/items/handling/cloth_pickup.ogg'
	limb_integrity = 30
	supports_variations_flags = CLOTHING_DIGITIGRADE_FILTER
	blood_overlay_type = "uniform" // NON-MODULE CHANGE reworking clothing blood overlays

	/// Has this undersuit been freshly laundered and, as such, imparts a mood bonus for wearing
	var/freshly_laundered = FALSE

	// Alt style handling
	/// Can this suit be adjustd up or down to an alt style
	var/can_adjust = TRUE
	/// If adjusted what style are we currently using?
	var/adjusted = NORMAL_STYLE
	/// For adjusted/rolled-down jumpsuits. FALSE = exposes chest and arms, TRUE = exposes arms only
	var/alt_covers_chest = FALSE
	/// The variable containing the flags for how the woman uniform cropping is supposed to interact with the sprite.
	var/female_sprite_flags = FEMALE_UNIFORM_FULL

	// Sensor handling
	/// Does this undersuit have suit sensors in general
	var/has_sensor = HAS_SENSORS
	/// Does this undersuit spawn with a random sensor value
	var/random_sensor = TRUE
	/// What is the active sensor mode of this udnersuit
	var/sensor_mode = NO_SENSORS

	// Accessory handling (Can be componentized eventually)
	/// The max number of accessories we can have on this suit.
	var/max_number_of_accessories = 5
	/// A list of all accessories attached to us.
	var/list/obj/item/clothing/accessory/attached_accessories
	/// The overlay of the accessory we're demonstrating. Only index 1 will show up.
	/// This is the overlay on the MOB, not the item itself.
	var/mutable_appearance/accessory_overlay

/datum/armor/clothing_under
	bio = 10
	wound = 5

/obj/item/clothing/under/Initialize(mapload)
	. = ..()
	if(random_sensor)
		//make the sensor mode favor higher levels, except coords.
		sensor_mode = pick(SENSOR_VITALS, SENSOR_VITALS, SENSOR_VITALS, SENSOR_LIVING, SENSOR_LIVING, SENSOR_COORDS, SENSOR_COORDS, SENSOR_OFF)
	register_context()
	AddElement(/datum/element/update_icon_updates_onmob, flags = ITEM_SLOT_ICLOTHING|ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK, body = TRUE)

/obj/item/clothing/under/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = NONE

	if(isnull(held_item) && has_sensor == HAS_SENSORS)
		context[SCREENTIP_CONTEXT_RMB] = "Toggle suit sensors"
		. = CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/clothing/accessory) && length(attached_accessories) < max_number_of_accessories)
		context[SCREENTIP_CONTEXT_LMB] = "Attach accessory"
		. = CONTEXTUAL_SCREENTIP_SET

	if(LAZYLEN(attached_accessories))
		context[SCREENTIP_CONTEXT_ALT_RMB] = "Remove accessory"
		. = CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/stack/cable_coil) && has_sensor == BROKEN_SENSORS)
		context[SCREENTIP_CONTEXT_LMB] = "Repair suit sensors"
		. = CONTEXTUAL_SCREENTIP_SET

	if(can_adjust && adjusted != DIGITIGRADE_STYLE)
		context[SCREENTIP_CONTEXT_ALT_LMB] =  "Wear [adjusted == ALT_STYLE ? "normally" : "casually"]"
		. = CONTEXTUAL_SCREENTIP_SET

	return .

/obj/item/clothing/under/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damageduniform")
		// NON-MODULE CHANGE reworking clothing blood overlays
	if(accessory_overlay)
		. += accessory_overlay

/obj/item/clothing/under/attackby(obj/item/attacking_item, mob/user, params)
	if(has_sensor == BROKEN_SENSORS && istype(attacking_item, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/cabling = attacking_item
		to_chat(user, span_notice("You repair the suit sensors on [src] with [cabling]."))
		cabling.use(1)
		has_sensor = HAS_SENSORS
		return TRUE

	if(istype(attacking_item, /obj/item/clothing/accessory))
		return attach_accessory(attacking_item, user)

	return ..()

/obj/item/clothing/under/attack_hand_secondary(mob/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	toggle()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/under/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	. = ..()
	if(damaged_state == CLOTHING_SHREDDED && has_sensor > NO_SENSORS)
		has_sensor = BROKEN_SENSORS
	else if(damaged_state == CLOTHING_PRISTINE && has_sensor == BROKEN_SENSORS)
		has_sensor = HAS_SENSORS
	update_appearance()

/obj/item/clothing/under/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(has_sensor == NO_SENSORS || has_sensor == BROKEN_SENSORS)
		return

	if(severity <= EMP_HEAVY)
		has_sensor = BROKEN_SENSORS
		if(ismob(loc))
			var/mob/M = loc
			to_chat(M,span_warning("[src]'s sensors short out!"))

	else
		sensor_mode = pick(SENSOR_OFF, SENSOR_OFF, SENSOR_OFF, SENSOR_LIVING, SENSOR_LIVING, SENSOR_VITALS, SENSOR_VITALS, SENSOR_COORDS)
		if(ismob(loc))
			var/mob/M = loc
			to_chat(M,span_warning("The sensors on the [src] change rapidly!"))

	if(ishuman(loc))
		var/mob/living/carbon/human/ooman = loc
		if(ooman.w_uniform == src)
			ooman.update_suit_sensors()

/obj/item/clothing/under/visual_equipped(mob/user, slot)
	. = ..()
	if(adjusted == ALT_STYLE)
		adjust_to_normal()

	if((supports_variations_flags & CLOTHING_DIGITIGRADE_VARIATION) && ishuman(user))
		var/mob/living/carbon/human/wearer = user
		if(wearer.bodytype & BODYTYPE_DIGITIGRADE)
			adjusted = DIGITIGRADE_STYLE
			update_appearance()

/obj/item/clothing/under/equipped(mob/living/user, slot)
	..()
	if((slot & ITEM_SLOT_ICLOTHING) && freshly_laundered)
		freshly_laundered = FALSE
		user.add_mood_event("fresh_laundry", /datum/mood_event/fresh_laundry)

/mob/living/carbon/human/update_suit_sensors()
	. = ..()
	update_sensor_list()

/mob/living/carbon/human/proc/update_sensor_list()
	var/obj/item/clothing/under/U = w_uniform
	if(istype(U) && U.has_sensor > NO_SENSORS && U.sensor_mode)
		GLOB.suit_sensors_list |= src
	else
		GLOB.suit_sensors_list -= src

/mob/living/carbon/human/dummy/update_sensor_list()
	return

// End suit sensor handling

/// Attach the passed accessory to the clothing item
/obj/item/clothing/under/proc/attach_accessory(obj/item/clothing/accessory/accessory, mob/living/user, attach_message = TRUE)
	if(!istype(accessory))
		return
	if(!accessory.can_attach_accessory(src, user))
		return
	if(user && !user.temporarilyRemoveItemFromInventory(accessory))
		return
	if(!accessory.attach(src, user))
		return

	LAZYADD(attached_accessories, accessory)
	accessory.forceMove(src)
	// Allow for accessories to react to the acccessory list now
	accessory.successful_attach(src)

	if(user && attach_message)
		balloon_alert(user, "accessory attached")

	if(isnull(accessory_overlay))
		create_accessory_overlay()

	update_appearance()
	return TRUE

/// Removes (pops) the topmost accessory from the accessories list and puts it in the user's hands if supplied
/obj/item/clothing/under/proc/pop_accessory(mob/living/user, attach_message = TRUE)
	var/obj/item/clothing/accessory/popped_accessory = attached_accessories[1]
	remove_accessory(popped_accessory)

	if(!user)
		return

	user.put_in_hands(popped_accessory)
	if(attach_message)
		popped_accessory.balloon_alert(user, "accessory removed")

/// Removes the passed accesory from our accessories list
/obj/item/clothing/under/proc/remove_accessory(obj/item/clothing/accessory/removed)
	if(removed == attached_accessories[1])
		accessory_overlay = null

	// Remove it from the list before detaching
	LAZYREMOVE(attached_accessories, removed)
	removed.detach(src)

	if(isnull(accessory_overlay) && LAZYLEN(attached_accessories))
		create_accessory_overlay()

	update_appearance()

/// Handles creating the worn overlay mutable appearance
/// Only the first accessory attached is displayed (currently)
/obj/item/clothing/under/proc/create_accessory_overlay()
	var/obj/item/clothing/accessory/prime_accessory = attached_accessories[1]
	accessory_overlay = mutable_appearance(prime_accessory.worn_icon, prime_accessory.icon_state)
	accessory_overlay.alpha = prime_accessory.alpha
	accessory_overlay.color = prime_accessory.color

/// Updates the accessory's worn overlay mutable appearance
/obj/item/clothing/under/proc/update_accessory_overlay()
	if(isnull(accessory_overlay))
		return

	cut_overlay(accessory_overlay)
	create_accessory_overlay()
	update_appearance() // so we update the suit inventory overlay too

/obj/item/clothing/under/Exited(atom/movable/gone, direction)
	. = ..()
	// If one of our accessories was moved out, handle it
	if(gone in attached_accessories)
		remove_accessory(gone)

/// Helper to remove all attachments to the passed location
/obj/item/clothing/under/proc/dump_attachments(atom/drop_to = drop_location())
	for(var/obj/item/clothing/accessory/worn_accessory as anything in attached_accessories)
		remove_accessory(worn_accessory)
		worn_accessory.forceMove(drop_to)

/obj/item/clothing/under/atom_destruction(damage_flag)
	dump_attachments()
	return ..()

/obj/item/clothing/under/Destroy()
	QDEL_LAZYLIST(attached_accessories)
	return ..()

/obj/item/clothing/under/examine(mob/user)
	. = ..()
	if(can_adjust)
		. += "&bull; Alt-click on [src] to wear it [adjusted == ALT_STYLE ? "normally" : "casually"]."
	if(has_sensor == BROKEN_SENSORS)
		. += "&bull; Its sensors appear to be shorted out. You could repair it with some cabling."
	else if(has_sensor > NO_SENSORS)
		switch(sensor_mode)
			if(SENSOR_OFF)
				. += "&bull; Its sensors appear to be disabled."
			if(SENSOR_LIVING)
				. += "&bull; Its binary life sensors appear to be enabled."
			if(SENSOR_VITALS)
				. += "&bull; Its vital tracker appears to be enabled."
			if(SENSOR_COORDS)
				. += "&bull; Its vital tracker and tracking beacon appear to be enabled."
	if(LAZYLEN(attached_accessories))
		var/list/accessories = list_accessories_with_icon(user)
		. += "&bull; It has [english_list(accessories)] attached."
		. += "Alt-Right-Click to remove [attached_accessories[1]]."

/// Helper to list out all accessories with an icon besides it, for use in examine
/obj/item/clothing/under/proc/list_accessories_with_icon(mob/user)
	var/list/all_accessories = list()
	for(var/obj/item/clothing/accessory/attached as anything in attached_accessories)
		all_accessories += attached.get_examine_string(user)

	return all_accessories

/obj/item/clothing/under/verb/toggle()
	set name = "Adjust Suit Sensors"
	set category = "Object"
	set src in usr
	var/mob/user_mob = usr
	if(!can_toggle_sensors(user_mob))
		return

	var/list/modes = list("Off", "Binary vitals", "Exact vitals", "Tracking beacon")
	var/switchMode = tgui_input_list(user_mob, "Select a sensor mode", "Suit Sensors", modes, modes[sensor_mode + 1])
	if(isnull(switchMode))
		return
	if(!can_toggle_sensors(user_mob))
		return

	sensor_mode = modes.Find(switchMode) - 1
	if (loc == user_mob)
		switch(sensor_mode)
			if(SENSOR_OFF)
				to_chat(user_mob, span_notice("You disable your suit's remote sensing equipment."))
			if(SENSOR_LIVING)
				to_chat(user_mob, span_notice("Your suit will now only report whether you are alive or dead."))
			if(SENSOR_VITALS)
				to_chat(user_mob, span_notice("Your suit will now only report your exact vital lifesigns."))
			if(SENSOR_COORDS)
				to_chat(user_mob, span_notice("Your suit will now report your exact vital lifesigns as well as your coordinate position."))

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.w_uniform == src)
			H.update_suit_sensors()

/// Checks if the toggler is allowed to toggle suit sensors currently
/obj/item/clothing/under/proc/can_toggle_sensors(mob/toggler)
	if(!can_use(toggler) || toggler.stat == DEAD) //make sure they didn't hold the window open.
		return FALSE
	if(get_dist(toggler, src) > 1)
		balloon_alert(toggler, "too far!")
		return FALSE

	switch(has_sensor)
		if(LOCKED_SENSORS)
			balloon_alert(toggler, "sensor controls locked!")
			return FALSE
		if(BROKEN_SENSORS)
			balloon_alert(toggler, "sensors shorted!")
			return FALSE
		if(NO_SENSORS)
			balloon_alert(toggler, "no sensors to ajdust!")
			return FALSE

	return TRUE

/obj/item/clothing/under/AltClick(mob/user)
	. = ..()
	if(.)
		return

	if(!can_adjust)
		balloon_alert(user, "can't be adjusted!")
		return
	if(!can_use(user))
		return
	rolldown()

/obj/item/clothing/under/alt_click_secondary(mob/user)
	. = ..()
	if(.)
		return

	if(!LAZYLEN(attached_accessories))
		balloon_alert(user, "no accessories to remove!")
		return
	if(!user.can_perform_action(src, NEED_DEXTERITY))
		return

	pop_accessory(user)

/obj/item/clothing/under/verb/jumpsuit_adjust()
	set name = "Adjust Jumpsuit Style"
	set category = null
	set src in usr

	if(!can_adjust)
		balloon_alert(usr, "can't be adjusted!")
		return
	if(!can_use(usr))
		return
	rolldown()

/obj/item/clothing/under/proc/rolldown()
	if(toggle_jumpsuit_adjust())
		to_chat(usr, span_notice("You adjust the suit to wear it more casually."))
	else
		to_chat(usr, span_notice("You adjust the suit back to normal."))

	update_appearance()

/// Helper to toggle the jumpsuit style, if possible
/// Returns the new state
/obj/item/clothing/under/proc/toggle_jumpsuit_adjust()
	switch(adjusted)
		if(DIGITIGRADE_STYLE)
			return

		if(NORMAL_STYLE)
			adjust_to_alt()

		if(ALT_STYLE)
			adjust_to_normal()

	SEND_SIGNAL(src, COMSIG_CLOTHING_UNDER_ADJUSTED)
	return adjusted

/// Helper to reset to normal jumpsuit state
/obj/item/clothing/under/proc/adjust_to_normal()
	adjusted = NORMAL_STYLE
	female_sprite_flags = initial(female_sprite_flags)
	if(!alt_covers_chest)
		body_parts_covered |= CHEST
		body_parts_covered |= ARMS
	if(LAZYLEN(damage_by_parts))
		// ugly check to make sure we don't reenable protection on a disabled part
		for(var/zone in list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
			if(damage_by_parts[zone] > limb_integrity)
				body_parts_covered &= body_zone2cover_flags(zone)

/// Helper to adjust to alt jumpsuit state
/obj/item/clothing/under/proc/adjust_to_alt()
	adjusted = ALT_STYLE
	if(!(female_sprite_flags & FEMALE_UNIFORM_TOP_ONLY))
		female_sprite_flags = NO_FEMALE_UNIFORM
	if(!alt_covers_chest) // for the special snowflake suits that expose the chest when adjusted (and also the arms, realistically)
		body_parts_covered &= ~CHEST
		body_parts_covered &= ~ARMS

/obj/item/clothing/under/can_use(mob/user)
	if(ismob(user) && !user.can_perform_action(src, NEED_DEXTERITY|NEED_HANDS|ALLOW_RESTING))
		return FALSE
	return ..()

/obj/item/clothing/under/rank
	dying_key = DYE_REGISTRY_UNDER

/obj/item/clothing/under
	/// The "pockets" attached to this uniform
	var/obj/effect/abstract/abstract_storage/uniform_pockets/pockets

/obj/item/clothing/under/Destroy()
	QDEL_NULL(pockets)
	return ..()

/obj/item/clothing/under/examine(mob/user)
	. = ..()
	if(!pockets)
		return
	if(pockets.id)
		. += span_notice("&bull; It's got [pockets.id] attached to [p_they()].")
	if(pockets.l_pocket && pockets.r_pocket)
		. += span_notice("&bull; You can see something in both of [p_their()] pockets.")
	else if(pockets.l_pocket)
		. += span_notice("&bull; You can see something in [p_their()] left pocket.")
	else if(pockets.r_pocket)
		. += span_notice("&bull; You can see something in [p_their()] right pocket.")

/obj/item/clothing/under/equipped(mob/living/user, slot)
	. = ..()
	if(!pockets)
		return
	if(!(slot & slot_flags))
		return

	user.equip_to_slot_if_possible(pockets.l_pocket, ITEM_SLOT_LPOCKET, disable_warning = TRUE)
	user.equip_to_slot_if_possible(pockets.r_pocket, ITEM_SLOT_RPOCKET, disable_warning = TRUE)
	user.equip_to_slot_if_possible(pockets.id, ITEM_SLOT_ID, disable_warning = TRUE)
	dump_pockets(user.drop_location())

/obj/item/clothing/under/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(.)
		return
	dump_pockets()

/obj/item/clothing/under/atom_destruction(damage_flag)
	dump_pockets()
	return ..()

/obj/item/clothing/under/proc/dump_pockets(atom/drop_loc = drop_location())
	pockets?.atom_storage.remove_all(drop_loc)

/obj/item/clothing/under/proc/take_pockets(mob/living/carbon/human/from_who)
	if(pockets)
		stack_trace("uniform take_pockets called with pockets already present!")
		dump_pockets(from_who.drop_location())

	pockets = new(src)
	RegisterSignal(pockets, COMSIG_QDELETING, PROC_REF(pockets_del))

	var/obj/item/who_id = from_who.wear_id
	if(who_id && pockets.atom_storage.can_insert(who_id) && from_who.temporarilyRemoveItemFromInventory(who_id))
		pockets.id = who_id
		who_id.forceMove(pockets)

	var/obj/item/who_l_pocket = from_who.l_store
	if(who_l_pocket && pockets.atom_storage.can_insert(who_l_pocket) && from_who.temporarilyRemoveItemFromInventory(who_l_pocket))
		pockets.l_pocket = who_l_pocket
		who_l_pocket.forceMove(pockets)

	var/obj/item/who_r_pocket = from_who.r_store
	if(who_r_pocket && pockets.atom_storage.can_insert(who_r_pocket) && from_who.temporarilyRemoveItemFromInventory(who_r_pocket))
		pockets.r_pocket = who_r_pocket
		who_r_pocket.forceMove(pockets)

	if(!length(pockets.contents))
		QDEL_NULL(pockets)

/obj/item/clothing/under/proc/pockets_del(...)
	SIGNAL_HANDLER
	pockets = null

/// Abstract object intended for holding storage datums for an atom which might get
/// another storage datum from another source, or might have have contents of its own
/obj/effect/abstract/abstract_storage
	density = FALSE
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	// hack to get around the fact that we fail canreach if our loc doesn't have a storage of itself
	// probably fine if we just rename this flag to be more accurate (CAN_ALWAYS_REACH_1 or something)
	flags_1 = IS_ONTOP_1

/obj/effect/abstract/abstract_storage/Initialize(mapload)
	. = ..()
	create_storage()

// Used for uniforms (to circumvent accessories)
/obj/effect/abstract/abstract_storage/uniform_pockets
	name = "pockets"
	/// What was in our left pocket?
	var/obj/item/l_pocket
	/// What was in our right pocket?
	var/obj/item/r_pocket
	/// What was in our ID slot?
	var/obj/item/id

/obj/effect/abstract/abstract_storage/uniform_pockets/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = POCKET_WEIGHT_CLASS
	atom_storage.max_slots = 3
	atom_storage.max_total_storage = atom_storage.max_specific_storage * atom_storage.max_slots
	if(!loc)
		return

	name = "[loc.name]'s pockets"
	atom_storage.RegisterSignal(loc, COMSIG_MOUSEDROP_ONTO, TYPE_PROC_REF(/datum/storage, on_mousedrop_onto))
	atom_storage.RegisterSignals(loc, list(COMSIG_CLICK_ALT, COMSIG_ATOM_ATTACK_GHOST, COMSIG_ATOM_ATTACK_HAND_SECONDARY), TYPE_PROC_REF(/datum/storage, open_storage_on_signal))

/obj/effect/abstract/abstract_storage/uniform_pockets/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == id)
		id = null
	if(gone == l_pocket)
		l_pocket = null
	if(gone == r_pocket)
		r_pocket = null
	if(!length(contents))
		qdel(src)
