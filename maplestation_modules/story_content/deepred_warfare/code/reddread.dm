#define DREAD_TOTAL_LAYERS 2
#define DREAD_HEAD_LAYER 1
#define DREAD_NECK_LAYER 2

/mob/living/basic/redtechdread
	name = "Redtech Dreadnought Pattern"
	desc = "A terrifying robotic multi-limbed monstrosity, covered in armour plating."
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/reddreadnought64.dmi'
	icon_state = "dreadnought_active"
	icon_living = "dreadnought_active"
	icon_dead = "dreadnought_dead"
	health_doll_icon = "dreadnought_active"
	pixel_x = -16
	base_pixel_x = -16
	health = 1000 // On par with Lavaland elites.
	maxHealth = 1000
	unsuitable_atmos_damage = 0
	unsuitable_cold_damage = 0
	unsuitable_heat_damage = 0
	speed = 1 // Change later, maybe.
	density = TRUE
	pass_flags = NONE
	sight = SEEMOBS | SEE_TURFS | SEE_OBJS // Change later, maybe.
	status_flags = NONE
	gender = PLURAL
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

	move_force = MOVE_FORCE_NORMAL
	move_resist = MOVE_FORCE_STRONG
	pull_force = MOVE_FORCE_NORMAL

	var/heavy_emp_damage = 120 // If the EMP is heavy, the pattern is damaged by this value.
	var/light_emp_damage = 40 // The pattern is damaged by this value when hit by an EMP.

	var/hands = 4

	var/list/dread_overlays[DREAD_TOTAL_LAYERS]

	var/obj/item/back_storage // Only used to hold the red lightning container.

	var/obj/item/default_storage = /obj/item/reagent_containers/cup/beaker/redlightning/filled

	var/obj/item/belt_storage // Can also hold anything.

	var/obj/item/default_belt = /obj/item/storage/dread_storage

	var/obj/item/neck // Only used to hold the cloak.

	var/obj/item/default_neckwear = /obj/item/clothing/neck/cloak/redtech_dread

	var/obj/item/head // Multipurpose for masks and hats.

	var/obj/item/default_headwear

	/// Actions to grant on spawn
	var/static/list/actions_to_add = list(
		/datum/action/cooldown/spell/emp/eldritch = BB_GENERIC_ACTION,
		/datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash = null,
		/datum/action/cooldown/spell/shapeshift/eldritch = BB_SHAPESHIFT_ACTION,
	)

	var/RLEnergy = 100 // Red lightning reserves.

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

	add_traits(list(TRAIT_WEATHER_IMMUNE,
					TRAIT_NO_PLASMA_TRANSFORM,
					TRAIT_KNOW_ROBO_WIRES,
					TRAIT_MADNESS_IMMUNE,
					TRAIT_NO_SOUL,
					TRAIT_PLANT_SAFE,
					TRAIT_QUICKER_CARRY,
					TRAIT_STRONG_GRABBER,
					TRAIT_SURGEON,
					TRAIT_RESEARCH_SCANNER,
					TRAIT_REAGENT_SCANNER,
					TRAIT_GOOD_HEARING,
					TRAIT_FEARLESS,
					TRAIT_FASTMED,
					TRAIT_NOFIRE,
					TRAIT_PUSHIMMUNE,
					TRAIT_FIST_MINING,
					TRAIT_NEGATES_GRAVITY,
					TRAIT_LITERATE,
					TRAIT_KNOW_ENGI_WIRES,
					TRAIT_ADVANCEDTOOLUSER,
					TRAIT_CAN_STRIP), INNATE_TRAIT)

	if(default_storage)
		var/obj/item/storage = new default_storage(src)
		equip_to_slot_or_del(storage, ITEM_SLOT_BACK)

	if(default_belt)
		var/obj/item/storage = new default_belt(src)
		equip_to_slot_or_del(storage, ITEM_SLOT_BELT)

	if(default_neckwear)
		var/obj/item/storage = new default_neckwear(src)
		equip_to_slot_or_del(storage, ITEM_SLOT_NECK)

	if(default_headwear)
		var/obj/item/storage = new default_headwear(src)
		equip_to_slot_or_del(storage, ITEM_SLOT_HEAD)

	grant_actions_by_list(actions_to_add)

