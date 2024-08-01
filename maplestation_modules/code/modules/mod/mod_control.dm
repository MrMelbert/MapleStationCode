/datum/mod_theme
	activation_step_time = 1 SECONDS

/obj/item/mod/control/update_speed()
	var/list/all_parts = mod_parts + src
	if (gauntlets)
		all_parts -= gauntlets
	if (helmet)
		all_parts -= helmet
	for(var/obj/item/part as anything in all_parts)
		part.slowdown = (active ? slowdown_active : 0) / length(all_parts)
	wearer?.update_equipment_speed_mods()

/obj/item/mod/control/deploy(mob/user, obj/item/part)
	. = ..()
	for (var/obj/item/mod/module/module in modules)
		if ((part.slot_flags in module.mount_part) && module.module_deployed())
			module.on_suit_activation()
			if (user && (module.overlay_state_inactive || module.overlay_state_active))
				user.update_worn_back()

/obj/item/mod/control/retract(mob/user, obj/item/part)
	. = ..()
	for (var/obj/item/mod/module/module in modules)
		if (part.slot_flags in module.mount_part)
			module.on_suit_deactivation()
			if (user && (module.overlay_state_inactive || module.overlay_state_active))
				user.update_worn_back()
