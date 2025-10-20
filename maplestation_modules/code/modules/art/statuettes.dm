//Copied mostly from statues.dm with edits to apply for an item
/obj/item/statue/custom
	name = "custom statue"
	icon = 'icons/obj/art/statue.dmi'
	icon_state = "base"
	obj_flags = UNIQUE_RENAME
	appearance_flags = TILE_BOUND | PIXEL_SCALE | KEEP_TOGETHER//Added keep together in case targets has weird layering
	w_class = WEIGHT_CLASS_SMALL
	/// primary statue overlay
	var/mutable_appearance/content_ma
	var/static/list/greyscale_with_value_bump = list(0,0,0, 0,0,0, 0,0,1, 0,0,-0.05)

//When out in the world, is tiny like action figures, but can pick up to see better
/obj/item/statue/custom/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/item_scaling, 0.4, 1)
	AddComponent(/datum/component/simple_rotation)

/obj/item/statue/custom/Destroy()
	content_ma = null
	return ..()

/obj/item/statue/custom/proc/set_visuals(model_appearance)
	if(content_ma)
		QDEL_NULL(content_ma)
	content_ma = new
	content_ma.appearance = model_appearance
	content_ma.pixel_x = 0
	content_ma.pixel_y = 0
	content_ma.alpha = 255

	var/static/list/plane_whitelist = list(FLOAT_PLANE, GAME_PLANE, FLOOR_PLANE)

	/// Ideally we'd have knowledge what we're removing but i'd have to be done on target appearance retrieval
	var/list/overlays_to_keep = list()
	for(var/mutable_appearance/special_overlay as anything in content_ma.overlays)
		var/mutable_appearance/real = new()
		real.appearance = special_overlay
		if(PLANE_TO_TRUE(real.plane) in plane_whitelist)
			overlays_to_keep += real
	content_ma.overlays = overlays_to_keep

	var/list/underlays_to_keep = list()
	for(var/mutable_appearance/special_underlay as anything in content_ma.underlays)
		var/mutable_appearance/real = new()
		real.appearance = special_underlay
		if(PLANE_TO_TRUE(real.plane) in plane_whitelist)
			underlays_to_keep += real
	content_ma.underlays = underlays_to_keep

	content_ma.appearance_flags &= ~KEEP_APART //Don't want this
	content_ma.filters = filter(type="color",color=greyscale_with_value_bump,space=FILTER_COLOR_HSV)
	content_ma.plane = FLOAT_PLANE
	content_ma.layer = FLOAT_LAYER
	update_appearance()

/obj/item/modeling_block/update_overlays()
	. = ..()
	if(!target_appearance_with_filters)
		return
	//We're only keeping one instance here that changes in the middle so we have to clone it to avoid managed overlay issues
	var/mutable_appearance/clone = new(target_appearance_with_filters)
	. += clone

/obj/item/statue/custom/update_overlays()
	. = ..()
	if(content_ma)
		. += content_ma

//Inhand version of a carving block that doesnt need a chisel
/obj/item/modeling_block
	name = "Modeling block"
	desc = "Ready for sculpting. Look for a subject and use in hand to sculpt."
	icon = 'icons/obj/art/statue.dmi'
	icon_state = "block"
	w_class = WEIGHT_CLASS_SMALL

	/// The thing it will look like - Unmodified resulting statue appearance
	var/current_target
	/// Currently chosen preset statue type
	var/current_preset_type
	/// statue completion from 0 to 1.0
	var/completion = 0
	/// Greyscaled target with cutout filter
	var/mutable_appearance/target_appearance_with_filters
	/// HSV color filters parameters
	var/static/list/greyscale_with_value_bump = list(0,0,0, 0,0,0, 0,0,1, 0,0,-0.05)

	//Adding chisel vars
	/// Block we're currently carving in
	var/obj/item/modeling_block/prepared_block
	/// If tracked user moves we stop sculpting
	var/mob/living/tracked_user
	/// Currently sculpting
	var/sculpting = FALSE

/obj/item/modeling_block/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/item_scaling, 0.4, 1)

// Add to plastic recipes
/obj/item/stack/sheet/plastic/get_main_recipes()
	. = ..()
	. += list(new /datum/stack_recipe("Modeling block", /obj/item/modeling_block, 2, crafting_flags = NONE))


/obj/item/modeling_block/Destroy()
	current_target = null
	target_appearance_with_filters = null
	return ..()

// We aim at something nearby to turn into our sculpting target and not bop it
/obj/item/modeling_block/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	return ranged_interact_with_atom(interacting_with, user, modifiers)

// We aim at something to turn into our sculpting target
/obj/item/modeling_block/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if (!sculpting && ismovable(interacting_with))
		set_target(interacting_with,user)
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/obj/item/modeling_block/proc/is_viable_target(mob/living/user, atom/movable/target)
	//Only things on turfs
	if(!isturf(target.loc))
		user.balloon_alert(user, "no sculpting subject!")
		return FALSE
	//No big icon things
	var/list/icon_dimensions = get_icon_dimensions(target.icon)
	if(icon_dimensions["width"] > 2*world.icon_size || icon_dimensions["height"] > 2*world.icon_size)
		user.balloon_alert(user, "subject is too big!")
		return FALSE
	return TRUE

/obj/item/modeling_block/proc/set_target(atom/movable/target, mob/living/user)
	if(!is_viable_target(user, target))
		return
	if(istype(target,/obj/item/statue/custom))
		var/obj/item/statue/custom/original = target
		current_target = original.content_ma
	else
		current_target = target.appearance
	user.balloon_alert(user, "sculpting [target.name]")

/obj/item/modeling_block/attack_self(mob/user)
	if(current_target)
		create_statue(user)
	else
		balloon_alert(user, "no sculpting subject!")

/obj/item/modeling_block/proc/create_statue(mob/user)
	var/obj/item/statue/custom/new_statue = new(user.loc)
	new_statue.set_visuals(current_target)
	var/mutable_appearance/ma = current_target
	new_statue.name = "statuette of [ma.name]"
	new_statue.desc = "A carved statuette depicting [ma.name]."
	qdel(src)
	user.put_in_active_hand(new_statue)

