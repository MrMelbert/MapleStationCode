/* a collection of items produced by yellow wollywog/wollyhop
since some of them are two per character or singleton, i'm gonna save space and just port them all into one file
*/
// Weapons


/obj/item/melee/maugrim
	name = "Maugrim"
	desc = "Hilda Brandt's longsword. It was christened after slaying a space-werewolf of the same name." // todo
	force = 18 // identical the the chappie claymore rod, but without anti-magic
	block_chance = 30
	icon_state = "maugrim"
	icon = 'maplestation_modules/story_content/wollys_items/icons/obj/weapons.dmi'
	inhand_icon_state = "maugrim"
	lefthand_file = 'maplestation_modules/story_content/wollys_items/icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'maplestation_modules/story_content/wollys_items/icons/mob/inhands/weapons/swords_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	throwforce = 16
	demolition_mod = 0.75
	w_class = WEIGHT_CLASS_BULKY
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	block_sound = 'sound/weapons/parry.ogg'
	hitsound = 'sound/weapons/rapierhit.ogg'

/obj/item/melee/maugrim/on_exit_storage(datum/storage/container)
	playsound(container.parent, 'sound/items/unsheath.ogg', 25, TRUE)

/obj/item/melee/maugrim/on_enter_storage(datum/storage/container)
	playsound(container.parent, 'sound/items/sheath.ogg', 25, TRUE)

/obj/item/melee/maugrim/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/jousting)
	AddComponent(/datum/component/butchering, \
		speed = 3 SECONDS, \
		effectiveness = 95, \
		bonus_modifier = 5, \
	)

/obj/item/melee/maugrim/razorwing
	name = "Razorwing"
	desc = "Cyril Pembrooke's Jikdo. Unlike the on-station katanas, this single-edged blade is meant to be straight." // lampshade on how all katanas have been straight-edge, when they're meant to be curved.
	icon_state = "razorwing"
	inhand_icon_state = "razorwing"
	attack_verb_continuous = list("cuts", "slashes", "slices")
	attack_verb_simple = list("cut", "slash", "slice")

/obj/item/melee/maugrim/razorwing/on_exit_storage(datum/storage/container)
	playsound(container.parent, 'sound/items/unsheath.ogg', 25, TRUE)

/obj/item/melee/maugrim/razorwing/on_enter_storage(datum/storage/container)
	playsound(container.parent, 'sound/items/sheath.ogg', 25, TRUE)

/obj/item/melee/maugrim/razorwing/Initialize(mapload) // you don't need to ask me to add world building only a few people will ever see.
	. = ..()
	AddElement(/datum/element/unique_examine, \
		"The tassel is made out of a shed ornithid primary feather. \
		Judging by the color, it would be a feather from its owner. \
		Given the importance of these feathers to the flight, its quite common to hold on to such feathers. ", \
		EXAMINE_CHECK_SPECIES, /datum/species/ornithid)
	AddElement(/datum/element/bane, target_type = /mob/living/basic/heretic_summon, damage_multiplier = 0, added_damage = 2, requires_combat_mode = FALSE) // rare exhange if it ever even happens, nod to the character's specialization in anti-heresy

/obj/item/melee/gehenna // matthew's sword when he's asset protection
	name = "Gehenna"
	desc = "The christened blade of Matthew Scoria."
	icon_state = "amber_blade"
	icon = 'maplestation_modules/icons/obj/weapons.dmi'
	worn_icon_state = "amber_blade"
	worn_icon = 'maplestation_modules/icons/mob/clothing/belt.dmi'
	inhand_icon_state = "amber_blade"
	lefthand_file = 'maplestation_modules/icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/weapons/swords_righthand.dmi'
	// this is seperate from the null rod- this will have no anti-magic and higher stats to compensate for it being used by a command member who refuses to use energy guns
	force = 20
	sharpness = SHARP_EDGED
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_SUITSTORE
	block_chance = 25
	armour_penetration = 20
	w_class = WEIGHT_CLASS_HUGE
	attack_verb_continuous = list("stabs", "cuts", "slashes", "power attacks")
	attack_verb_simple = list("stab", "cut", "slash", "power attack")

