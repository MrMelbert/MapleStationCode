/// -- Loadout accessories --
/obj/item/clothing/accessory/armorless_talisman
	name = "heirloom bone talisman"
	desc = "A hand-me-down talisman made by an ancient hunter. The protection it offered once in the past is no longer."
	icon_state = "talisman"
	attachment_slot = null

/obj/item/clothing/accessory/armorless_skullcodpiece
	name = "heirloom skull codpiece"
	desc = "A cracked skull ornament, intended to protect the crotch and groin. It's old, yellowing and offers no protection anymore."
	icon_state = "skull"
	above_suit = TRUE
	attachment_slot = GROIN

/obj/item/clothing/accessory/armband/deputy_cosmetic
	name = "red armband"
	desc = "A red armband."

/obj/item/clothing/accessory/armband/cargo_cosmetic
	name = "brown armband"
	desc = "A brown armband."
	icon_state = "cargoband"

/obj/item/clothing/accessory/armband/engine_cosmetic
	name = "yellow armband"
	desc = "An orange, reflective armband."
	icon_state = "engieband"

/obj/item/clothing/accessory/armband/science_cosmetic
	name = "purple armband"
	desc = "A purple armband."
	icon_state = "rndband"

/obj/item/clothing/accessory/armband/hydro_cosmetic
	name = "green and blue armband"
	desc = "A green and blue armband."
	icon_state = "hydroband"

/obj/item/clothing/accessory/armband/med_cosmetic
	name = "white armband"
	desc = "A white armband."
	icon_state = "medband"

/obj/item/clothing/accessory/armband/medblue_cosmetic
	name = "white and blue armband"
	desc = "A white and blue armband."
	icon_state = "medblueband"

/obj/item/clothing/accessory/armband/service_cosmetic
	name = "green armband"
	desc = "A green armband."
	icon = 'maplestation_modules/icons/obj/clothing/accessories.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/accessories.dmi'
	icon_state = "servband"

/obj/item/clothing/accessory/allergy_dogtag
	desc = "A set of dogtags with a list of allergies inscribed."

/obj/item/clothing/accessory/cosmetic_dogtag
	name = "dogtags"
	desc = "A set of old dogtags with someone's name inscribed on them."
	icon_state = "allergy"
	above_suit = FALSE
	minimize_when_attached = TRUE
	attachment_slot = CHEST
	/// The name of the dogtag owner
	var/display_name

/obj/item/clothing/accessory/cosmetic_dogtag/Initialize()
	. = ..()
	var/mob/living/dogtag_owner
	if(ismob(loc))
		dogtag_owner = loc
	else if(ismob(loc.loc))
		dogtag_owner = loc.loc

	if(dogtag_owner)
		display_name = dogtag_owner.real_name

/obj/item/clothing/accessory/cosmetic_dogtag/examine(mob/user)
	. = ..()
	if(display_name)
		. += "The dogtag has a name on it: <b>[display_name]</b>."
	else
		. += "The dogtag has a name on it, but it's scratched and hard to read."

/obj/item/clothing/accessory/cosmetic_dogtag/on_uniform_equip(obj/item/clothing/under/attached_clothes, user)
	. = ..()
	RegisterSignal(attached_clothes, COMSIG_PARENT_EXAMINE,.proc/on_examine)

/obj/item/clothing/accessory/cosmetic_dogtag/on_uniform_dropped(obj/item/clothing/under/attached_clothes, user)
	. = ..()
	UnregisterSignal(attached_clothes, COMSIG_PARENT_EXAMINE)

///What happens when we examine the uniform
/obj/item/clothing/accessory/cosmetic_dogtag/proc/on_examine(datum/source, mob/user, list/examine_list)
	if(display_name)
		examine_list += "There's a set of dogtags attached. They have a name inscribed: <b>[display_name]</b>."
	else
		examine_list += "There's a set of dogtags attached. They have a name inscribed, but it's scratched and hard to read."
