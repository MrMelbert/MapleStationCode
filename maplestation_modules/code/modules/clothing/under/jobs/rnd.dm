/// -- Modular RND clothing. --
/datum/armor/clothing_under/science
	bomb = 10
	bio = 20
	fire = 20

/datum/armor/clothing_under/science/ord_scientist
	bomb = 20
	fire = 50

/obj/item/clothing/under/rank/rnd/ordnance_tech
	desc = "It's made of a special fiber that provides minor protection against explosives and fire. It has markings that denote the wearer as a Ordnance Technician."
	name = "ordnance technician's jumpsuit"
	icon = 'maplestation_modules/icons/obj/clothing/under/rnd.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/under/rnd.dmi'
	icon_state = "ordnance"
	inhand_icon_state = "w_suit"
	armor_type = /datum/armor/clothing_under/science/ord_scientist

/obj/item/clothing/under/rank/rnd/ordnance_tech/skirt
	name = "ordnance technician's jumpskirt"
	icon_state = "ordnance_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/datum/armor/clothing_under/science/xb_scientist
	bio = 50
	fire = 10

/obj/item/clothing/under/rank/rnd/xenobiologist
	desc = "It has markings that denote the wearer as a Xenobiologist."
	name = "xenobiologist's jumpsuit"
	icon = 'maplestation_modules/icons/obj/clothing/under/rnd.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/under/rnd.dmi'
	icon_state = "xeno"
	inhand_icon_state = "w_suit"
	armor_type = /datum/armor/clothing_under/science/xb_scientist

/obj/item/clothing/under/rank/rnd/xenobiologist/skirt
	name = "xenobiologist's jumpskirt"
	icon_state = "xeno_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
