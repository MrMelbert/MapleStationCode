// -- Extra mob/ level procs and extensions --
/mob/living/carbon/human/sec_hud_set_ID()
	. = ..()
	var/image/holder = hud_list[ID_HUD]
	var/obj/item/card/id/id = wear_id?.GetID()
	if(!id?.trim)
		holder.icon = 'icons/mob/huds/hud.dmi'
		return

	holder.icon = id.trim.sechud_icon
