/obj/vehicle/ridden/mini_forklift
	name = "mini forklift"
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/forklift.dmi'
	desc = "A mini forklift built by CaLE. It is a tight fit! It has protective bars all around it."
	icon_state = "mini_forklift"
	max_integrity = 150
	armor_type = /datum/armor/mini_forklift
	integrity_failure = 0.5
	are_legs_exposed = FALSE
	var/cover_iconstate = "mini_forklift_cover"
	layer = OBJ_LAYER

/datum/armor/mini_forklift
	melee = 60
	bullet = 25
	laser = 20
	bomb = 50
	fire = 60
	acid = 60

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

