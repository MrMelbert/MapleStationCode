// The Trusight lens.
// Binoculars for cultists only.
/obj/item/binoculars/truesight_lens
	name = "truesight lens"
	desc = "A yellow lens created by Rat'varian worshippers to spy great distances."
	icon = 'maplestation_modules/icons/obj/clockwork_objects.dmi'
	icon_state = "truesight_lens"
	inhand_icon_state = null
	worn_icon_state = null
	slot_flags = NONE

/obj/item/binoculars/truesight_lens/on_wield(obj/item/source, mob/living/user)
	if(!IS_CULTIST(user))
		user.become_blind(REF(src))
		to_chat(user, span_warning("As you put your eye to the lens, you suddenly lose your sight!"))
	return ..()

/obj/item/binoculars/truesight_lens/on_unwield(obj/item/source, mob/living/user)
	user.cure_blind(REF(src))
	return ..()
