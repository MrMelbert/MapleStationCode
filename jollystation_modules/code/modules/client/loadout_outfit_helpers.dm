/// -- Outfit and mob helpers to equip our loadout items. --

/// An empty outfit we fill in with our loadout items to dress our dummy.
/datum/outfit/player_loadout
	name = "Player Loadout"

/* Actually equip our mob with our job outfit and our loadout items.
 * Loadout items override the pre-existing item in the corresponding slot of the job outfit.
 * Some job items are preserved after being overridden - belt items, ear items, and glasses.
 * The rest of the slots, the items are overridden completely and deleted.
 *
 * Plasmamen are snowflaked to not have any envirosuit pieces removed just in case.
 * Their loadout items for those slots will be added to their backpack on spawn.
 *
 * outfit - the job outfit we're equipping
 * visuals_only - whether we call special equipped procs, or if we just look like we equipped it
 * preference_source - the client belonging to the thing we're equipping
 */
/mob/living/carbon/human/proc/equip_outfit_and_loadout(datum/outfit/outfit, visuals_only = FALSE, datum/preferences/preference_source)
	var/datum/outfit/equipped_outfit

	if(ispath(outfit))
		equipped_outfit = new outfit()
	else if(istype(outfit))
		equipped_outfit = outfit
	else
		CRASH("Outfit passed to equip_outfit_and_loadout was neither a path nor an instantiated type!")

	var/list/loadout = preference_source?.loadout_list
	for(var/slot in loadout)
		var/move_to_backpack = null
		if(isnull(loadout[slot]))
			stack_trace("null value found while equipping loadout list! User: [src], Slot: [slot], [preference_source ? "Key: [preference_source.parent]" : "No key associated."]")
			continue
		switch(slot)
			/// Key slots - Replaced, item moved to backpack
			if(LOADOUT_ITEM_BELT)
				if(equipped_outfit.belt)
					move_to_backpack = equipped_outfit.belt
				equipped_outfit.belt = loadout[slot]
			if(LOADOUT_ITEM_EARS)
				if(equipped_outfit.ears)
					move_to_backpack = equipped_outfit.ears
				equipped_outfit.ears = loadout[slot]
			if(LOADOUT_ITEM_GLASSES)
				if(equipped_outfit.glasses)
					move_to_backpack = equipped_outfit.glasses
				equipped_outfit.glasses = loadout[slot]
			if(LOADOUT_ITEM_LEFT_HAND)
				if(equipped_outfit.l_hand)
					move_to_backpack = equipped_outfit.l_hand
				equipped_outfit.l_hand = loadout[slot]
			if(LOADOUT_ITEM_RIGHT_HAND)
				if(equipped_outfit.r_hand)
					move_to_backpack = equipped_outfit.r_hand
				equipped_outfit.r_hand = loadout[slot]
			/// Plasmaman slots - Not replaced, loadout item moved to backpack
			if(LOADOUT_ITEM_GLOVES)
				if(isplasmaman(src))
					to_chat(src, "Your loadout gloves were not equipped directly due to your envirosuit gloves.")
					move_to_backpack = loadout[slot]
				else
					equipped_outfit.gloves = loadout[slot]
			if(LOADOUT_ITEM_HEAD)
				if(isplasmaman(src))
					to_chat(src, "Your loadout helmet was not equipped directly due to your envirosuit helmet.")
					move_to_backpack = loadout[slot]
				else
					equipped_outfit.head = loadout[slot]
			if(LOADOUT_ITEM_MASK)
				if(isplasmaman(src))
					move_to_backpack = loadout[slot]
					to_chat(src, "Your loadout mask was not equipped directly due to your envirosuit mask.")
				else
					equipped_outfit.mask = loadout[slot]
			if(LOADOUT_ITEM_UNIFORM)
				if(isplasmaman(src))
					to_chat(src, "Your loadout jumpsuit was not equipped directly due to your envirosuit.")
					move_to_backpack = loadout[slot]
				else
					equipped_outfit.uniform = loadout[slot]
			// Loadout slots - items replaced and deleted
			if(LOADOUT_ITEM_NECK)
				equipped_outfit.neck = loadout[slot]
			if(LOADOUT_ITEM_SHOES)
				equipped_outfit.shoes = loadout[slot]
			if(LOADOUT_ITEM_SUIT)
				equipped_outfit.suit = loadout[slot]
			// Backpack items - accessories are equipped, and former accessories are preserved
			if(LOADOUT_ITEM_BACKPACK_1, LOADOUT_ITEM_BACKPACK_2, LOADOUT_ITEM_BACKPACK_3)
				if(ispath(text2path(loadout[slot]), /obj/item/clothing/accessory))
					if(equipped_outfit.accessory)
						move_to_backpack = equipped_outfit.accessory
					equipped_outfit.accessory = loadout[slot]
				else
					move_to_backpack = loadout[slot]
			else
				move_to_backpack = loadout[slot]
		if(!visuals_only && move_to_backpack)
			LAZYADD(equipped_outfit.backpack_contents, move_to_backpack)

	equipped_outfit.equip(src, visuals_only)
	w_uniform?.swap_to_modular_dmi(src)
	equip_greyscale(visuals_only, preference_source)
	return TRUE

/* Equip our greyscales in our greyscale loadout config to the respective slots.
 *
 * visuals_only - whether we bother greyscaling our backpack items
 * preference_source - the client belonging to the thing we're greyscaling
 */
