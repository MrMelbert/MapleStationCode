/obj/item/clothing/under/rank/winterprincess
	name = "gem-studded dress"
	desc = "An amethyst-studded dress of mixed white and purple satin. Surprisingly warm."
	icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_item.dmi'
	worn_icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_rhand.dmi'
	icon_state = "gemdress"
	inhand_icon_state = "gemdress"
	supports_variations_flags = CLOTHING_NO_VARIATION
	body_parts_covered = CHEST|GROIN|LEGS
	can_adjust = FALSE

/obj/item/clothing/gloves/winterprincess
	name = "golden wristlets"
	desc = "Golden bangles and ornamentative chains affixed to a light-but-sturdy purple armlet gloves. Each studded with a pearl and ending in a dangling amethyst."
	icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_item.dmi'
	worn_icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_rhand.dmi'
	icon_state = "wristlets"
	inhand_icon_state = "wristlets"

/obj/item/clothing/shoes/winterprincess
	name = "gilded sandals"
	desc = "A pair of gold-corded sandals with comfortable but practical bottoms and adequate give for a light sock."
	icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_item.dmi'
	worn_icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_rhand.dmi'
	icon_state = "gildedsandals"
	inhand_icon_state = "gildedsandals"

/obj/item/clothing/shoes/winterprincessalt
	name = "ball heels"
	desc = "Dark, wide-based heels with an onyx clasp. This pair looks new."
	icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_item.dmi'
	worn_icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_rhand.dmi'
	icon_state = "ballheels"
	inhand_icon_state = "ballheels"
	var/list/walking_sounds = list(
		'maplestation_modules/sound/items/highheel1.ogg' = 1,
		'maplestation_modules/sound/items/highheel2.ogg' = 1,
	)

/obj/item/clothing/shoes/winterprincessalt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, custom_sounds = walking_sounds, volume_override = 55, chance_override = 50)

/obj/item/clothing/under/rank/winterprincess/ballgown
	name = "umbral ballgown"
	desc = "A voluminous purple ball gown - beyond its white, lacy interior, its translucent trail and sleeves can be released to cast a wide, gentle shadow."
	icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_item.dmi'
	worn_icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_rhand.dmi'
	icon_state = "ballgown"
	inhand_icon_state = "ballgown"
	supports_variations_flags = CLOTHING_NO_VARIATION
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	can_adjust = TRUE

/obj/item/clothing/head/costume/crown/winterprincess
	name = "jeweled tiara"
	desc = "A burnished gold tiara set with amethyst and quartz. It comes to a commanding point but is surprisingly light."
	icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_item.dmi'
	worn_icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_rhand.dmi'
	icon_state = "vextiara"
	inhand_icon_state = "vextiara"

/obj/item/clothing/suit/hooded/winterprincess
	name = "dark winter cloak"
	desc = "A warm, puffy, furry winter cloak. White ermine keeps the wearer warm while the dusky purple exterior evokes the heraldry of House Finster, even with the hood raised."
	icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_item.dmi'
	worn_icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_rhand.dmi'
	icon_state = "wintercloak_down"
	inhand_icon_state = "wintercloak"
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_OCLOTHING
	body_parts_covered = CHEST|GROIN|ARMS
	hoodtype = /obj/item/clothing/head/hooded/winterprincess

/obj/item/clothing/head/hooded/winterprincess
	name = "dark winter hood"
	desc = "A warm, puffy, furry hood. It can be drawn forward to conceal one's face from stinging air and blocks most light."
	icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_item.dmi'
	worn_icon = 'maplestation_modules/story_content/winter_princess_equipment/icons/winterprincess_worn.dmi'
	icon_state = "wintercloak"
	inhand_icon_state = null
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS
