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

	var/obj/item/internal_storage

	var/obj/item/default_storage = /obj/item/storage/drone_tools

	var/obj/item/head

	var/obj/item/default_headwear

/datum/language_holder/redtech
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
	change_number_of_hands(4)
	AddComponent(/datum/component/simple_access, SSid_access.get_region_access_list(list(REGION_ALL_GLOBAL)))
	AddComponent(/datum/component/personal_crafting)


/datum/hud/dextrous/dreadnought/New(mob/owner)
	..()
	var/atom/movable/screen/inventory/inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "internal storage"
	inv_box.icon = ui_style
	inv_box.icon_state = "suit_storage"
	inv_box.screen_loc = ui_drone_storage
	inv_box.slot_id = ITEM_SLOT_DEX_STORAGE
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "head/mask"
	inv_box.icon = ui_style
	inv_box.icon_state = "mask"
	inv_box.screen_loc = ui_drone_head
	inv_box.slot_id = ITEM_SLOT_HEAD
	static_inventory += inv_box

/datum/hud/dextrous/dreadnought/persistent_inventory_update()
	if(!mymob)
		return
	var/mob/living/basic/redtechdread/drone = mymob

	if(hud_shown)
		if(!isnull(drone.internal_storage))
			drone.internal_storage.screen_loc = ui_drone_storage
			drone.client.screen += drone.internal_storage
		if(!isnull(drone.head))
			drone.head.screen_loc = ui_drone_head
			drone.client.screen += drone.head
	else
		drone.internal_storage?.screen_loc = null
		drone.head?.screen_loc = null

	..()
