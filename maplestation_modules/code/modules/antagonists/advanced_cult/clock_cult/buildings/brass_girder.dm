// Brass girders.
/obj/structure/girder/brass
	name = "brass gear"
	desc = "A girder made out of brass, made to resemble a gear."
	icon = 'maplestation_modules/icons/obj/clockwork_objects.dmi'
	icon_state = "wall_gear"
	can_displace = FALSE

/obj/structure/girder/brass/Initialize(mapload)
	. = ..()
	new /obj/effect/temp_visual/brass/girder(loc)
	ADD_CLOCKCULT_FILTER(src)

/obj/structure/girder/brass/Destroy()
	REMOVE_CLOCKCULT_FILTER(src)
	return ..()

/obj/structure/girder/brass/attackby(obj/item/weapon, mob/user, params)
	add_fingerprint(user)
	if(weapon.tool_behaviour == TOOL_WELDER)
		if(!weapon.tool_start_check(user, amount = 0))
			return

		to_chat(user, span_notice("You start slicing apart the girder..."))
		if(weapon.use_tool(src, user, 4 SECONDS, volume = 50))
			to_chat(user, span_notice("You slice apart the girder."))
			deconstruct()

	else if(istype(weapon, /obj/item/stack/sheet/brass))
		var/obj/item/stack/sheet/material = weapon
		if(material.get_amount() < 1)
			to_chat(user, span_warning("You need at least one sheet of [weapon] to construct a wall!"))
			return
		user.visible_message(span_notice("[user] begins laying [weapon] on [src]..."), span_notice("You begin constructing a wall..."))
		if(do_after(user, 5 SECONDS, target = src))
			if(material.get_amount() < 1)
				return
			user.visible_message(span_notice("[user] plates [src] with [weapon]."), span_notice("You construct a wall."))
			material.use(1)
			var/turf/our_turf = get_turf(src)
			our_turf.PlaceOnTop(/turf/closed/wall/mineral/brass)
			qdel(src)

	else
		return ..()

/obj/structure/girder/brass/narsie_act(force, ignore_mobs, probability) // what that dog doin'?
	return

/obj/structure/girder/brass/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/brass(drop_location(), 1)
	qdel(src)

// And brass walls.
/turf/closed/wall/mineral/brass
	name = "brass clockwork wall"
	desc = "A brass wall engraved with meticulous symbols. Studying them causes you to feel slightly ill."
	icon = 'icons/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall-0"
	base_icon_state = "clockwork_wall"
	turf_flags = NONE
	smoothing_flags = SMOOTH_BITMASK
	canSmoothWith = null
	sheet_type = /obj/item/stack/sheet/brass
	sheet_amount = 1
	girder_type = /obj/structure/girder/brass

/turf/closed/wall/mineral/brass/Initialize(mapload)
	. = ..()
	new /obj/effect/temp_visual/brass/wall(src)
	ADD_CLOCKCULT_FILTER(src)

/turf/closed/wall/mineral/brass/Destroy()
	REMOVE_CLOCKCULT_FILTER(src)
	return ..()

/turf/closed/wall/mineral/brass/examine(mob/user)
	. = ..()
	if(isliving(user) && !IS_CULTIST(user)) // Non-cultist get a lil woozy when examining.
		var/mob/living/living_user = user
		if(living_user.dizziness <= 25 && prob(66))
			living_user.dizziness += 10
			. += span_hypnophrase("The shifting symbols cause you to feel dizzy...")

/turf/closed/wall/mineral/brass/narsie_act(force, ignore_mobs, probability)
	return

// Visual effects to make brass girders and walls glow on creation.
/obj/effect/temp_visual/brass/girder
	icon_state = "ratvargearglow"

/obj/effect/temp_visual/brass/wall
	icon_state = "ratvarwallglow"
