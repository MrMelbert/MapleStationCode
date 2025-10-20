/obj/item/clothing/head/mod
	name = "MOD helmet"
	desc = "A helmet for a MODsuit."
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	icon_state = "standard-helmet"
	base_icon_state = "helmet"
	worn_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	armor_type = /datum/armor/none
	body_parts_covered = HEAD

/obj/item/clothing/head/mod/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_SPEED_POTION, INNATE_TRAIT)

// Even without a hat stabilizer, hats can be worn - however, they'll fall off very easily
/obj/item/clothing/head/mod/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/hat_stabilizer, loose_hat = TRUE)

/obj/item/clothing/suit/mod
	name = "MOD chestplate"
	desc = "A chestplate for a MODsuit."
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	icon_state = "standard-chestplate"
	base_icon_state = "chestplate"
	worn_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/tank/internals,
		/obj/item/flashlight,
		/obj/item/tank/jetpack/oxygen/captain,
	)
	armor_type = /datum/armor/none
	body_parts_covered = CHEST|GROIN|LEGS // NON-MODULE CHANGE
	drop_sound = null
	supports_variations_flags = CLOTHING_DIGITIGRADE_FILTER // NON-MODULE CHANGE

/obj/item/clothing/suit/mod/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_SPEED_POTION, INNATE_TRAIT)

/obj/item/clothing/suit/mod/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_SPEED_POTION, INNATE_TRAIT)

/obj/item/clothing/gloves/mod
	name = "MOD gauntlets"
	desc = "A pair of gauntlets for a MODsuit."
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	icon_state = "standard-gauntlets"
	base_icon_state = "gauntlets"
	worn_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	armor_type = /datum/armor/none
	body_parts_covered = HANDS|ARMS
	equip_sound = null
	pickup_sound = null
	drop_sound = null

/obj/item/clothing/gloves/mod/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_SPEED_POTION, INNATE_TRAIT)

/obj/item/clothing/shoes/mod
	name = "MOD boots"
	desc = "A pair of boots for a MODsuit."
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	icon_state = "standard-boots"
	base_icon_state = "boots"
	worn_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	armor_type = /datum/armor/none
	body_parts_covered = FEET|LEGS
	supports_variations_flags = CLOTHING_DIGITIGRADE_FILTER // NON-MODULE CHANGE
	can_be_tied = FALSE

/obj/item/clothing/shoes/mod/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_SPEED_POTION, INNATE_TRAIT)
