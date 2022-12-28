// Handles swapping sechud DMIs based on modular jobs

/datum/id_trim
	/// Icon file for the sechud.
	var/sechud_icon = 'icons/mob/huds/hud.dmi'

/mob/living/carbon/human/sec_hud_set_ID()
	. = ..()
	var/image/holder = hud_list[ID_HUD]
	var/obj/item/card/id/id = wear_id?.GetID()
	if(!id?.trim)
		holder.icon = 'icons/mob/huds/hud.dmi'
		return

	holder.icon = id.trim.sechud_icon
