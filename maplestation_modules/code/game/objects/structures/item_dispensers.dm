/// Dispensers, sprites from Goon.

#define MAX_DISPENSER_ITEMS 8
#define MIN_DISPENSER_ITEMS 1

/obj/structure/item_dispenser
	name = "empty item dispenser"
	desc = "A small wall-mounted receptacle which can dispense a specific item."
	icon = 'goon/icons/obj/itemdispenser.dmi'
	icon_state = "dispenser_generic"
	anchored = TRUE
	density = FALSE
	max_integrity = 200
	integrity_failure = 0.25
	/// Do we start with max charges
	var/start_stocked = FALSE
	/// How many items this dispenser can hold.
	var/max_charges = 7
	/// The current amount of charges available
	var/curr_charges = 0
	/// What item is inside the dispenser, typepath
	var/obj/item/stock
	/// The name of the item in the dispenser.
	var/item_name = ""
	/// LazyList of instances of things stored inside, items are in nullspace
	var/list/obj/item/stored_things

/obj/structure/item_dispenser/examine(mob/user)
	. = ..()
	if(!stock)
		. += span_notice("Peering inside, the plastic hasn't been molded to an item yet. It looks like any small item would fit.")
		. += span_notice("Right-Clicking with a screwdriver, you could probably adjust the spring to allow a certain amount of items inside.")
		return
	if(curr_charges > 0)
		. += span_notice("There are [curr_charges] [item_name]\s remaining.")
	else
		. += span_notice("It's empty!")
		. += span_notice("Right-Clicking with a wrench, you could take it off the wall now!")

/obj/structure/item_dispenser/update_overlays()
	. = ..()
	if(!stock)
		return
	if(curr_charges > 0)
		. += "[initial(icon_state)]_full"

/obj/structure/item_dispenser/update_name(updates)
	. = ..()
	if(!stock)
		return
	item_name = initial(stock.name)
	name = "[item_name] dispenser"

/obj/structure/item_dispenser/update_desc(updates)
	. = ..()
	if(!stock)
		return
	desc = "A small wall-mounted receptacle which dispenses [item_name][plural_s(item_name)] and similar items."

/obj/structure/item_dispenser/Initialize(mapload)
	. = ..()
	if(start_stocked)
		curr_charges = max_charges

	var/update_flags = NONE
	if(curr_charges)
		// set up the starting overlays
		update_flags |= UPDATE_OVERLAYS
	if(stock)
		// set up the starting name / desc
		update_flags |= UPDATE_NAME|UPDATE_DESC
	update_appearance(update_flags)

/obj/structure/item_dispenser/Destroy()
	QDEL_LIST(stored_things)
	return ..()

/obj/structure/item_dispenser/deconstruct(disassembled)
	// don't waste time trying to drop stuff when we have no charges
	if(curr_charges <= 0)
		return ..()

	var/atom/below = drop_location()
	while(curr_charges > 0)
		var/obj/item/thing = dispense_item(below)
		if(!disassembled)
			thing.take_damage(thing.max_integrity * 0.65, BRUTE, MELEE)
	return ..()

/obj/structure/item_dispenser/atom_break(damage_flag)
	// don't waste time trying to drop stuff when we have no charges
	if(curr_charges <= 0)
		return ..()

	// When we're getting smashed up:
	// Drop a random amount of items between 0 and current charges / 2
	var/things_to_drop = rand(0, round(curr_charges / 2))
	var/atom/below = drop_location()
	for(var/i in 1 to things_to_drop)
		var/obj/item/thing = dispense_item(below)
		thing.take_damage(thing.max_integrity * 0.45, BRUTE, damage_flag)
	curr_charges -= things_to_drop
	return ..()

/obj/structure/item_dispenser/proc/dispense_item(atom/drop_loc)
	var/obj/item/dropped = LAZYLEN(stored_things) ? stored_things[1] : new stock()
	LAZYREMOVE(stored_things, dropped)
	dropped.forceMove(drop_loc)
	dropped.pixel_x = dropped.base_pixel_x + rand(-4, 4)
	dropped.pixel_y = dropped.base_pixel_y + rand(-4, 4)
	if(--curr_charges <= 0)
		update_appearance(UPDATE_OVERLAYS)
	return dropped

/obj/structure/item_dispenser/proc/add_item(obj/item/added)
	curr_charges++
	LAZYADD(stored_things, added)
	added.moveToNullspace() // We store it in nullspace rather than contents, because, idk explosions or something
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/item_dispenser/proc/set_stock(obj/item/stock_type)
	stock = stock_type
	update_appearance(UPDATE_NAME|UPDATE_DESC)