/datum/hud/dextrous/dreadnought/New(mob/owner)
	..()
	var/atom/movable/screen/inventory/inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "internal red lightning storage"
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
	inv_box.name = "cloak"
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
			if(!(istype(item, /obj/item/clothing/neck/cloak/redtech_dread)))
				return FALSE
			return TRUE
		if(ITEM_SLOT_BELT)
			if(belt_storage)
				return FALSE
			return TRUE
		if(ITEM_SLOT_BACK)
			if(back_storage)
				return FALSE
			if(!(istype(item, /obj/item/reagent_containers/cup/beaker/redlightning)))
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

/mob/living/basic/redtechdread/get_slot_by_item(obj/item/looking_for)
	if(back_storage == looking_for)
		return ITEM_SLOT_BACK
	if(belt_storage == looking_for)
		return ITEM_SLOT_BELT
	if(neck == looking_for)
		return ITEM_SLOT_NECK
	if(head == looking_for)
		return ITEM_SLOT_HEAD
	return ..()

/mob/living/basic/redtechdread/equip_to_slot(obj/item/equipping, slot, initial = FALSE, redraw_mob = FALSE, indirect_action = FALSE)
	if(!slot)
		return
	if(!istype(equipping))
		return

	var/index = get_held_index_of_item(equipping)
	if(index)
		held_items[index] = null
	update_held_items()

	if(equipping.pulledby)
		equipping.pulledby.stop_pulling()

	equipping.screen_loc = null // will get moved if inventory is visible
	equipping.forceMove(src)
	SET_PLANE_EXPLICIT(equipping, ABOVE_HUD_PLANE, src)

	switch(slot)
		if(ITEM_SLOT_HEAD)
			head = equipping
			update_worn_head()
		if(ITEM_SLOT_NECK)
			neck = equipping
			update_worn_neck()
		if(ITEM_SLOT_BELT)
			belt_storage = equipping
			update_worn_belt()
		if(ITEM_SLOT_BACK)
			back_storage = equipping
			update_worn_back()
		else
			to_chat(src, span_danger("You are trying to equip this item to an unsupported inventory slot. Report this to a coder!"))
			return

	//Call back for item being equipped to drone
	equipping.on_equipped(src, slot)

/mob/living/basic/redtechdread/update_clothing(slot_flags)
	if(slot_flags & ITEM_SLOT_HEAD)
		update_worn_head()
	if(slot_flags & ITEM_SLOT_MASK)
		update_worn_mask()
	if(slot_flags & ITEM_SLOT_NECK)
		update_worn_neck()
	if(slot_flags & ITEM_SLOT_BELT)
		update_worn_belt()
	if(slot_flags & ITEM_SLOT_HANDS)
		update_held_items()
	if(slot_flags & (ITEM_SLOT_HANDS|ITEM_SLOT_BACKPACK|ITEM_SLOT_BACK))
		update_worn_back()

/mob/living/basic/redtechdread/proc/apply_overlay(cache_index)
	if((. = dread_overlays[cache_index]))
		add_overlay(.)

/mob/living/basic/redtechdread/proc/remove_overlay(cache_index)
	var/overlay = dread_overlays[cache_index]
	if(overlay)
		cut_overlay(overlay)
		dread_overlays[cache_index] = null

/mob/living/basic/redtechdread/update_worn_head()
	remove_overlay(DREAD_HEAD_LAYER)

	if(head)
		if(client && hud_used?.hud_shown)
			head.screen_loc = ui_sstore1
			client.screen += head
		var/used_head_icon = 'icons/mob/clothing/head/utility.dmi'
		if(istype(head, /obj/item/clothing/mask))
			used_head_icon = 'icons/mob/clothing/mask.dmi'
		var/mutable_appearance/head_overlay = head.build_worn_icon(default_layer = DREAD_HEAD_LAYER, default_icon_file = used_head_icon)
		// head_overlay.pixel_y -= 15

		dread_overlays[DREAD_HEAD_LAYER] = head_overlay

	apply_overlay(DREAD_HEAD_LAYER)

/mob/living/basic/redtechdread/update_worn_mask()
	update_worn_head()

/mob/living/basic/redtechdread/update_worn_neck()
	remove_overlay(DREAD_NECK_LAYER)

	if(neck)
		if(client && hud_used?.hud_shown)
			neck.screen_loc = ui_id
			client.screen += neck
		var/used_neck_icon = 'maplestation_modules/story_content/deepred_warfare/icons/dreadclothing.dmi'
		var/obj/item/force_cloak = new /obj/item/clothing/neck/cloak/redtech_dread/pattern
		var/mutable_appearance/neck_overlay = force_cloak.build_worn_icon(default_layer = DREAD_NECK_LAYER, default_icon_file = used_neck_icon)
		// head_overlay.pixel_y -= 15

		dread_overlays[DREAD_NECK_LAYER] = neck_overlay

	apply_overlay(DREAD_NECK_LAYER)
	update_naming_status()

