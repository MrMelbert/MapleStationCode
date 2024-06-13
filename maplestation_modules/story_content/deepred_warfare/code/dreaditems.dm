/obj/item/storage/dread_storage
	name = "Heavy Duty Storage Unit"
	desc = "A heavy duty storage unit, designed to hold a large amount of items. You could carry it around, but it's too big to equip."
	icon = 'dreaditems.dmi'
	icon_state = "storageunit"
	lefthand_file = 'dreadlefthand.dmi'
	righthand_file = 'dreadrighthand.dmi'
	inhand_icon_state = "storageunit"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	item_flags = NO_MAT_REDEMPTION
	armor_type = /datum/armor/dread_storage
	storage_type = /datum/storage/dread_storage

/datum/armor/dread_storage
	fire = 100
	acid = 50

/datum/storage/dread_storage
	max_specific_storage = WEIGHT_CLASS_BULKY
	max_total_storage = 90
	max_slots = 30
	allow_big_nesting = TRUE

/obj/item/clothing/neck/cloak/redtech_dread
	name = "The Surgeon's Cloak"
	desc = "The Surgeon's Cloak, a heavy duty cloak lined with heavy metals the wearer from external analysis. It's a bit bulky and was probably made for something a lot larger than you."
	icon = 'dreaditems.dmi'
	icon_state = "cloak"
	w_class = WEIGHT_CLASS_BULKY
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDESUITSTORAGE
