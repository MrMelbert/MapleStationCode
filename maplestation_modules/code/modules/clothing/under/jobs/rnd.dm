/// -- Modular RND clothing. --
/obj/item/clothing/under/rank/rnd/ordnance_tech
	desc = "It's made of a special fiber that provides minor protection against explosives and radiation. It has markings that denote the wearer as a Ordnance Technician."
	name = "ordnance technician's jumpsuit"
	icon = 'maplestation_modules/icons/obj/clothing/under/rnd.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/under/rnd.dmi'
	icon_state = "ordnance"
	inhand_icon_state = "w_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 15, BIO = 0, FIRE = 50, ACID = 0)

/obj/item/clothing/under/rank/rnd/ordnance_tech/skirt
	name = "ordnance technician's jumpskirt"
	icon_state = "ordnance_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/rank/rnd/xenobiologist
	desc = "It has markings that denote the wearer as a Xenobiologist."
	name = "xenobiologist's jumpsuit"
	icon = 'maplestation_modules/icons/obj/clothing/under/rnd.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/under/rnd.dmi'
	icon_state = "xeno"
	inhand_icon_state = "w_suit"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 15, FIRE = 0, ACID = 0)

/obj/item/clothing/under/rank/rnd/xenobiologist/skirt
	name = "xenobiologist's jumpskirt"
	icon_state = "xeno_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP
