// -- Extra mob/ level procs and extensions --
/mob/living/carbon/human/sec_hud_set_ID()
	. = ..()
	var/image/holder = hud_list[ID_HUD]
	var/obj/item/card/id/id = wear_id?.GetID()
	if(!id)
		holder.icon = 'icons/mob/huds/hud.dmi'
		return

	if(id?.assignment in get_all_module_jobs())
		holder.icon = 'jollystation_modules/icons/mob/huds/hud.dmi'
	else
		holder.icon = 'icons/mob/huds/hud.dmi'
