// Baseball sheathe
/obj/item/storage/belt/baseball
	icon = 'maplestation_modules/icons/obj/clothing/belts.dmi'
	lefthand_file = 'maplestation_modules/icons/mob/inhands/clothes/belts_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/clothes/belts_righthand.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/belt.dmi'
	name = "Bat Sheath"
	desc = "A modified archery quiver meant to make offhand carrying of bats quick and easy."
	icon_state = "baseball_pack"
	inhand_icon_state = "baseball_pack"
	worn_icon_state = "baseball_pack"
	w_class = WEIGHT_CLASS_BULKY
	content_overlays = TRUE

/obj/item/storage/belt/baseball/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.max_w_class = WEIGHT_CLASS_HUGE
	STR.set_holdable(list(
		/obj/item/melee/baseball_bat,
		/obj/item/melee/baseball_bat/homerun,
		/obj/item/melee/baseball_bat/barbed,
		/obj/item/melee/baseball_bat/ablative,
		))

/obj/item/storage/belt/baseball/examine(mob/user)
	. = ..()
	if(length(contents))
		. += "<span class='notice'>Alt-click it to quickly draw the bat.</span>"

/obj/item/storage/belt/baseball/update_icon_state()
	. = ..()
	worn_icon_state = initial(worn_icon_state)
	for(var/obj/item/melee/baseball_bat/bat in contents)
		worn_icon_state += "[bat.belt_sprite]"

/obj/item/storage/belt/baseball/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
		return
	if(length(contents))
		var/obj/item/bat = contents[1]
		user.balloon_alert_to_viewers("unsheathes [bat]")
		user.put_in_hands(bat)
		update_icon()
	else
		balloon_alert(user, "empty")
