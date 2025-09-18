/// Ashtrays, for cigarette disposal
/obj/item/ashtray
	name = "ashtray"
	desc = "Free ash?"
	// https://github.com/Baystation12/Baystation12/pull/601 ... I think
	icon = 'maplestation_modules/icons/obj/ashtray.dmi'
	icon_state = "ashtray"
	base_icon_state = "ashtray"
	force = 4
	throwforce = 8
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = /obj/item/plate::drop_sound
	pickup_sound = /obj/item/plate::pickup_sound

/obj/item/ashtray/Initialize(mapload)
	. = ..()
	color ||= pick(
		COLOR_BEIGE,
		COLOR_CENTCOM_BLUE,
		COLOR_BROWNER_BROWN,
		COLOR_GREEN,
		COLOR_ORANGE,
		COLOR_MAROON,
		COLOR_WHITE,
		COLOR_YELLOW,
	)

/obj/item/ashtray/examine(mob/user)
	. = ..()
	switch(length(contents))
		if(0)
			. += span_info("It's empty.")
		if(1 to 9)
			. += span_info("It's mostly empty.")
		if(10 to 14)
			. += span_info("It's half full.")
		if(15 to 23)
			. += span_info("It's nearly full.")
		if(24 to INFINITY)
			. += span_info("It's full.")

/obj/item/ashtray/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(.)
		return
	deconstruct(FALSE)

/obj/item/ashtray/onZImpact(turf/impacted_turf, levels, impact_flags)
	. = ..()
	deconstruct(FALSE)

/obj/item/ashtray/interact_with_atom(atom/interacting_with, mob/living/user)
	if(user.combat_mode)
		return NONE
	if(!length(contents))
		return NONE

	. = NONE
	if(istype(interacting_with, /obj/structure/closet/crate/bin) || istype(interacting_with, /obj/structure/closet/crate/trashcart))
		var/obj/structure/closet/crate/bin = interacting_with
		if(!bin.opened)
			return NONE
		. = ITEM_INTERACT_SUCCESS

	else if(istype(interacting_with, /obj/item/ashtray))
		if(length(interacting_with.contents) + length(contents) > 24)
			interacting_with.balloon_alert(user, "it's full!")
			return ITEM_INTERACT_BLOCKING
		. = ITEM_INTERACT_SUCCESS

	else if(istype(interacting_with, /obj/machinery/disposal/bin))
		. = ITEM_INTERACT_SUCCESS

	if(. & ITEM_INTERACT_SUCCESS)
		user.visible_message(
			span_notice("[user] dumps [src] into [interacting_with]."),
			span_notice("You dump [src] into [interacting_with]."),
		)
		for(var/obj/item/thing in src)
			thing.forceMove(interacting_with)
	return .

/obj/item/ashtray/item_interaction(mob/living/user, obj/item/tool, list/modifiers, is_right_clicking)
	. = ..()
	if(. & ITEM_INTERACT_BLOCKING)
		return .

	if(!istype(tool, /obj/item/cigarette) \
		&& !istype(tool, /obj/item/cigbutt) \
		&& !istype(tool, /obj/item/food/candy_trash) \
		&& !istype(tool, /obj/item/match) \
	)
		return .

	if(length(contents) > 24)
		balloon_alert(user, "it's full!")
		return ITEM_INTERACT_BLOCKING

	if(!user.transferItemToLoc(tool, src, silent = FALSE))
		return ITEM_INTERACT_BLOCKING

	if(!istype(tool, /obj/item/cigarette))
		user.visible_message(
			span_notice("[user] puts [tool] in [src]."),
			span_notice("You put [tool] in [src]."),
		)
		return ITEM_INTERACT_SUCCESS

	var/obj/item/cigarette/cig = tool
	if(cig.lit)
		user.visible_message(
			span_rose("[user] stubs out [user.p_their()] [cig.name] in [src]."),
			span_rose("You stub out your [cig.name] in [src]."),
		)
		var/obj/item/butt = new cig.type_butt(src)
		cig.transfer_fingerprints_to(butt)
		cig.transfer_fibers_to(butt)
		qdel(cig)

	else
		user.visible_message(
			span_notice("[user] puts [user.p_their()] unlit [cig.name] in [src]."),
			span_notice("You put your unlit [cig.name] in [src]...Why?"),
		)

	return ITEM_INTERACT_SUCCESS

/obj/item/ashtray/atom_deconstruct(disassembled)
	dump_contents()
	if(disassembled)
		return ..()

	var/generator/scatter_gen = generator(GEN_CIRCLE, 0, 6, NORMAL_RAND)
	var/atom/drop_loc = drop_location()
	for(var/i in 1 to /obj/item/ashtray_shard::variants)
		var/obj/item/ashtray_shard/shard = new(drop_loc)
		shard.icon_state = "[shard.base_icon_state][i]"
		shard.color = color
		var/list/scatter_vector = scatter_gen.Rand()
		shard.pixel_x = scatter_vector[1]
		shard.pixel_y = scatter_vector[2]
	playsound(drop_loc, 'sound/items/ceramic_break.ogg', 33, TRUE)