/mob/living/basic/redtechdread/update_worn_back()
	if(back_storage && client && hud_used?.hud_shown)
		back_storage.screen_loc = ui_back
		client.screen += back_storage

/mob/living/basic/redtechdread/update_worn_belt()
	if(belt_storage && client && hud_used?.hud_shown)
		belt_storage.screen_loc = ui_belt
		client.screen += belt_storage

/mob/living/basic/redtechdread/regenerate_icons()
	// FUCK.
	update_held_items()
	update_worn_head()
	update_worn_neck()
	update_worn_belt()
	update_worn_back()

/mob/living/basic/redtechdread/proc/update_naming_status()
	if(neck)
		if(head)
			name = "The Collector"
			desc = "An enigmatic and imposing masked figure. They are quite large."
			return
		name = "The Collector"
		desc = "An enigmatic and imposing mechanical figure. Their face can only be described as half sensor array, half volley gun."
		return
	name = "Redtech Dreadnought Pattern"
	desc = "A terrifying robotic multi-limbed monstrosity, covered in armour plating. By looking at their face, you are staring down almost a dozen barrels."

/mob/living/basic/redtechdread/emp_reaction(severity)
	if(health < 450)
		return

	visible_message(span_danger("[src] shudders for a moment."))
	Shake(duration = 1 SECONDS)
	switch(severity)
		if(EMP_LIGHT)
			apply_damage(light_emp_damage)
			to_chat(src, span_danger("EMP DETECTED: DAMAGE TO HARDWARE"))
		if(EMP_HEAVY)
			apply_damage(heavy_emp_damage)
			to_chat(src, span_userdanger("WARNING: HEAVY DAMAGE TO HARDWARE"))

/mob/living/basic/redtechdread/electrocute_act(shock_damage, source, siemens_coeff, flags = NONE)
	return FALSE

/mob/living/basic/redtechdread/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /atom/movable/screen/fullscreen/flash, length = 25)
	if(affect_silicon)
		return ..()

/mob/living/basic/redtechdread/examine(mob/user)
	. = list("<span class='info'>This is [icon2html(src, user)] \a <b>[src]</b>!")

	//Hands
	for(var/obj/item/held_thing in held_items)
		if(held_thing.item_flags & (ABSTRACT|EXAMINE_SKIP|HAND_ITEM))
			continue
		. += "They have [held_thing.get_examine_string(user)] in their [get_held_index_name(get_held_index_of_item(held_thing))]."

	if(!neck) // If the cloak is not worn, show the internal storage.
		//Back storage
		if(back_storage && !(back_storage.item_flags & ABSTRACT))
			. += "They are holding [back_storage.get_examine_string(user)] in their reactor port."

		//Belt storage
		if(belt_storage && !(belt_storage.item_flags & ABSTRACT))
			. += "They are holding [belt_storage.get_examine_string(user)] in their storage compartment."

	//Neckwear
	if(neck && !(neck.item_flags & ABSTRACT))
		. += "They are wearing [neck.get_examine_string(user)]."

	//Cosmetic hat - provides no function other than looks
	if(head && !(head.item_flags & ABSTRACT))
		. += "They are wearing [head.get_examine_string(user)] on their head."

	//Braindead
	if(!client && stat != DEAD)
		. += "They appear to be currently disconnected."

	//Damaged
	if(health != maxHealth) // Note to self, change description if it is wearing a cloak.
		if(health > maxHealth * 0.33)
			if(neck)
				. += span_warning("They make a metallic grinding noise when they move.")
			else
				. += span_warning("Their armour plates are slightly damaged.")
		else //otherwise, below about 33%
			if(neck)
				. += span_warning("Occasional sparks fly from out under their cloak.")
			else
				. += span_boldwarning("Their armour plates are heavily damaged!")

	//Dead
	if(stat == DEAD)
		if(client)
			. += span_deadsay("Their systems have been shut down.")
		else
			. += span_deadsay("They are about as useful as a heap of scrap metal now.")
	. += "</span>"
