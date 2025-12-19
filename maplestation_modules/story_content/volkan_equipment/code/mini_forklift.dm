/obj/vehicle/ridden/mini_forklift
	name = "mini forklift"
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/forklift.dmi'
	desc = "A mini electric forklift built by CaLE. It is a tight fit! It has protective bars all around it. It is too small to hold crates, but it is just the right size to hold flatpacks!"
	icon_state = "mini_forklift"
	max_integrity = 150
	armor_type = /datum/armor/mini_forklift
	integrity_failure = 0.5
	are_legs_exposed = FALSE
	var/cover_iconstate = "mini_forklift_cover"
	layer = OBJ_LAYER

#define MAX_FLAT_PACKS 4

/datum/armor/mini_forklift
	melee = 60
	bullet = 25
	laser = 20
	bomb = 50
	fire = 60
	acid = 60

/obj/vehicle/ridden/mini_forklift/atom_deconstruct(disassembled)
	for(var/atom/movable/content as anything in contents)
		content.forceMove(drop_location())

/obj/vehicle/ridden/mini_forklift/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		return

	if(istype(held_item, /obj/item/flatpack))
		context[SCREENTIP_CONTEXT_LMB] = "Load pack"
		return CONTEXTUAL_SCREENTIP_SET

/obj/vehicle/ridden/mini_forklift/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !isobserver(user))
		return

	. += "From bottom to top, this forklift is holding:"
	for(var/obj/item/flatpack as anything in contents)
		. += flatpack.name

/obj/vehicle/ridden/mini_forklift/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.put_in_hands(contents[length(contents)]) //topmost box
	update_appearance(UPDATE_OVERLAYS)

/obj/vehicle/ridden/mini_forklift/item_interaction(mob/living/user, obj/item/attacking_item, params)
	if(!istype(attacking_item, /obj/item/flatpack) || user.combat_mode || attacking_item.flags_1 & HOLOGRAM_1 || attacking_item.item_flags & ABSTRACT)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	if (length(contents) >= MAX_FLAT_PACKS)
		balloon_alert(user, "full!")
		return ITEM_INTERACT_BLOCKING
	if (!user.transferItemToLoc(attacking_item, src))
		return ITEM_INTERACT_BLOCKING
	update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/vehicle/ridden/mini_forklift/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/forklift)

/obj/vehicle/ridden/mini_forklift/post_buckle_mob(mob/living/user)
	. = ..()
	update_appearance()

/obj/vehicle/ridden/mini_forklift/post_unbuckle_mob()
	. = ..()
	update_appearance()

/obj/vehicle/ridden/mini_forklift/update_overlays()
	. = ..()
	if(has_buckled_mobs())
		. += mutable_appearance(icon, cover_iconstate, ABOVE_MOB_LAYER, appearance_flags = KEEP_APART)

	var/offset = 0
	for(var/item in contents)
		var/mutable_appearance/flatpack_overlay = mutable_appearance(icon, "flatcart_flat", layer = ABOVE_MOB_LAYER + (offset * 0.01))
		flatpack_overlay.pixel_y = offset
		offset += 3
		. += flatpack_overlay

/datum/component/riding/vehicle/forklift
	vehicle_move_delay = 1.75
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER

/datum/component/riding/vehicle/forklift/get_parent_offsets_and_layers()
	. = ..()
	return list(
		TEXT_NORTH = list(0, 0, BELOW_MOB_LAYER),
		TEXT_SOUTH = list(0, -3, BELOW_MOB_LAYER),
		TEXT_EAST =  list(0, 0, BELOW_MOB_LAYER),
		TEXT_WEST =  list(0, 0, BELOW_MOB_LAYER),
	)

/datum/component/riding/vehicle/forklift/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list( 1, 0),
		TEXT_SOUTH = list( 1,  0),
		TEXT_EAST =  list(-5, 0),
		TEXT_WEST =  list( 5, 0),
	)

#undef MAX_FLAT_PACKS