/obj/item/ashtray/dump_contents()
	if(!length(contents))
		return

	var/total_butts = 0
	var/atom/drop_loc = drop_location()
	for(var/obj/item/cigbutt/butt in src)
		total_butts += 1
		butt.forceMove(drop_loc)
		butt.pixel_x = rand(-2, 2)
		butt.pixel_y = rand(-2, 2)
	if(total_butts > 12)
		for(var/i in 1 to ceil(total_butts / 12))
			var/obj/effect/decal/cleanable/ash/large/ash = new(drop_loc)
			ash.pixel_x = rand(-5, 5)
			ash.pixel_y = rand(-5, 5)
	else
		for(var/i in 1 to ceil(total_butts / 4))
			var/obj/effect/decal/cleanable/ash/ash = new(drop_loc)
			ash.pixel_x = rand(-4, 4)
			ash.pixel_y = rand(-4, 4)
	for(var/obj/item/whatever_left in src)
		whatever_left.forceMove(drop_loc)

/obj/item/ashtray/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return

	. = TRUE

	if(user.is_holding(src))
		if(length(contents))
			user.visible_message(
				span_notice("[user] dumps [src] out."),
				span_notice("You dump [src] out."),
			)
		else
			user.visible_message(
				span_notice("[user] flips [src] over."),
				span_notice("You flip [src] over."),
			)
	else
		if(length(contents))
			visible_message(
				span_notice("[src] flips itself over, dumping its contents out."),
			)
		else
			visible_message(
				span_notice("[src] flips itself over."),
			)

	dump_contents()

/obj/item/ashtray/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	update_appearance()

/obj/item/ashtray/Exited(atom/movable/gone, direction)
	. = ..()
	update_appearance()

/obj/item/ashtray/update_overlays()
	. = ..()
	switch(length(contents))
		if(1 to 12)
			. += mutable_appearance(icon, "[base_icon_state]_half", appearance_flags = RESET_COLOR)
		if(13 to INFINITY)
			. += mutable_appearance(icon, "[base_icon_state]_full", appearance_flags = RESET_COLOR)

/obj/item/ashtray/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return .

	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	user.visible_message(
		span_notice("[user] starts fishing around in [src]..."),
		span_notice("You start fishing around in [src]..."),
	)
	if(!do_after(user, 3 SECONDS, src))
		return

	if(!length(contents))
		user.visible_message(
			span_notice("[user] finds nothing in [src]."),
			span_notice("You find nothing in [src]."),
		)
		return

	var/obj/item/reward = pick(contents)
	if(istype(reward, /obj/item/cigbutt) && prob(50))
		user.visible_message(
			span_notice("[user] lifts some fingers covered in ash out of [src]."),
			span_notice("You lift some filthy fingers covered in ash out of [src]. Yuck."),
		)
		return

	var/reward_msg = "It's about what you'd expect."
	user.put_in_hands(reward)
	if(istype(reward, /obj/item/cigarette))
		reward_msg = "A free smoke! Score."

	else if(istype(reward, /obj/item/cigarette/cigar))
		reward_msg = "A free cigar! Who left this here?"

	user.visible_message(
		span_notice("[user] finds \a [reward] in [src]."),
		span_notice("You find \a [reward] in [src]. [reward_msg]"),
	)

/obj/item/ashtray/attack(mob/living/target_mob, mob/living/user, params)
	. = ..()
	if(.)
		return

	dump_contents()
	if(prob(66))
		deconstruct(FALSE)

/// Subtype which spawns with random stuff inside
/obj/item/ashtray/random_contents

/obj/item/ashtray/random_contents/Initialize(mapload)
	. = ..()
	var/num_items = prob(1) ? rand(14, 18) : rand(0, 4)
	for(var/i in 1 to num_items)
		switch(rand(1, 100))
			if(1 to 90)
				new /obj/item/cigbutt(src)
			if(90 to 95)
				var/obj/item/match/match = new(src)
				if(prob(90))
					match.lit = TRUE
					match.matchburnout()
			if(95 to 99)
				new /obj/item/cigarette(src)
			if(99 to 100)
				new /obj/item/cigarette/cigar(src)
	update_appearance()

/// Shards for broken ashtrays
/obj/item/ashtray_shard
	name = "ceramic ashtray shard"
	desc = "So no free ash?"
	icon = 'maplestation_modules/icons/obj/ashtray.dmi'
	icon_state = "ashtray_shard1"
	base_icon_state = "ashtray_shard"
	hitsound = 'sound/weapons/bladeslice.ogg'
	w_class = WEIGHT_CLASS_TINY
	force = 5
	throwforce = 4
	sharpness = SHARP_EDGED
	pickup_sound = /obj/item/plate_shard::pickup_sound
	drop_sound = /obj/item/plate_shard::drop_sound
	/// Shard variants that exist in the icon
	var/variants = 4

/obj/item/ashtray_shard/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = 1, max_damage = 3, paralyze_duration = 0.5 SECONDS, soundfile = hitsound)
	icon_state = "[base_icon_state][rand(1, variants)]"
