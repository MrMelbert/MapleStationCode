/obj/item/clothing/shoes/magboots
	VAR_PRIVATE/datum/component/shoe_footstep/footstep_component
	var/list/inactive_step_sounds = list('maplestation_modules/sound/items/rigstep_medium.ogg')
	var/list/active_step_sounds = list('maplestation_modules/sound/items/rigstep_chonk.ogg')

/obj/item/clothing/shoes/magboots/Initialize(mapload)
	. = ..()
	footstep_component = AddComponent(/datum/component/shoe_footstep, inactive_step_sounds, volume = 50)

/obj/item/clothing/shoes/magboots/Destroy()
	footstep_component = null
	return ..()

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	. = ..()
	QDEL_NULL(footstep_component)
	if(magpulse)
		footstep_component = AddComponent(/datum/component/shoe_footstep, active_step_sounds, volume = 50)
	else
		footstep_component = AddComponent(/datum/component/shoe_footstep, inactive_step_sounds, volume = 50)

/obj/item/clothing/shoes/magboots/advance
	inactive_step_sounds = list('maplestation_modules/sound/items/rigstep.ogg')
	active_step_sounds = list('maplestation_modules/sound/items/rigstep_medium.ogg')

/obj/item/clothing/shoes/magboots/syndie
	active_step_sounds = list('maplestation_modules/sound/items/rigstep_heavy.ogg')

/obj/item/clothing/shoes/mod
	VAR_PRIVATE/datum/component/shoe_footstep/footstep_component

/obj/item/clothing/shoes/mod/Destroy()
	footstep_component = null
	return ..()

/obj/item/clothing/shoes/mod/proc/update_footstep_sounds()
	QDEL_NULL(footstep_component)
	switch(slowdown)
		if(0.3 to INFINITY)
			footstep_component = AddComponent(/datum/component/shoe_footstep, list('maplestation_modules/sound/items/rigstep_chonk.ogg'), volume = 50)
		if(0.2 to 0.3)
			footstep_component = AddComponent(/datum/component/shoe_footstep, list('maplestation_modules/sound/items/rigstep_heavy.ogg'), volume = 50)
		if(0.1 to 0.2)
			footstep_component = AddComponent(/datum/component/shoe_footstep, list('maplestation_modules/sound/items/rigstep_medium.ogg'), volume = 50)
		if(-INFINITY to 0.1)
			footstep_component = AddComponent(/datum/component/shoe_footstep, list('maplestation_modules/sound/items/rigstep.ogg'), volume = 50)
