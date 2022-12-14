/obj/item/clothing/under/rank/medical/chief_medical_officer/special
	name = "fitted doctor's uniform"
	desc = "A custom fit uniform made from higher quality fabric. Its pockets are deeper than the a standard uniform."
	icon = 'maplestation_modules/story_content/prince_equipment/icons/doctor_item.dmi'
	worn_icon = 'maplestation_modules/story_content/prince_equipment/icons/doctor_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/prince_equipment/icons/doctor_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/prince_equipment/icons/doctor_rhand.dmi'
	// Item: "uni"
	// Sleeves adjusted: "uni_r" (UNUSED)
	// Adjusted: "uni_d"
	// Inhand: "uni"
	// Worn: "uni"
	icon_state = "uni"
	supports_variations_flags = CLOTHING_NO_VARIATION

/obj/item/clothing/shoes/jackboots/medical
	name = "medical boots"
	desc = "Medical grade boots with slots for medical pens. This particular pair seems to have thicker soles on the bottom."
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 95, FIRE = 0, ACID = 0)
	icon = 'maplestation_modules/story_content/prince_equipment/icons/doctor_item.dmi'
	worn_icon = 'maplestation_modules/story_content/prince_equipment/icons/doctor_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/prince_equipment/icons/doctor_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/prince_equipment/icons/doctor_rhand.dmi'
	// Item: "boots"
	// Inhand: "boots"
	// Worn: "boots"
	icon_state = "boots"

/obj/item/clothing/gloves/color/latex/nitrile/special
	name = "high grade nitriles"
	desc = "Medical grade gloves made from thicker material. These are more resistant to tearing and cuts."
	icon = 'maplestation_modules/story_content/prince_equipment/icons/doctor_item.dmi'
	worn_icon = 'maplestation_modules/story_content/prince_equipment/icons/doctor_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/prince_equipment/icons/doctor_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/prince_equipment/icons/doctor_rhand.dmi'
	// Item: "gloves"
	// Inhand: "gloves"
	// Worn: "gloves"
	icon_state = "gloves"

/obj/item/clothing/suit/toggle/labcoat/cmo/special
	name = "elaborate medical lab coat"
	desc = "A labcoat made from specialized, high quality fabric to repel blood and other fluids."
	icon = 'maplestation_modules/story_content/prince_equipment/icons/doctor_item.dmi'
	worn_icon = 'maplestation_modules/story_content/prince_equipment/icons/doctor_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/prince_equipment/icons/doctor_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/prince_equipment/icons/doctor_rhand.dmi'
	// Item: "coat"
	// Adjusted (open): "coat_open"
	// Inhand: "coat"
	// Worn: "coat"
	icon_state = "coat"
	inhand_icon_state = "coat"

/obj/item/storage/belt/medical/cmo
	name = "chief medical officer's belt"
	desc = "A belt made with liquid resistant fabric. The emblem on the side suggests this belongs to the Chief Medical Officer."
	icon = 'maplestation_modules/story_content/prince_equipment/icons/doctor_item.dmi'
	worn_icon = 'maplestation_modules/story_content/prince_equipment/icons/doctor_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/prince_equipment/icons/doctor_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/prince_equipment/icons/doctor_rhand.dmi'
	// Item: "belt"
	// Inhand: "belt"
	// Worn: "belt"
	icon_state = "belt"

// Clothes to the bag
/obj/item/storage/bag/garment/chief_medical/PopulateContents()
	. = ..()
	new /obj/item/clothing/under/rank/medical/chief_medical_officer/special(src)
	new /obj/item/clothing/shoes/jackboots/medical(src)
	new /obj/item/clothing/gloves/color/latex/nitrile/special(src)
	new /obj/item/clothing/suit/toggle/labcoat/cmo/special(src)

// Belt to the locker
/obj/structure/closet/secure_closet/chief_medical/PopulateContents()
	. = ..()
	new /obj/item/storage/belt/medical/cmo(src)
