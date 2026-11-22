#define GREY_CORE_FLAG (1<<0)
#define METAL_CORE_FLAG (1<<1)
#define ORANGE_CORE_FLAG (1<<2)
#define PURPLE_CORE_FLAG (1<<3)
#define BLUE_CORE_FLAG (1<<4)
#define ALL_REQUIRED_CORES (GREY_CORE_FLAG | METAL_CORE_FLAG | ORANGE_CORE_FLAG | PURPLE_CORE_FLAG | BLUE_CORE_FLAG)

/// Makes sure we don't accidentally keep it on when we use this
/obj/machinery/computer/camera_advanced/xenobio/remove_eye_control(mob/living/user)
	. = ..()
	interaction_flags_atom &= ~INTERACT_ATOM_BYPASS_ADJACENCY

/// Link to an existing xenobio console to use it outside of the lab. Stop being a hermit!
/obj/item/handheld_xenobio
	name = "Game-Slime portable console"
	desc = "A handheld device capable of linking to a slime management console for keeping your slimes alive at a distance."
	icon = 'maplestation_modules/icons/obj/devices.dmi'
	icon_state = "gameslime"
	item_flags = NOBLUDGEON
	throwforce = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	drop_sound = 'maplestation_modules/sound/items/drop/device2.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/device.ogg'
	/// Buffer to save the slime management console in
	var/datum/weakref/console_buffer
	/// Slime cores required to activate the machine. If all are in, then we're good!
	var/core_flags = NONE
	/// The overlay we use to show if we're linked to a console, stored so we can remove it if needed
	var/mutable_appearance/linked_overlay

/obj/item/handheld_xenobio/Initialize(mapload)
	. = ..()
	linked_overlay = mutable_appearance(icon, "gs_linked")

/obj/item/handheld_xenobio/examine(mob/user)
	. = ..()
	if((core_flags & ALL_REQUIRED_CORES) == ALL_REQUIRED_CORES)
		return
	var/list/missing_core_colors = list()
	if(!(core_flags & GREY_CORE_FLAG))
		missing_core_colors += "grey"
	if(!(core_flags & ORANGE_CORE_FLAG))
		missing_core_colors += "orange"
	if(!(core_flags & PURPLE_CORE_FLAG))
		missing_core_colors += "purple"
	if(!(core_flags & BLUE_CORE_FLAG))
		missing_core_colors += "blue"
	if(!(core_flags & METAL_CORE_FLAG))
		missing_core_colors += "metal"
	/// Build a string from our list because for some reason we don't have a helper to put "and" at the end of a joined list
	var/length_of_colors = LAZYLEN(missing_core_colors)
	var/color_core_index = 1
	var/built_string_list = ""
	for(var/color_name in missing_core_colors)
		// Last core in a list over 1
		if(length_of_colors > 1 && color_core_index == length_of_colors)
			built_string_list += "and [color_name]"
			break
		// List is just 1
		if(length_of_colors == 1)
			built_string_list += "[color_name]"
			break
		// First core in a list of 2
		if(length_of_colors == 2 && color_core_index == 1)
			built_string_list += "[color_name] "
			color_core_index++
			continue
		// All others
		built_string_list += "[color_name], "
		color_core_index++
	. += span_notice("The console requires a [built_string_list] slime extract to function.")

/obj/item/handheld_xenobio/attack_self(mob/user, modifiers)
	. = ..()
	if((core_flags & ALL_REQUIRED_CORES) != ALL_REQUIRED_CORES)
		to_chat(user, span_notice("The console is missing required extracts!"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		return
	if(isnull(console_buffer))
		to_chat(user, span_notice("No linked console!"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		return
	var/obj/machinery/computer/camera_advanced/xenobio/buffered_camera = console_buffer?.resolve()
	if(isnull(buffered_camera))
		to_chat(user, span_notice("Linked console connection severed!"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		cut_overlay(linked_overlay)
		console_buffer = null // just to be 100% sure
		return
	buffered_camera.interaction_flags_atom |= INTERACT_ATOM_BYPASS_ADJACENCY
	buffered_camera.attack_hand(user)

/obj/item/handheld_xenobio/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if((core_flags & ALL_REQUIRED_CORES) == ALL_REQUIRED_CORES)
		return NONE
	if(!(core_flags & GREY_CORE_FLAG) && istype(tool, /obj/item/slime_extract/grey))
		insert_extract(tool, GREY_CORE_FLAG)
		return ITEM_INTERACT_SUCCESS
	if(!(core_flags & METAL_CORE_FLAG) && istype(tool, /obj/item/slime_extract/metal))
		insert_extract(tool, METAL_CORE_FLAG)
		return ITEM_INTERACT_SUCCESS
	if(!(core_flags & ORANGE_CORE_FLAG) && istype(tool, /obj/item/slime_extract/orange))
		insert_extract(tool, ORANGE_CORE_FLAG)
		return ITEM_INTERACT_SUCCESS
	if(!(core_flags & PURPLE_CORE_FLAG) && istype(tool, /obj/item/slime_extract/purple))
		insert_extract(tool, PURPLE_CORE_FLAG)
		return ITEM_INTERACT_SUCCESS
	if(!(core_flags & BLUE_CORE_FLAG) && istype(tool, /obj/item/slime_extract/blue))
		insert_extract(tool, BLUE_CORE_FLAG)
		return ITEM_INTERACT_SUCCESS

/obj/item/handheld_xenobio/proc/insert_extract(obj/item/extract, flag_to_flip)
	var/mutable_appearance/inserted_overlay = mutable_appearance(icon, "gs_[extract.icon_state]")
	add_overlay(inserted_overlay)
	qdel(extract)
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	core_flags |= flag_to_flip

/obj/item/handheld_xenobio/attack_atom(atom/attacked_atom, mob/living/user, params)
	if(!istype(attacked_atom, /obj/machinery/computer/camera_advanced/xenobio))
		return ..()
	if(!isnull(console_buffer))
		to_chat(user, span_notice("Already linked!"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		return ..()
	var/obj/machinery/computer/camera_advanced/xenobio/new_buffered_console = attacked_atom
	console_buffer = WEAKREF(new_buffered_console)
	playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
	add_overlay(linked_overlay)
	to_chat(user, span_nicegreen("Linked to console!"))

#undef GREY_CORE_FLAG
#undef METAL_CORE_FLAG
#undef ORANGE_CORE_FLAG
#undef PURPLE_CORE_FLAG
#undef BLUE_CORE_FLAG
#undef ALL_REQUIRED_CORES
