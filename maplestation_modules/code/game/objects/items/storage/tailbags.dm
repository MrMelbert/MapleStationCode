// Sprites ported from Doppler - https://github.com/DopplerShift13/DopplerShift/pull/546
/obj/item/storage/belt/chest_pouch/tail
	name = "tan tail pouches"
	desc = "A set of pouches intended to be strapped around a wide tail. \
		Favored by Lizardfolk for moving their stored equipment closer to their center of mass."
	icon = 'maplestation_modules/icons/obj/clothing/lizard.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/lizard_worn.dmi'
	icon_state = "tailbag_tan"
	worn_icon_state = "tailbag_tan"
	wear_loc = "tail"

/obj/item/storage/belt/chest_pouch/tail/mob_can_equip(mob/living/M, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	var/obj/item/organ/tail/tail = M.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
	if(isnull(tail))
		if(!disable_warning)
			balloon_alert(M, "no tail!")
		return FALSE
	if(tail.w_class < WEIGHT_CLASS_BULKY)
		if(!disable_warning)
			balloon_alert(M, "tail is too small!")
		return FALSE
	return ..()

/obj/item/storage/belt/chest_pouch/tail/equipped(mob/user, slot, initial)
	. = ..()
	if(slot & (slot_flags|ITEM_SLOT_SUITSTORE))
		RegisterSignal(user, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(organ_lost))

/obj/item/storage/belt/chest_pouch/tail/dropped(mob/user, slot)
	. = ..()
	UnregisterSignal(user, COMSIG_CARBON_LOSE_ORGAN)

/obj/item/storage/belt/chest_pouch/tail/proc/organ_lost(mob/living/carbon/source, obj/item/organ/lost_organ)
	SIGNAL_HANDLER
	if(!istype(lost_organ, /obj/item/organ/tail))
		return

	source.dropItemToGround(src, force = TRUE)

/obj/item/storage/belt/chest_pouch/tail/white
	name = "white tail pouches"
	icon_state = "tailbag_white"
	worn_icon_state = "tailbag_white"

/obj/item/storage/belt/chest_pouch/tail/black
	name = "black tail pouches"
	icon_state = "tailbag_black"
	worn_icon_state = "tailbag_black"
