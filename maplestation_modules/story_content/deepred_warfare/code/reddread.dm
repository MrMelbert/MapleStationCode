/mob/living/basic/redtechdread
	name = "Redtech Dreadnought Pattern"
	desc = "A terrifying robotic multi-limbed monstrosity, covered in armour plating. It would be wise to start running."
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/reddreadnought64.dmi'
	icon_state = "dreadnought_active"
	icon_living = "dreadnought_active"
	icon_dead = "dreadnought_dead"
	pixel_x = -16
	base_pixel_x = -16
	health = 450
	maxHealth = 450
	unsuitable_atmos_damage = 0
	unsuitable_cold_damage = 0
	unsuitable_heat_damage = 0
	speed = 1 // Change later, maybe.
	density = TRUE
	pass_flags = NONE
	sight = SEEMOBS | SEE_TURFS | SEE_OBJS // Change later, maybe.
	status_flags = NONE
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC | MOB_SPECIAL
	speak_emote = list("grinds")
	speech_span = SPAN_ROBOT
	bubble_icon = "machine"
	initial_language_holder = /datum/language_holder/redtech
	mob_size = MOB_SIZE_LARGE
	has_unlimited_silicon_privilege = TRUE // Change later, maybe.
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, STAMINA = 0, OXY = 0)
	faction = list(FACTION_DEEPRED)
	hud_type = /datum/hud/dextrous/dreadnought

	var/heavy_emp_damage = 25
	var/hands = 4

	var/obj/item/back_storage // Can hold anything.

	var/obj/item/default_storage

	var/obj/item/belt_storage // Can also hold anything.

	var/obj/item/default_belt

	var/obj/item/neck

	var/obj/item/default_neckwear

	var/obj/item/head

	var/obj/item/default_headwear

/datum/language_holder/redtech // Literally just the TG silicon language list.
	understood_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/uncommon = list(LANGUAGE_ATOM),
		/datum/language/machine = list(LANGUAGE_ATOM),
		/datum/language/draconic = list(LANGUAGE_ATOM),
		/datum/language/moffic = list(LANGUAGE_ATOM),
		/datum/language/calcic = list(LANGUAGE_ATOM),
		/datum/language/voltaic = list(LANGUAGE_ATOM),
		/datum/language/nekomimetic = list(LANGUAGE_ATOM),
	)
	spoken_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/uncommon = list(LANGUAGE_ATOM),
		/datum/language/machine = list(LANGUAGE_ATOM),
		/datum/language/draconic = list(LANGUAGE_ATOM),
		/datum/language/moffic = list(LANGUAGE_ATOM),
		/datum/language/calcic = list(LANGUAGE_ATOM),
		/datum/language/voltaic = list(LANGUAGE_ATOM),
		/datum/language/nekomimetic = list(LANGUAGE_ATOM),
	)

/mob/living/basic/redtechdread/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dextrous, hud_type = hud_type)
	AddComponent(/datum/component/basic_inhands, y_offset = 0)
	change_number_of_hands(hands)
	AddComponent(/datum/component/simple_access, SSid_access.get_region_access_list(list(REGION_ALL_GLOBAL)))
	AddComponent(/datum/component/personal_crafting)

	add_traits(list(TRAIT_WEATHER_IMMUNE, TRAIT_NO_PLASMA_TRANSFORM, TRAIT_KNOW_ROBO_WIRES, TRAIT_MADNESS_IMMUNE, TRAIT_NO_SOUL, TRAIT_PLANT_SAFE, TRAIT_QUICKER_CARRY, TRAIT_STRONG_GRABBER, TRAIT_SURGEON, TRAIT_RESEARCH_SCANNER, TRAIT_REAGENT_SCANNER, TRAIT_GOOD_HEARING, TRAIT_FEARLESS, TRAIT_FASTMED, TRAIT_NOFIRE, TRAIT_PUSHIMMUNE, TRAIT_FIST_MINING, TRAIT_NEGATES_GRAVITY, TRAIT_LITERATE, TRAIT_KNOW_ENGI_WIRES, TRAIT_ADVANCEDTOOLUSER, TRAIT_CAN_STRIP), INNATE_TRAIT)

/datum/hud/dextrous/dreadnought/New(mob/owner)
	..()
	var/atom/movable/screen/inventory/inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "internal back storage"
	inv_box.icon = ui_style
	inv_box.icon_state = "back"
	inv_box.screen_loc = ui_back
	inv_box.slot_id = ITEM_SLOT_BACK
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "internal belt storage"
	inv_box.icon = ui_style
	inv_box.icon_state = "belt"
	inv_box.screen_loc = ui_belt
	inv_box.slot_id = ITEM_SLOT_BELT
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "neck"
	inv_box.icon = ui_style
	inv_box.icon_state = "neck"
	inv_box.screen_loc = ui_id
	inv_box.slot_id = ITEM_SLOT_NECK
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "head/mask"
	inv_box.icon = ui_style
	inv_box.icon_state = "mask"
	inv_box.screen_loc = ui_sstore1
	inv_box.slot_id = ITEM_SLOT_HEAD
	static_inventory += inv_box

/datum/hud/dextrous/dreadnought/persistent_inventory_update()
	if(!mymob)
		return
	var/mob/living/basic/redtechdread/drone = mymob

	if(hud_shown)
		if(!isnull(drone.back_storage))
			drone.back_storage.screen_loc = ui_back
			drone.client.screen += drone.back_storage
		if(!isnull(drone.belt_storage))
			drone.belt_storage.screen_loc = ui_belt
			drone.client.screen += drone.belt_storage
		if(!isnull(drone.neck))
			drone.neck.screen_loc = ui_id
			drone.client.screen += drone.neck
		if(!isnull(drone.head))
			drone.head.screen_loc = ui_sstore1
			drone.client.screen += drone.head
	else
		drone.back_storage?.screen_loc = null
		drone.belt_storage?.screen_loc = null
		drone.neck?.screen_loc = null
		drone.head?.screen_loc = null
	..()

/mob/living/basic/redtechdread/doUnEquip(obj/item/item, force, newloc, no_move, invdrop = TRUE, silent = FALSE)
	if(..())
		update_held_items()
		if(item == head)
			head = null
			update_worn_head()
		if(item == neck)
			neck = null
			update_worn_neck()
		if(item == belt_storage)
			belt_storage = null
			update_worn_belt()
		if(item == back_storage)
			back_storage = null
			update_worn_back()
		return TRUE
	return FALSE

/mob/living/basic/redtechdread/can_equip(obj/item/item, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE, ignore_equipped = FALSE, indirect_action = FALSE)
	switch(slot)
		if(ITEM_SLOT_HEAD)
			if(head)
				return FALSE
			if(!((item.slot_flags & ITEM_SLOT_HEAD) || (item.slot_flags & ITEM_SLOT_MASK)))
				return FALSE
			return TRUE
		if(ITEM_SLOT_NECK)
			if(neck)
				return FALSE
			if(!(item.slot_flags & ITEM_SLOT_NECK))
				return FALSE
			return TRUE
		if(ITEM_SLOT_BELT)
			if(belt_storage)
				return FALSE
			return TRUE
		if(ITEM_SLOT_BACK)
			if(back_storage)
				return FALSE
			return TRUE
	..()

/mob/living/basic/redtechdread/get_item_by_slot(slot_id)
	switch(slot_id)
		if(ITEM_SLOT_HEAD)
			return head
		if(ITEM_SLOT_NECK)
			return neck
		if(ITEM_SLOT_BELT)
			return belt_storage
		if(ITEM_SLOT_BACK)
			return back_storage

	return ..()
