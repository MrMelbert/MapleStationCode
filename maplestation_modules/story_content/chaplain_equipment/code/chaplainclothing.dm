/obj/item/clothing/under/rank/cleric
	name = "puligard unifrom"
	desc = "A uniform designed for the faithful holy army of Gilidan."
	icon = 'maplestation_modules/story_content/chaplain_equipment/cleric_icons.dmi'
	worn_icon = 'maplestation_modules/story_content/chaplain_equipment/cleric_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/chaplain_equipment/cleric_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/chaplain_equipment/cleric_rhand.dmi'
	icon_state = "clericrobe"
	inhand_icon_state = "clericrobe"
	supports_variations_flags = CLOTHING_NO_VARIATION
	can_adjust = TRUE

/obj/item/clothing/under/rank/cleric/skirt
	name = "puligard uniform skirt"
	desc = "A uniform designed for the faithful holy army of Gilidan. This uniform is fitted with a skirt."
	icon = 'maplestation_modules/story_content/chaplain_equipment/cleric_icons.dmi'
	worn_icon = 'maplestation_modules/story_content/chaplain_equipment/cleric_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/chaplain_equipment/cleric_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/chaplain_equipment/cleric_rhand.dmi'
	icon_state = "clericskirt"
	inhand_icon_state = "clericrobe"
	supports_variations_flags = CLOTHING_NO_VARIATION
	can_adjust = TRUE

/obj/item/clothing/shoes/cleric
	name = "puligard's shoes"
	desc = "Soft leather shoes designed for acolyte's of the Puligard church."
	icon = 'maplestation_modules/story_content/chaplain_equipment/cleric_icons.dmi'
	worn_icon = 'maplestation_modules/story_content/chaplain_equipment/cleric_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/chaplain_equipment/cleric_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/chaplain_equipment/cleric_rhand.dmi'
	icon_state = "clericshoes"
	inhand_icon_state = "clericshoes"
	strip_delay = 30
	equip_delay_other = 50
	resistance_flags = NONE
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 90, FIRE = 0, ACID = 0)
	can_be_tied = FALSE

/obj/item/clothing/suit/hooded/cleric
	name = "puligard's cloak"
	desc = "A soft feathery cloak designed for high ranking officals of the Puligard church."
	icon = 'maplestation_modules/story_content/chaplain_equipment/cleric_icons.dmi'
	worn_icon = 'maplestation_modules/story_content/chaplain_equipment/cleric_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/chaplain_equipment/cleric_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/chaplain_equipment/cleric_rhand.dmi'
	icon_state = "clericcloak"
	inhand_icon_state = "clericcloak"
	body_parts_covered = CHEST|GROIN
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, FIRE = 80, ACID = 80, WOUND = 20)
	hoodtype = /obj/item/clothing/head/hooded/cleirc
	allowed = list(/obj/item/storage/book/bible, /obj/item/nullrod, /obj/item/reagent_containers/cup/glass/bottle/holywater, /obj/item/storage/fancy/candle_box, /obj/item/candle, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)

/obj/item/clothing/head/hooded/cleirc
	name = "chaplain's quality carapace"
	desc = "The hood attached to a Puligard's cloak."
	icon = 'maplestation_modules/story_content/chaplain_equipment/cleric_icons.dmi'
	worn_icon = 'maplestation_modules/story_content/chaplain_equipment/cleric_worn.dmi'
	lefthand_file = 'maplestation_modules/story_content/chaplain_equipment/cleric_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/chaplain_equipment/cleric_rhand.dmi'
	icon_state = "clerichood"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEYES|HIDEFACIALHAIR|HIDEEARS
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, FIRE = 80, ACID = 80, WOUND = 20)

/obj/item/nullrod/cleric
	name = "holy puligard spear"
	desc = "A gold-bossed, white crystal embeded spear hailing from the holy land of Gilidan. The weight of the spear requires two handed use. Can be worn on the belt."
	icon = 'maplestation_modules/story_content/chaplain_equipment/cleric_icons.dmi'
	icon_state = "spear0"
	base_icon_state = "spear"
	inhand_icon_state = null
	lefthand_file = 'maplestation_modules/story_content/chaplain_equipment/cleric_lhand.dmi'
	righthand_file = 'maplestation_modules/story_content/chaplain_equipment/cleric_rhand.dmi'
	slot_flags = ITEM_SLOT_BELT
	worn_icon = "ratvarian_spear"
	force = 7
	armour_penetration = 30
	throwforce = 20
	sharpness = SHARP_POINTY
	w_class = WEIGHT_CLASS_HUGE
	attack_verb_continuous = list("stabs", "pokes", "slashes")
	attack_verb_simple = list("stab", "poke", "slash")
	hitsound = 'sound/weapons/bladeslice.ogg'
	menu_description = "A pointy spear which penetrates armor a little. Can be worn only on the belt."

/obj/item/nullrod/cleric/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded = 7, force_wielded = 18, icon_wielded = "spear1")
	
/obj/item/nullrod/cleric/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()