/mob/living/carbon/human/proc/equip_greyscale(visuals_only = FALSE, datum/preferences/preference_source)
	var/list/items = preference_source?.loadout_list
	var/list/colors = preference_source?.greyscale_loadout_list
	if(!LAZYLEN(colors) || !LAZYLEN(items))
		return

	if(w_uniform && items[LOADOUT_ITEM_UNIFORM] && colors[LOADOUT_ITEM_UNIFORM])
		w_uniform.set_greyscale(colors[LOADOUT_ITEM_UNIFORM])
	if(wear_suit && items[LOADOUT_ITEM_SUIT] && colors[LOADOUT_ITEM_SUIT])
		wear_suit.set_greyscale(colors[LOADOUT_ITEM_SUIT])
	if(belt && items[LOADOUT_ITEM_BELT] && colors[LOADOUT_ITEM_BELT])
		belt.set_greyscale(colors[LOADOUT_ITEM_BELT])
	if(gloves && items[LOADOUT_ITEM_GLOVES] && colors[LOADOUT_ITEM_GLOVES])
		gloves.set_greyscale(colors[LOADOUT_ITEM_GLOVES])
	if(shoes && items[LOADOUT_ITEM_SHOES] && colors[LOADOUT_ITEM_SHOES])
		shoes.set_greyscale(colors[LOADOUT_ITEM_SHOES])
	if(head && items[LOADOUT_ITEM_HEAD] && colors[LOADOUT_ITEM_HEAD])
		head.set_greyscale(colors[LOADOUT_ITEM_HEAD])
	if(wear_mask && items[LOADOUT_ITEM_MASK] && colors[LOADOUT_ITEM_MASK])
		wear_mask.set_greyscale(colors[LOADOUT_ITEM_MASK])
	if(wear_neck && items[LOADOUT_ITEM_NECK] && colors[LOADOUT_ITEM_NECK])
		wear_neck.set_greyscale(colors[LOADOUT_ITEM_NECK])
	if(ears && items[LOADOUT_ITEM_EARS] && colors[LOADOUT_ITEM_EARS])
		ears.set_greyscale(colors[LOADOUT_ITEM_EARS])
	if(glasses && items[LOADOUT_ITEM_GLASSES] && colors[LOADOUT_ITEM_GLASSES])
		glasses.set_greyscale(colors[LOADOUT_ITEM_GLASSES])

	if(!visuals_only && back) // Items in backpack don't show up so we can ignore them
		if(items[LOADOUT_ITEM_BACKPACK_1] && colors[LOADOUT_ITEM_BACKPACK_1])
			var/obj/item/backpack_item_one = locate(text2path(items[LOADOUT_ITEM_BACKPACK_1])) in back.contents
			if(backpack_item_one)
				backpack_item_one.set_greyscale(colors[LOADOUT_ITEM_BACKPACK_1])
			else
				stack_trace("Despite having [items[LOADOUT_ITEM_BACKPACK_1]] in loadout, [src] did not have one in their backpack!")

		if(items[LOADOUT_ITEM_BACKPACK_2] && colors[LOADOUT_ITEM_BACKPACK_2])
			var/obj/item/backpack_item_two = locate(text2path(items[LOADOUT_ITEM_BACKPACK_2])) in back.contents
			if(backpack_item_two)
				backpack_item_two.set_greyscale(colors[LOADOUT_ITEM_BACKPACK_2])
			else
				stack_trace("Despite having [items[LOADOUT_ITEM_BACKPACK_2]] in loadout, [src] did not have one in their backpack!")

		if(items[LOADOUT_ITEM_BACKPACK_3] && colors[LOADOUT_ITEM_BACKPACK_3])
			var/obj/item/backpack_item_three = locate(text2path(items[LOADOUT_ITEM_BACKPACK_3])) in back.contents
			if(backpack_item_three)
				backpack_item_three.set_greyscale(colors[LOADOUT_ITEM_BACKPACK_3])
			else
				stack_trace("Despite having [items[LOADOUT_ITEM_BACKPACK_3]] in loadout, [src] did not have one in their backpack!")

	regenerate_icons()
	return TRUE

/* Removes all nulls, invalid paths, and bad slots from loadout lists.
 *
 * list_to_clean - the loadout list we're sanitizing.
 */
/proc/sanitize_loadout_list(list/list_to_clean)
	if(!istype(list_to_clean))
		return

	for(var/slot in list_to_clean)
		var/path = text2path(list_to_clean[slot])
		if(isnull(path))
			stack_trace("null value found in loadout list! Slot: [slot], Path: [path], Path Actual: [list_to_clean[slot]]")
			list_to_clean -= slot
			continue

		if(!ispath(path))
			stack_trace("invalid path found in loadout list!  Slot: [slot], Path: [path], Path Actual: [list_to_clean[slot]]")
			list_to_clean[slot] = null
			list_to_clean -= slot
			continue

		if(!(slot in GLOB.loadout_slots))
			stack_trace("invalid loadout slot found in loadout list! Slot: [slot], Path: [path]")
			list_to_clean[slot] = null
			list_to_clean -= slot

	if(!list_to_clean.len)
		list_to_clean = null

/* Removes all bad slots from greyscale loadout lists.
 *
 * list_to_clean - the greyscale loadout list we're sanitizing.
 */
/proc/sanitize_greyscale_list(list/list_to_clean)
	if(!istype(list_to_clean))
		return

	for(var/slot in list_to_clean)
		if(!(slot in GLOB.loadout_slots))
			stack_trace("invalid loadout slot found in greyscale loadout list! Slot: [slot], Color: [list_to_clean[slot]]")
			list_to_clean[slot] = null
			list_to_clean -= slot

	if(!list_to_clean.len)
		list_to_clean = null