/obj/structure/item_dispenser/attackby(obj/item/I, mob/user, params)
	if(istype(I, stock))
		if(curr_charges >= max_charges)
			balloon_alert(user, "it's full!")
			return TRUE

		balloon_alert(user, "inserted [I.name]")
		playsound(src, 'sound/machines/click.ogg', 15, TRUE, -3)
		add_item(I)
		return TRUE

	if(!stock && curr_charges <= 0)
		if(I.w_class > WEIGHT_CLASS_SMALL)
			balloon_alert(user, "too large!")
			return TRUE
		set_stock(I.type)
		add_item(I)
		playsound(src, 'sound/machines/click.ogg', 15, TRUE, -3)
		balloon_alert(user, "dispenser set")
		return TRUE

	return ..()

/obj/structure/item_dispenser/wrench_act(mob/living/user, obj/item/tool)
	if(curr_charges > 0)
		balloon_alert(user, "not empty!")
		return

	balloon_alert(user, "unsecuring...")
	tool.play_tool_sound(src)
	if(!tool.use_tool(src, user, 1 SECONDS))
		balloon_alert(user, "interrupted!")
		return

	playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	loc.balloon_alert(user, "unsecured")
	new /obj/item/wallframe/item_dispenser(get_turf(src))
	deconstruct(TRUE)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/item_dispenser/screwdriver_act(mob/living/user, obj/item/tool)
	if(stock)
		balloon_alert(user, "already configured!")
		return

	var/changed_charges = tgui_input_number(user, "Input amount of items this dispenser can allow.", "Item Dispenser", max_charges, MAX_DISPENSER_ITEMS, MIN_DISPENSER_ITEMS)
	if(QDELETED(src) || QDELETED(tool) || QDELETED(user) || !user.is_holding(tool))
		return
	if(!isnum(changed_charges) || changed_charges > MAX_DISPENSER_ITEMS || changed_charges < MIN_DISPENSER_ITEMS)
		return

	balloon_alert(user, "adjusting spring...")
	tool.play_tool_sound(src)
	if(!tool.use_tool(src, user, 1 SECONDS))
		balloon_alert(user, "interrupted!")
		return

	// max charges changes but not the number of charges in it already
	max_charges = changed_charges
	balloon_alert(user, "spring adjusted to [changed_charges]")
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/item_dispenser/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!user.canUseTopic(src, be_close = TRUE, no_dexterity = TRUE, need_hands = TRUE))
		return
	if(!stock)
		balloon_alert(user, "not stocked!")
		return
	if(curr_charges <= 0)
		balloon_alert(user, "no items left!")
		return

	var/obj/item/grabbies = dispense_item(drop_location())
	var/hand_result = user.put_in_hands(grabbies)
	balloon_alert(user, "[hand_result ? "took" : "dispensed"] [item_name]")
	playsound(src, 'sound/machines/click.ogg', 15, TRUE, -3)
	return TRUE

/// Pre-set Dispensers

/obj/structure/item_dispenser/glasses
	icon_state = "dispenser_glasses"
	stock = /obj/item/clothing/glasses/regular
	start_stocked = TRUE

/obj/structure/item_dispenser/handcuffs
	icon_state = "dispenser_handcuffs"
	stock = /obj/item/restraints/handcuffs
	start_stocked = TRUE

/obj/structure/item_dispenser/latex
	icon_state = "dispenser_gloves"
	stock = /obj/item/clothing/gloves/color/latex
	start_stocked = TRUE

/obj/structure/item_dispenser/mask
	icon_state = "dispenser_mask"
	stock = /obj/item/clothing/mask/surgical
	start_stocked = TRUE

/obj/structure/item_dispenser/id
	icon_state = "dispenser_id"
	stock = /obj/item/card/id
	start_stocked = TRUE

/obj/structure/item_dispenser/radio
	icon_state = "dispenser_radio"
	stock = /obj/item/radio
	max_charges = 3
	start_stocked = TRUE

/obj/structure/item_dispenser/bodybag
	icon_state = "dispenser_bodybag"
	stock = /obj/item/bodybag
	start_stocked = TRUE

/// Empty Dispenser Wallframes

/obj/item/wallframe/item_dispenser
	name = "item dispenser frame"
	desc = "An empty frame for an item dispenser."
	icon = 'goon/icons/obj/itemdispenser.dmi'
	icon_state = "dispenserframe"
	custom_materials = list(/datum/material/plastic = 500, /datum/material/iron = 100)
	result_path = /obj/structure/item_dispenser
	pixel_shift = -27

#undef MAX_DISPENSER_ITEMS
#undef MIN_DISPENSER_ITEMS
