/obj/structure/closet/crate/critter
	name = "critter crate"
	desc = "A crate designed for safe transport of animals. It has an oxygen tank for safe transport in space."
	icon_state = "crittercrate"
	base_icon_state = "crittercrate"
	horizontal = FALSE
	allow_objects = FALSE
	breakout_time = 600
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 4
	delivery_icon = "deliverybox"
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	contents_pressure_protection = 0.8
	can_install_electronics = FALSE
	elevation = 21
	elevation_open = 0
	sealed = TRUE

/obj/structure/closet/crate/critter/update_icon_state()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/structure/closet/crate/critter/update_overlays()
	. = ..()
	if(opened)
		. += "crittercrate_door_open"
		return

	. += "crittercrate_door"
	if(manifest)
		. += "manifest"
