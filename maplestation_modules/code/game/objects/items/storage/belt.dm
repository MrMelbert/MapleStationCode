// Sheathe Base Type
/obj/item/storage/belt/sheathe
	icon = 'maplestation_modules/icons/obj/clothing/belts.dmi'
	lefthand_file = 'maplestation_modules/icons/mob/inhands/clothes/belts_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/clothes/belts_righthand.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/belt.dmi'
	name = "Sheathe Basetype Item"
	desc = "Whoa there buddy! You've got the Sheathe Basetype, if you're looking for the captain's sheathe, try /obj/item/storage/belt/sabre !" // this will be changed if i bother to post this refactor to tg
	var/altclick_tip = "Altclick to draw the ITEM"
	icon_state = "baseball_pack"
	inhand_icon_state = "baseball_pack"
	worn_icon_state = "baseball_pack"
	w_class = WEIGHT_CLASS_BULKY
	content_overlays = TRUE
	interaction_flags_click = NEED_HANDS|FORBID_TELEKINESIS_REACH
	var/list/storable_items = list()
	var/max_weight_class = WEIGHT_CLASS_HUGE

/obj/item/storage/belt/sheathe/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	atom_storage.max_slots = 1
	atom_storage.max_specific_storage = max_weight_class
	atom_storage.set_holdable(storable_items)

/obj/item/storage/belt/sheathe/examine(mob/user)
	. = ..()
	if(length(contents))
		. += span_notice(altclick_tip)

/obj/item/storage/belt/sheathe/click_alt(mob/user)
	if(length(contents))
		var/obj/item/sheatheditem = contents[1]
		user.balloon_alert_to_viewers("unsheathes [sheatheditem]")
		user.put_in_hands(sheatheditem)
		update_icon()
	else
		balloon_alert(user, "empty!")
		return CLICK_ACTION_BLOCKING
	return CLICK_ACTION_SUCCESS

/obj/item/storage/belt/sheathe/update_icon_state()
	icon_state = initial(icon_state)
	inhand_icon_state = initial(inhand_icon_state)
	worn_icon_state = initial(worn_icon_state)
	return ..()

// baseball bat sheathe
/obj/item/storage/belt/sheathe/baseball
	icon = 'maplestation_modules/icons/obj/clothing/belts.dmi'
	lefthand_file = 'maplestation_modules/icons/mob/inhands/clothes/belts_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/clothes/belts_righthand.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/belt.dmi'
	name = "Bat Sheath"
	desc = "A modified archery quiver meant to make offhand carrying of bats quick and easy."
	altclick_tip = "Altclick to draw the bat"
	icon_state = "baseball_pack"
	inhand_icon_state = "baseball_pack"
	worn_icon_state = "baseball_pack"
	w_class = WEIGHT_CLASS_BULKY
	content_overlays = TRUE
	storable_items = list(
		/obj/item/melee/baseball_bat,
		/obj/item/melee/baseball_bat/homerun,
		/obj/item/melee/baseball_bat/barbed,
		/obj/item/melee/baseball_bat/ablative,
		/obj/item/melee/baseball_bat/golden,
	)
	max_weight_class = WEIGHT_CLASS_HUGE

/obj/item/storage/belt/sheathe/baseball/update_icon_state()
	. = ..()
	for(var/obj/item/melee/baseball_bat/bat in contents)
		worn_icon_state += "[bat.belt_sprite]"

// Add to leather recipes
// We should genericize this in the future for modular recipes in general
/obj/item/stack/sheet/leather/get_main_recipes()
	. = ..()
	. += list(new /datum/stack_recipe("bat sheathe", /obj/item/storage/belt/sheathe/baseball, 4))