// clothing & armor

/obj/item/clothing/suit/toggle/cyrilcloak
	name = "Claw-Sewn Cloak"
	desc = "A warm cloak hand sewn by a tailor's hand. Its meant for cold winter climates, not brooding in a dark corner, mind you."
	icon = 'maplestation_modules/story_content/wollys_items/icons/obj/clothing/suit.dmi'
	icon_state = "bluecloak"
	worn_icon = 'maplestation_modules/story_content/wollys_items/icons/mob/clothing/suit.dmi'
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	alternate_worn_layer = (BACK_LAYER - 0.1) // renders above back items, but below hair.

/obj/item/clothing/suit/toggle/cyrilcloak/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/flashlight,
		/obj/item/lighter,
		/obj/item/modular_computer/pda,
		/obj/item/radio,
		/obj/item/storage/bag/books,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/toy,
		/obj/item/storage/belt/sheathe/maugrim/razorwing,
	)

/obj/item/clothing/suit/matthewjacket
	name = "Embroidered Clan Jacket"
	desc = "A red and gold jacket, embroidered with iconography of the Scoria Clan of Spectra."
	icon = 'maplestation_modules/story_content/wollys_items/icons/obj/clothing/suit.dmi'
	icon_state = "sclanjacket"
	worn_icon = 'maplestation_modules/story_content/wollys_items/icons/mob/clothing/suit.dmi'
	blood_overlay_type = "armor"

/obj/item/clothing/suit/armor/vest/asset_protection/clanjacket
	name = "Armored Clan Jacket" // not special any longer
	desc = "A red and gold jacket, embroidered with iconography of the Scoria Clan of Spectra. This one has been weaved with highly-protective fabrics."
	icon = 'maplestation_modules/story_content/wollys_items/icons/obj/clothing/suit.dmi'
	icon_state = "sclanjacket"
	worn_icon = 'maplestation_modules/story_content/wollys_items/icons/mob/clothing/suit.dmi'

// loadout datums

/datum/loadout_item/suit/cyrilcloak
	name = "Claw-Sewn Cloak"
	item_path = /obj/item/clothing/suit/toggle/cyrilcloak
	additional_displayed_text = list("Character Item")

/datum/loadout_item/suit/scoriajacket
	name = "Embroidered Clan Jacket"
	item_path = /obj/item/clothing/suit/matthewjacket
	additional_displayed_text = list("Character Item")

// sheathes

/obj/item/storage/belt/sheathe/maugrim
	icon = 'maplestation_modules/story_content/wollys_items/icons/obj/clothing/belts.dmi'
	lefthand_file = 'maplestation_modules/story_content/wollys_items/icons/mob/inhands/clothes/belts_lefthand.dmi'
	righthand_file = 'maplestation_modules/story_content/wollys_items/icons/mob/inhands/clothes/belts_righthand.dmi'
	worn_icon = 'maplestation_modules/story_content/wollys_items/icons/mob/clothing/belt.dmi'
	name = "Maugrim's Sheathe"
	desc = "A sheathe"
	altclick_tip = "Altclick to draw the sword"
	icon_state = "maugrim_sheathe"
	inhand_icon_state = "maugrim_sheathe"
	worn_icon_state = "maugrim_sheathe"
	w_class = WEIGHT_CLASS_BULKY
	content_overlays = TRUE
	storable_items = list(/obj/item/melee/maugrim)
	max_weight_class = WEIGHT_CLASS_HUGE

/obj/item/storage/belt/sheathe/maugrim/update_icon_state()
	. = ..()
	if(length(contents))
		icon_state += "-sword"
		inhand_icon_state += "-sword"
		worn_icon_state += "-sword"

/obj/item/storage/belt/sheathe/maugrim/razorwing
	name = "Razorwing's Sheathe"
	desc = "A simple weaved sheathe used for containing a sword."
	icon_state = "razorwing_sheathe"
	inhand_icon_state = "razorwing_sheathe"
	worn_icon_state = "razorwing_sheathe"
	storable_items = list(/obj/item/melee/maugrim/razorwing)
