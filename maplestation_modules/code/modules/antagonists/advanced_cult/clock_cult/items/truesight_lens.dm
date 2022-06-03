// The Trusight lens.
// Binoculars for cultists only.
/obj/item/binoculars/truesight_lens
	name = "truesight lens"
	desc = "A yellow lens created by Rat-varian worshippers to spy great distances."
	icon = 'maplestation_modules/icons/obj/clockwork_objects.dmi'
	icon_state = "truesight_lens"
	inhand_icon_state = "none"
	worn_icon_state = "none"
	slot_flags = NONE
	zoom_out_amt = 0
	zoom_amt = 9

/obj/item/binoculars/truesight_lens/on_wield(obj/item/source, mob/user)
	if(!IS_CULTIST(user))
		return

	return ..()

/obj/item/binoculars/truesight_lens/on_unwield(obj/item/source, mob/user)
	if(!listeningTo || !IS_CULTIST(user))
		return

	return ..()
