/// Inhand items (Moves overrided items to backpack)
/datum/loadout_category/inhands
	category_name = "Inhand"
	type_to_generate = /datum/loadout_item/inhand
	tab_order = 12

/datum/loadout_item/inhand
	abstract_type = /datum/loadout_item/inhand

/datum/loadout_item/inhand/insert_path_into_outfit(datum/outfit/outfit, list/preference_list, mob/living/carbon/human/equipper, visuals_only, job_equipping_step)
	if(outfit.l_hand && !outfit.r_hand)
		outfit.r_hand = item_path
	else
		if(outfit.l_hand)
			LAZYADD(outfit.backpack_contents, outfit.l_hand)
		outfit.l_hand = item_path

/datum/loadout_item/inhand/cane
	name = "Cane"
	item_path = /obj/item/cane

/datum/loadout_item/inhand/cane_white
	name = "White Cane"
	item_path = /obj/item/cane/white

/datum/loadout_item/inhand/briefcase
	name = "Briefcase"
	item_path = /obj/item/storage/briefcase

/datum/loadout_item/inhand/briefcase_secure
	name = "Briefcase (Secure)"
	item_path = /obj/item/storage/briefcase/secure

/datum/loadout_item/inhand/skateboard
	name = "Skateboard"
	item_path = /obj/item/melee/skateboard

/datum/loadout_item/inhand/bone_spear
	name = "Heirloom Bone Spear"
	item_path = /obj/item/spear/bonespear/ceremonial

/datum/loadout_item/inhand/bone_spear/get_item_information()
	. = ..()
	.[FA_ICON_VR_CARDBOARD] = "Cosmetic"

/datum/loadout_item/inhand/bouquet_mixed
	name = "Bouquet (Mixed)"
	item_path = /obj/item/bouquet

/datum/loadout_item/inhand/bouquet_sunflower
	name = "Bouquet (Sunflower)"
	item_path = /obj/item/bouquet/sunflower

/datum/loadout_item/inhand/bouquet_poppy
	name = "Bouquet (Poppy)"
	item_path = /obj/item/bouquet/poppy

/datum/loadout_item/inhand/bouquet_rose
	name = "Bouquet (Rose)"
	item_path = /obj/item/bouquet/rose
