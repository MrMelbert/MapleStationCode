// Hi Melbert :)

/obj/item/clothing/under/rank/noble
	name = "quality suit"
	desc = "A high quality shirt with slacks, it's soft to the touch."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "noblesuit"
	inhand_icon_state = "noblesuit"
	supports_variations_flags = CLOTHING_NO_VARIATION
	can_adjust = TRUE

/obj/item/clothing/under/rank/noblealt
	name = "formal dress"
	desc = "A dress made from silk. The dress is embroidered with an elaborate blue pattern."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "nobledress"
	inhand_icon_state = "nobledress"
	supports_variations_flags = CLOTHING_NO_VARIATION
	body_parts_covered = CHEST|GROIN|LEGS
	flags_inv = HIDESHOES

/obj/item/clothing/shoes/noble
	name = "fancy loafers"
	desc = "Hard leather loafers with thick soles on the bottom, the leather lightly shines in the light."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "nobleshoes"
	inhand_icon_state = "nobleshoes"

/obj/item/clothing/shoes/noblealt
	name = "white heels"
	desc = "Delicate white heels with a gold clasp. This pair looks very well cared for."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "nobleheels"
	inhand_icon_state = "nobleheels"
	var/list/walking_sounds = list(
		'maplestation_modules/sound/items/highheel1.ogg' = 1,
		'maplestation_modules/sound/items/highheel2.ogg' = 1,
	)

/obj/item/clothing/shoes/noblealt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, custom_sounds = walking_sounds, volume_override = 55, chance_override = 50)

/obj/item/clothing/gloves/noble
	name = "black leather gloves"
	desc = "Tough black leather gloves with the top section cut off for breathability."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "noblegloves"
	inhand_icon_state = "noblegloves"

/obj/item/clothing/gloves/noblealt
	name = "silky sleeves"
	desc = "Delicate white sleeves detatched from their intended partner. Wearing them makes you feel just a tad more delicate."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "noblesleeves"
	inhand_icon_state = "noblesleeves"

/obj/item/clothing/suit/toggle/noble
	name = "quality suit coat"
	desc = "A fitted black coat lined with golden embroidery."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "noblejacket"
	inhand_icon_state = "noblejacket"


/obj/item/clothing/head/costume/crown/noble
	name = "jewled tiara"
	desc = "A sparkling tiara set with multiple white and red gems. The center gemstone especially sparkle in the light."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "noblecrown"
	inhand_icon_state = "noblecrown"

//I offically need an adult :(

/obj/item/clothing/under/rank/chiffon
	name = "chiffon dress"
	desc = "A dress made from silk chiffon. The elegant fabric was guaranteed to draw attention."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "elegantdress"
	inhand_icon_state = "elegantdress"
	supports_variations_flags = CLOTHING_NO_VARIATION
	body_parts_covered = CHEST|GROIN|LEGS
	flags_inv = HIDESHOES

/obj/item/clothing/suit/costume/chiffon
	name = "chiffon lace coat"
	desc = "A lace chiffon overcoat that falls delicately along the form of the wearer."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "elegantcoat"
	inhand_icon_state = "elegantcoat"

/obj/item/clothing/gloves/chiffon
	name = "chiffon gloves"
	desc = "Delicate gloves that felt soft to the touch. Commit crimes with elegance!"
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "elegantgloves"
	inhand_icon_state = "elegantgloves"

//The type path is a lie.
/obj/item/clothing/shoes/chiffon
	name = "velvet flats"
	desc = "Delicate velvet flats in a purplish pink color. The flats offered a lot of support for the arch of the foot."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "elegantflats"
	inhand_icon_state = "elegantflats"

/obj/item/clothing/head/costume/chiffonbow
	name = "chiffon bow"
	desc = "A dainty bow made from similar materials from it matching dress and coat."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "elegantbow"
	inhand_icon_state = "elegantbow"

//This type path is also a lie.
/obj/item/storage/backpack/satchel/leather/chiffon
	name = "velvet satchel"
	desc = "A fancy satchel. The interior was lined with soft velvet."
	icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noble_equipment/icons/noble_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/noble_equipment/icons/noble_rhand.dmi'
	icon_state = "elegantsatchel"
	inhand_icon_state = "elegantsatchel"
