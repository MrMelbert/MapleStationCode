/obj/structure/tipjar
	name = "tip jar"
	desc = "I can't believe tipping culture made its way to the stars."
	icon = 'maplestation_modules/icons/obj/tipjar.dmi'
	icon_state = "jar"
	density = FALSE
	anchored = TRUE
	resistance_flags = ACID_PROOF
	max_integrity = 100
	custom_materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2)
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX

	var/static/list/tippable_typecache = typecacheof(list(
		/obj/item/card,
		/obj/item/coin,
		/obj/item/documents,
		/obj/item/folder,
		/obj/item/holochip,
		/obj/item/paper,
		/obj/item/paperwork,
		/obj/item/photo,
		/obj/item/stack/spacecash,
	))

	var/static/alist/pos_map = list(
		1 = list(-3, -9),
		2 = list( 3, -9),
		3 = list( 0, -8),
		4 = list(-3, -7),
		5 = list( 3, -7),
		6 = list( 0, -6),
		7 = list(-3, -5),
		8 = list( 3, -5),
		9 = list( 0, -4),
	)

	var/static/list/crack_states = list()

	var/prefilled = FALSE

	var/glass_type = /obj/item/stack/sheet/glass
	var/shard_type = /obj/item/shard

/obj/structure/tipjar/Initialize(mapload)
	. = ..()
	if(!length(crack_states))
		for(var/i in 1 to 9)
			crack_states += "crack[i]"

	AddElement(/datum/element/crackable, 'icons/obj/pipes_n_cables/stationary_canisters.dmi', crack_states)
	if(prefilled)
		if(prob(8))
			for(var/i in 1 to rand(1, 4))
				new /obj/effect/spawner/random/entertainment/coin(src)
		if(prob(4))
			for(var/i in 1 to rand(1, 3))
				new /obj/effect/spawner/random/entertainment/money_small(src)
		if(prob(1))
			for(var/i in 1 to rand(1, 2))
				new /obj/effect/spawner/random/entertainment/money(src)
	update_appearance()

/obj/structure/tipjar/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(is_type_in_typecache(tool, tippable_typecache))
		if(length(contents) >= 24)
			balloon_alert(user, "it's full!")
			return ITEM_INTERACT_BLOCKING
		if(user.transferItemToLoc(tool, src))
			balloon_alert_to_viewers("deposited \a [tool]")
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING

	return NONE

/obj/structure/tipjar/examine(mob/user)
	. = ..()
	var/list/all_things = list()
	for(var/obj/item/thing in src)
		all_things["\A [thing]"] += 1

	for(var/thing_name in all_things)
		if(all_things[thing_name] > 1)
			// we have to remove the "an" or "some" and pluralize it ourselves
			var/list/split_name = splittext(thing_name, " ")
			var/reformatted_name = jointext(split_name, " ", 2)
			all_things += "[all_things[thing_name]] [reformatted_name][plural_s(reformatted_name)]"
			all_things -= thing_name

	. += span_info("Inside, you can see: [english_list(all_things)].")

/obj/structure/tipjar/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user.CanReach(src))
		return
	user.visible_message(
		span_notice("[user] starts fishing around in [src]..."),
		span_notice("You start fishing around in [src]..."),
	)
	Shake(1, 1, 5 SECONDS, 0.1 SECONDS)
	if(!do_after(user, 5 SECONDS, src) || !length(contents))
		animate(src)
		pixel_x = base_pixel_x
		pixel_y = base_pixel_y
		return

	var/obj/item/fished_out = pick(contents)
	user.visible_message(
		span_notice("[user] pulls [fished_out] out of [src]!"),
		span_notice("You pull [fished_out] out of [src]."),
	)
	user.put_in_hands(fished_out)

/obj/structure/tipjar/dump_contents()
	for(var/obj/item/thing in src)
		thing.forceMove(drop_location())
		thing.pixel_x += rand(-4, 4)
		thing.pixel_y += rand(-4, 4)

/obj/structure/tipjar/handle_deconstruct(disassembled)
	. = ..()
	dump_contents()

/obj/structure/tipjar/atom_deconstruct(disassembled = TRUE)
	if(disassembled)
		new glass_type(drop_location(), SHEET_MATERIAL_AMOUNT * 2)
		playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
	else
		for(var/i in 1 to 2)
			new shard_type(drop_location())
		playsound(src, SFX_SHATTER, 50, TRUE)

/obj/structure/tipjar/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, TRUE)

/obj/structure/tipjar/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	update_appearance()
	RegisterSignal(arrived, COMSIG_STACK_CAN_MERGE, PROC_REF(block_merging))

/obj/structure/tipjar/Exited(atom/movable/gone, direction)
	. = ..()
	update_appearance()
	UnregisterSignal(gone, COMSIG_STACK_CAN_MERGE)

/obj/structure/tipjar/proc/block_merging(mob/living/user, atom/movable/other)
	SIGNAL_HANDLER
	return CANCEL_STACK_MERGE

/obj/structure/tipjar/update_overlays()
	. = ..()

	for(var/i in 1 to min(length(contents), length(pos_map)))
		var/obj/item/thing = contents[i]
		var/image/content_overlay = image(thing, src)

		content_overlay.transform = content_overlay.transform.Scale(0.5)
		content_overlay.pixel_x = 0
		content_overlay.pixel_y = 0
		content_overlay.pixel_w = pos_map[i][1]
		content_overlay.pixel_z = pos_map[i][2]
		content_overlay.layer = FLOAT_LAYER
		content_overlay.plane = FLOAT_PLANE

		. += content_overlay

	. += "jar_overlay"

/obj/structure/tipjar/prefilled
	prefilled = TRUE

/obj/structure/tipjar/plasma
	max_integrity = 300
	custom_materials = list(/datum/material/alloy/plasmaglass = SHEET_MATERIAL_AMOUNT * 2)
	glass_type = /obj/item/stack/sheet/plasmaglass
	shard_type = /obj/item/shard/plasma
