// --- Loadout item datums for shoes items ---

/// Shoe Slot Items (Deletes overrided items)
/datum/loadout_category/shoes
	category_name = "Shoes"
	type_to_generate = /datum/loadout_item/shoes
	tab_order = 13

/datum/loadout_item/shoes
	abstract_type = /datum/loadout_item/shoes
	/// Snowflake, whether these shoes work on digi legs.
	VAR_FINAL/supports_digitigrade = FALSE

/datum/loadout_item/shoes/New()
	. = ..()
	supports_digitigrade = !!(initial(item_path.supports_variations_flags) & DIGITIGRADE_VARIATIONS)

/datum/loadout_item/shoes/get_item_information()
	. = ..()
	if(supports_digitigrade)
		.[FA_ICON_DRAGON] = "Supports digitigrade legs"

/datum/loadout_item/shoes/is_equippable(mob/living/carbon/human/equipper, list/item_details)
	return ..() && (supports_digitigrade || (equipper.bodyshape & BODYSHAPE_DIGITIGRADE))

/datum/loadout_item/shoes/insert_path_into_outfit(datum/outfit/outfit, list/item_details, mob/living/carbon/human/equipper, visuals_only, job_equipping_step)
	outfit.shoes = item_path

/datum/loadout_item/shoes/jackboots
	name = "Jackboots"
	item_path = /obj/item/clothing/shoes/jackboots/loadout

/datum/loadout_item/shoes/winter_boots
	name = "Winter Boots"
	item_path = /obj/item/clothing/shoes/winterboots

/datum/loadout_item/shoes/work_boots
	name = "Work Boots (Tan)"
	item_path = /obj/item/clothing/shoes/workboots

/datum/loadout_item/shoes/mining_boots
	name = "Mining Boots"
	item_path = /obj/item/clothing/shoes/workboots/mining

/datum/loadout_item/shoes/black_work_boots
	name = "Work Boots (Black)"
	item_path = /obj/item/clothing/shoes/workboots/black

/datum/loadout_item/shoes/black_laceup
	name = "Black Laceup Shoes"
	item_path = /obj/item/clothing/shoes/laceup

/datum/loadout_item/shoes/burgundy_laceup
	name = "Burgundy Laceup Shoes"
	item_path = /obj/item/clothing/shoes/laceup/burgundy

/datum/loadout_item/shoes/brown_laceup
	name = "Brown Laceup Shoes"
	item_path = /obj/item/clothing/shoes/laceup/brown

/datum/loadout_item/shoes/russian_boots
	name = "Russian Boots"
	item_path = /obj/item/clothing/shoes/russian

/datum/loadout_item/shoes/black_cowboy_boots
	name = "Black Cowboy Boots"
	item_path = /obj/item/clothing/shoes/cowboy/black

/datum/loadout_item/shoes/brown_cowboy_boots
	name = "Brown Cowboy Boots"
	item_path = /obj/item/clothing/shoes/cowboy

/datum/loadout_item/shoes/white_cowboy_boots
	name = "White Cowboy Boots"
	item_path = /obj/item/clothing/shoes/cowboy/white

/datum/loadout_item/shoes/greyscale_sneakers
	name = "Greyscale Sneakers"
	item_path = /obj/item/clothing/shoes/sneakers/greyscale

/datum/loadout_item/shoes/sandals
	name = "Sandals"
	item_path = /obj/item/clothing/shoes/sandal

/datum/loadout_item/shoes/heels
	name = "High Heels"
	item_path = /obj/item/clothing/shoes/heels

/datum/loadout_item/shoes/fancy_heels
	name = "Fancy High Heels"
	item_path = /obj/item/clothing/shoes/heels/fancy

/datum/loadout_item/shoes/barefoot
	name = "Barefoot"
	item_path = /obj/item/clothing/shoes/barefoot
	ui_icon = 'icons/mob/landmarks.dmi'
	ui_icon_state = "x"

/datum/loadout_item/shoes/barefoot/on_equip_item(obj/item/equipped_item, list/item_details, mob/living/carbon/human/equipper, datum/outfit/outfit, visuals_only)
	return NONE

/datum/loadout_item/shoes/barefoot/insert_path_into_outfit(datum/outfit/outfit, list/item_details, mob/living/carbon/human/equipper, visuals_only, job_equipping_step)
	outfit.shoes = null

// loadout items are indexed by typepath, so this is here to be a placeholder.
/obj/item/clothing/shoes/barefoot
	name = "barefoot"
	icon = null
	icon_state = null
	item_flags = ABSTRACT|DROPDEL
