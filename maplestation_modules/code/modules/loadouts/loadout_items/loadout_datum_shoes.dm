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
	supports_digitigrade = !!(initial(item_path.supports_variations_flags) & (CLOTHING_DIGITIGRADE_VARIATION|CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON))
	if(supports_digitigrade)
		LAZYADD(additional_displayed_text, "Digitigrade")

// This is snowflake but digitigrade is in general
// Need to handle shoes that don't fit digitigrade being selected
// Ideally would be generalized with species can equip or something but OH WELL
/datum/loadout_item/shoes/on_equip_item(
	obj/item/equipped_item,
	datum/preferences/preference_source,
	list/preference_list,
	mob/living/carbon/human/equipper,
	visuals_only = FALSE,
)
	// Supports digi = needs no special handling so we can continue as normal
	if(supports_digitigrade)
		return ..()

	// Does not support digi and our equipper is? We shouldn't mess with it, skip
	if(equipper.bodytype & BODYTYPE_DIGITIGRADE)
		return

	// Does not support digi and our equipper is not digi? Continue as normal
	return ..()

/datum/loadout_item/shoes/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, job_equipping_step = FALSE)
	outfit.shoes = item_path

/datum/loadout_item/shoes/jackboots
	name = "Jackboots"
	item_path = /obj/item/clothing/shoes/jackboots/loadout

/datum/loadout_item/shoes/winter_boots
	name = "Winter Boots"
	item_path = /obj/item/clothing/shoes/winterboots

/datum/loadout_item/shoes/work_boots
	name = "Work Boots"
	item_path = /obj/item/clothing/shoes/workboots

/datum/loadout_item/shoes/mining_boots
	name = "Mining Boots"
	item_path = /obj/item/clothing/shoes/workboots/mining

/datum/loadout_item/shoes/laceup
	name = "Laceup Shoes"
	item_path = /obj/item/clothing/shoes/laceup

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

/datum/loadout_item/shoes/blacksandals
	name = "Black Sandals"
	item_path = /obj/item/clothing/shoes/sandal/black

/datum/loadout_item/shoes/trainers
	name = "Workout Trainers"
	item_path = /obj/item/clothing/shoes/trainers

/datum/loadout_item/shoes/sneaker
	name = "Casual Sneakers"
	item_path = /obj/item/clothing/shoes/trainers/casual

/datum/loadout_item/shoes/heels
	name = "High Heels"
	item_path = /obj/item/clothing/shoes/heels

/datum/loadout_item/shoes/fancy_heels
	name = "Fancy High Heels"
	item_path = /obj/item/clothing/shoes/heels/fancy

/datum/loadout_item/shoes/mrashoes
	name = "Malheur Research Association boots"
	item_path = /obj/item/clothing/shoes/mrashoes
	additional_displayed_text = list("Character Item")

/datum/loadout_item/shoes/reshiaboot
	name = "Short Brown Boots"
	item_path = /obj/item/clothing/shoes/reshiaboot

/datum/loadout_item/shoes/grey
	name = "Designer Boots"
	item_path = /obj/item/clothing/shoes/greyboots

/datum/loadout_item/shoes/lini
	name = "Berbier Boots"
	item_path = /obj/item/clothing/shoes/liniboots
	additional_displayed_text = list("Character Item")
