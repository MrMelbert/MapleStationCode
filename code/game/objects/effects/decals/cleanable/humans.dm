// NON-MODULE CHANGE : This whole file

/obj/effect/decal/cleanable/blood
	name = "pool of blood"
	desc = "It's weird and gooey. Perhaps it's the chef's cooking?"
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	beauty = -100
	clean_type = CLEAN_TYPE_BLOOD
	decal_reagent = /datum/reagent/blood
	bloodiness = BLOOD_AMOUNT_PER_DECAL
	color = COLOR_BLOOD
	flags_1 = UNPAINTABLE_1
	gender = NEUTER
	/// Can this blood dry out?
	var/can_dry = TRUE
	/// Is this blood dried out?
	var/dried = FALSE

	/// How much our blood glows, up to 255 (it's the alpha of the EM overlay). 0 = no glow
	var/emissive_alpha = 0

	/// The "base name" of the blood, IE the "pool of" in "pool of blood"
	var/base_name = "pool of"
	/// When dried, this is prefixed to the name
	var/dry_prefix = "dried"
	/// When dried, this becomes the desc of the blood
	var/dry_desc = "Looks like it's been here a while. Eew."
	/// If TRUE our bloodiness decreases over time as we dry out
	var/decay_bloodiness = TRUE
	/// How long it takes to dry out
	var/drying_time = 5 MINUTES
	/// The process to drying out, recorded in deciseconds
	VAR_FINAL/drying_progress = 0

/obj/effect/decal/cleanable/blood/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	if(mapload)
		add_blood_DNA(list("UNKNOWN DNA" = random_human_blood_type()))
	if(dried)
		dry()
	else if(can_dry)
		START_PROCESSING(SSblood_drying, src)
		// update_atom_colour() // this is already called by parent via add_atom_colour

/obj/effect/decal/cleanable/blood/Destroy()
	STOP_PROCESSING(SSblood_drying, src)
	return ..()

/obj/effect/decal/cleanable/blood/on_entered(datum/source, atom/movable/AM)
	if(dried)
		return
	return ..()

// When color changes we need to update the drying animation
/obj/effect/decal/cleanable/blood/update_atom_colour()
	. = ..()
	// get a default color based on DNA if it ends up unset somehow
	color ||= (GET_ATOM_BLOOD_DNA_LENGTH(src) ? get_blood_dna_color() : COLOR_BLOOD)
	// stop existing drying animations
	animate(src)
	// ok let's make the dry color now
	// we will manually calculate what the resulting color should be when it dries
	// we do this instead of using something like a color matrix because byond moment
	// (at any given moment, there may be like... 200 blood decals on your screen at once
	// byond is, apparently, pretty bad at handling that many color matrix operations,
	// especially in a filter or while animating)
	var/list/starting_color_rgb = ReadRGB(color) || list(255, 255, 255, alpha)
	// we want a fixed offset for a fixed drop in color intensity, plus a scaling offset based on our strongest color
	// the scaling offset helps keep dark colors from turning black, while also ensurse bright colors don't stay super bright
	var/max_color = max(starting_color_rgb[1], starting_color_rgb[2], starting_color_rgb[3])
	var/red_offset = 50 + (75 * (starting_color_rgb[1] / max_color))
	var/green_offset = 50 + (75 * (starting_color_rgb[2] / max_color))
	var/blue_offset = 50 + (75 * (starting_color_rgb[3] / max_color))
	// if the color is already decently dark, we should reduce the offsets even further
	// this is intended to prevent already dark blood (mixed blood in particular) from becoming full black
	var/strength = starting_color_rgb[1] + starting_color_rgb[2] + starting_color_rgb[3]
	if(strength <= 192)
		red_offset *= 0.5
		green_offset *= 0.5
		blue_offset *= 0.5
	// finally, get this show on the road
	var/dried_color = rgb(
		clamp(starting_color_rgb[1] - red_offset, 0, 255),
		clamp(starting_color_rgb[2] - green_offset, 0, 255),
		clamp(starting_color_rgb[3] - blue_offset, 0, 255),
		length(starting_color_rgb) >= 4 ? starting_color_rgb[4] : alpha, // maintain alpha! (if it has it)
	)
	// if it's dried (or about to dry) we can just set color directly
	if(dried || drying_progress >= drying_time)
		color = dried_color
		return
	// otherwise set the color to what it should be at the current drying progress, then animate down to the dried color if we can
	color = gradient(0, color, 1, dried_color, round(drying_progress / drying_time, 0.01))
	if(can_dry)
		animate(src, time = drying_time - drying_progress, color = dried_color)

/// Slows down the drying time by a given amount,
/// then updates the effect, meaning the animation will slow down
/obj/effect/decal/cleanable/blood/proc/slow_dry(by_amount)
	drying_progress -= by_amount
	update_atom_colour()

/// Returns a string of all the blood reagents in the blood
/obj/effect/decal/cleanable/blood/proc/get_blood_string()
	var/list/all_dna = GET_ATOM_BLOOD_DNA(src)
	var/list/all_blood_names = list()
	for(var/dna_sample in all_dna)
		var/datum/blood_type/blood = find_blood_type(all_dna[dna_sample])
		all_blood_names |= LOWER_TEXT(initial(blood.reagent_type.name))
	return english_list(all_blood_names, nothing_text = "blood")

/obj/effect/decal/cleanable/blood/process(seconds_per_tick)
	if(dried || !can_dry)
		return PROCESS_KILL

	if(decay_bloodiness)
		adjust_bloodiness(-0.4 * BLOOD_PER_UNIT_MODIFIER * seconds_per_tick)
	drying_progress += (seconds_per_tick * 1 SECONDS)
	// Finish it next tick when we're all done
	if(drying_progress >= drying_time + SSblood_drying.wait)
		dry()

/obj/effect/decal/cleanable/blood/update_name(updates)
	. = ..()
	name = initial(name)
	if(base_name)
		name = "[base_name] [get_blood_string()]"
	if(dried && dry_prefix)
		name = "[dry_prefix] [name]"

/obj/effect/decal/cleanable/blood/update_desc(updates)
	. = ..()
	desc = initial(desc)
	if(dried && dry_desc)
		desc = dry_desc

/obj/effect/decal/cleanable/blood/update_overlays()
	. = ..()
	if(icon_state && emissive_alpha && emissive_alpha < alpha && !dried)
		. += blood_emissive(icon, icon_state)

/obj/effect/decal/cleanable/blood/proc/blood_emissive(icon_to_use, icon_state_to_use)
	return emissive_appearance(icon_to_use, icon_state_to_use, src, layer, alpha - emissive_alpha)

///This is what actually "dries" the blood. Returns true if it's all out of blood to dry, and false otherwise
/obj/effect/decal/cleanable/blood/proc/dry()
	dried = TRUE
	reagents?.clear_reagents()
	update_appearance()
	update_atom_colour()
	STOP_PROCESSING(SSblood_drying, src)
	return TRUE

/obj/effect/decal/cleanable/blood/lazy_init_reagents()
	var/list/all_dna = GET_ATOM_BLOOD_DNA(src)
	var/list/reagents_to_add = list()
	for(var/dna_sample in all_dna)
		var/datum/blood_type/blood = find_blood_type(all_dna[dna_sample])
		reagents_to_add += blood.reagent_type

	var/num_reagents = length(reagents_to_add)
	for(var/reagent_type in reagents_to_add)
		reagents.add_reagent(reagent_type, round((bloodiness * 0.2 * BLOOD_PER_UNIT_MODIFIER) / num_reagents, CHEMICAL_VOLUME_ROUNDING))

/obj/effect/decal/cleanable/blood/replace_decal(obj/effect/decal/cleanable/blood/merger)
	if(merger.dried) // New blood will lie on dry blood
		return FALSE
	return ..()

/obj/effect/decal/cleanable/blood/handle_merge_decal(obj/effect/decal/cleanable/blood/merger)
	. = ..()
	merger.add_blood_DNA(GET_ATOM_BLOOD_DNA(src))
	merger.adjust_bloodiness(bloodiness)
	merger.slow_dry(1 SECONDS * bloodiness * BLOOD_PER_UNIT_MODIFIER)

/obj/effect/decal/cleanable/blood/old
	bloodiness = 0
	dried = TRUE
	icon_state = "floor1-old" // just for mappers. overrided in init

/obj/effect/decal/cleanable/blood/splatter
	icon_state = "gibbl1"
	random_icon_states = list("gibbl1", "gibbl2", "gibbl3", "gibbl4", "gibbl5")

/obj/effect/decal/cleanable/blood/splatter/over_window // special layer/plane set to appear on windows
	layer = ABOVE_WINDOW_LAYER
	plane = GAME_PLANE
	vis_flags = VIS_INHERIT_PLANE
	alpha = 180

/obj/effect/decal/cleanable/blood/splatter/over_window/NeverShouldHaveComeHere(turf/here_turf)
	return isgroundlessturf(here_turf)

/obj/effect/decal/cleanable/blood/tracks
	icon_state = "tracks"
	desc = "They look like tracks left by wheels."
	random_icon_states = null
	beauty = -50
	base_name = ""
	dry_desc = "Some old bloody tracks left by wheels. Machines are evil, perhaps."

/obj/effect/decal/cleanable/blood/trail_holder
	name = "trail of blood"
	desc = "Your instincts say you shouldn't be following this."
	beauty = -50
	icon_state = "trails_1"
	random_icon_states = null
	base_name = "trail of"
	bloodiness = BLOOD_AMOUNT_PER_DECAL * 0.1
	/// All the components of the trail
	var/list/obj/effect/decal/cleanable/blood/trail/trail_components

/obj/effect/decal/cleanable/blood/trail_holder/Initialize(mapload)
	. = ..()
	icon_state = ""
	if(mapload)
		add_dir_to_trail(dir)

/obj/effect/decal/cleanable/blood/trail_holder/Destroy()
	QDEL_LIST_ASSOC_VAL(trail_components)
	return ..()

/**
 * Returns the trail component corresponding to the given direction
 *
 * * for_dir: The direction to get the trail for
 * * check_reverse: If TRUE, will also check for the reverse direction
 * For example if you pass dir = EAST it will return the first EAST or WEST trail component
 * * check_diagonals: If TRUE, will also check for any diagonal directions
 * For example if you pass dir = EAST it will return the first EAST, NORTHEAST, or SOUTHEAST trail component
 * * check_reverse_diagonals: If TRUE, will also check for any reverse diagonal directions
 * For example if you pass dir = EAST it will return the first SOUTHEAST, EAST, NORTHEAST, WEST, SOUTHWEST, or NORTHWEST trail component
 */
/obj/effect/decal/cleanable/blood/trail_holder/proc/get_trail_component(for_dir, check_reverse = FALSE, check_diagonals = FALSE, check_reverse_diagonals = FALSE)
	. = LAZYACCESS(trail_components, "[for_dir]")
	if(.)
		return .
	if(check_reverse)
		. = LAZYACCESS(trail_components, "[REVERSE_DIR(for_dir)]")
		if(.)
			return .
	if(check_diagonals)
		for(var/comp_dir_txt in trail_components)
			var/comp_dir = text2num(comp_dir_txt)
			if(comp_dir < 0)
				continue
			if(comp_dir & for_dir)
				return LAZYACCESS(trail_components, comp_dir_txt)
			if(check_reverse_diagonals && (comp_dir & REVERSE_DIR(for_dir)))
				return LAZYACCESS(trail_components, comp_dir_txt)

	return null

/**
 * Add a new direction to this trail
 *
 * * new_dir: The direction to add
 * This can be a cardinal direction, a diagonal direction, or a negative number to denote a cardinal direction angled 45 degrees.
 *
 * Returns the new trail, a [/obj/effect/decal/cleanable/blood/trail]
 */
/obj/effect/decal/cleanable/blood/trail_holder/proc/add_dir_to_trail(new_dir = NORTH)
	. = get_trail_component(new_dir, check_reverse = TRUE)
	if(.)
		return .

	var/obj/effect/decal/cleanable/blood/trail/new_trail = new(src)
	if(new_dir > 0)
		// add some free sprite variation by flipping it around
		if((new_dir in GLOB.cardinals) && prob(50))
			new_trail.setDir(REVERSE_DIR(new_dir))
		// otherwise the dir is the same
		else
			new_trail.setDir(new_dir)
	// negative dirs denote "straight diagonal" dirs
	else
		var/real_dir = abs(new_dir)
		new_trail.setDir(real_dir & (EAST|WEST))
		switch(real_dir)
			if(NORTHEAST)
				new_trail.transform = new_trail.transform.Turn(-45)
			if(NORTHWEST)
				new_trail.transform = new_trail.transform.Turn(45)
			if(SOUTHEAST)
				new_trail.transform = new_trail.transform.Turn(-135)
			if(SOUTHWEST)
				new_trail.transform = new_trail.transform.Turn(135)

	LAZYSET(trail_components, "[new_dir]", new_trail)
	vis_contents += new_trail
	return new_trail

/obj/effect/decal/cleanable/blood/trail
	name = "blood trail"
	desc = "A trail of blood."
	beauty = -50
	decay_bloodiness = FALSE // bloodiness is used as a metric for for how big the sprite is, so don't decay passively
	bloodiness = BLOOD_AMOUNT_PER_DECAL * 0.1
	icon_state = "ltrails_1"
	random_icon_states = list("ltrails_1", "ltrails_2")
	base_name = ""
	vis_flags = VIS_INHERIT_LAYER|VIS_INHERIT_PLANE|VIS_INHERIT_ID
	appearance_flags = parent_type::appearance_flags | RESET_COLOR
	/// Beyond a threshold we change to a bloodier icon state
	var/very_bloody = FALSE

/obj/effect/decal/cleanable/blood/trail/adjust_bloodiness(by_amount)
	. = ..()
	if(very_bloody)
		return
	if(bloodiness >= 0.25 * BLOOD_AMOUNT_PER_DECAL)
		very_bloody = TRUE
		icon_state = pick("trails_1", "trails_2")

/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	icon = 'icons/effects/blood.dmi'
	icon_state = "gib1"
	layer = LOW_OBJ_LAYER
	plane = GAME_PLANE
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")
	mergeable_decal = FALSE

	base_name = ""
	dry_prefix = "rotting"
	dry_desc = "They look bloody and gruesome while some terrible smell fills the air."
	decal_reagent = /datum/reagent/consumable/liquidgibs
	reagent_amount = 5
	///Information about the diseases our streaking spawns
	var/list/streak_diseases

/obj/effect/decal/cleanable/blood/gibs/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_PIPE_EJECTING, PROC_REF(on_pipe_eject))

/obj/effect/decal/cleanable/blood/gibs/get_blood_string()
	return ""

/obj/effect/decal/cleanable/blood/gibs/Destroy()
	LAZYNULL(streak_diseases)
	return ..()

/obj/effect/decal/cleanable/blood/gibs/replace_decal(obj/effect/decal/cleanable/C)
	return FALSE //Never fail to place us

/obj/effect/decal/cleanable/blood/gibs/dry()
	. = ..()
	if(!.)
		return
	AddComponent(/datum/component/rot, 0, 5 MINUTES, 0.7)

/obj/effect/decal/cleanable/blood/gibs/ex_act(severity, target)
	return FALSE

/obj/effect/decal/cleanable/blood/gibs/on_entered(datum/source, atom/movable/L)
	if(isliving(L) && has_gravity(loc))
		playsound(loc, 'sound/effects/footstep/gib_step.ogg', HAS_TRAIT(L, TRAIT_LIGHT_STEP) ? 20 : 50, TRUE)
	return ..()

/obj/effect/decal/cleanable/blood/gibs/proc/on_pipe_eject(atom/source, direction)
	SIGNAL_HANDLER

	var/list/dirs
	if(direction)
		dirs = list(direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOB.alldirs.Copy()

	streak(dirs)

/obj/effect/decal/cleanable/blood/gibs/proc/streak(list/directions, mapload=FALSE)
	LAZYINITLIST(streak_diseases)
	SEND_SIGNAL(src, COMSIG_GIBS_STREAK, directions, streak_diseases)
	var/direction = pick(directions)
	var/delay = 2
	var/range = pick(0, 200; 1, 150; 2, 50; 3, 17; 50) //the 3% chance of 50 steps is intentional and played for laughs.
	if(!step_to(src, get_step(src, direction), 0))
		return
	if(mapload)
		for (var/i in 1 to range)
			var/turf/my_turf = get_turf(src)
			if(!isgroundlessturf(my_turf) || GET_TURF_BELOW(my_turf))
				new /obj/effect/decal/cleanable/blood/splatter(my_turf)
			if (!step_to(src, get_step(src, direction), 0))
				break
		return

	var/datum/move_loop/loop = SSmove_manager.move_to(src, get_step(src, direction), delay = delay, timeout = range * delay, priority = MOVEMENT_ABOVE_SPACE_PRIORITY)
	RegisterSignal(loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(spread_movement_effects))

/obj/effect/decal/cleanable/blood/gibs/proc/spread_movement_effects(datum/move_loop/has_target/source)
	SIGNAL_HANDLER
	if(NeverShouldHaveComeHere(loc))
		return
	new /obj/effect/decal/cleanable/blood/splatter(loc, streak_diseases)

/obj/effect/decal/cleanable/blood/gibs/up
	icon_state = "gibup1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/down
	icon_state = "gibdown1"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/body
	icon_state = "gibtorso"
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/torso
	icon_state = "gibtorso"
	random_icon_states = null

/obj/effect/decal/cleanable/blood/gibs/limb
	icon_state = "gibleg"
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/core
	icon_state = "gibmid1"
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")

/obj/effect/decal/cleanable/blood/gibs/old
	name = "old rotting gibs"
	desc = "Space Jesus, why didn't anyone clean this up? They smell terrible."
	icon_state = "gib1-old" // just for mappers. overrided in init
	bloodiness = 0
	dried = TRUE
	dry_prefix = ""
	dry_desc = ""

/obj/effect/decal/cleanable/blood/gibs/old/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	setDir(pick(GLOB.cardinals))
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_SLUDGE, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 10)

/obj/effect/decal/cleanable/blood/drip
	name = "drop of blood"
	desc = "A spattering."
	icon_state = "drip5" //using drip5 since the others tend to blend in with pipes & wires.
	random_icon_states = list("drip1","drip2","drip3","drip4","drip5")
	bloodiness = BLOOD_AMOUNT_PER_DECAL * 0.2 * BLOOD_PER_UNIT_MODIFIER
	base_name = "drop of"
	dry_desc = "A dried spattering."
	drying_time = 1 MINUTES

//BLOODY FOOTPRINTS
/obj/effect/decal/cleanable/blood/footprints
	name = "footprints"
	desc = "WHOSE FOOTPRINTS ARE THESE?"
	icon = 'icons/effects/footprints.dmi'
	icon_state = "blood1"
	random_icon_states = null
	bloodiness = 0 // set based on the bloodiness of the foot
	base_name = ""
	dry_desc = "HMM... SOMEONE WAS HERE!"
	appearance_flags = parent_type::appearance_flags | KEEP_TOGETHER
	var/entered_dirs = 0
	var/exited_dirs = 0

	/// List of shoe or other clothing that covers feet types that have made footprints here.
	var/list/shoe_types

	/// List of species that have made footprints here.
	var/list/species_types

/obj/effect/decal/cleanable/blood/footprints/get_save_vars()
	return ..() - NAMEOF(src, icon_state)

/obj/effect/decal/cleanable/blood/footprints/Initialize(mapload)
	. = ..()
	icon_state = "" //All of the footprint visuals come from overlays
	if(mapload)
		entered_dirs |= dir //Keep the same appearance as in the map editor

/obj/effect/decal/cleanable/blood/footprints/get_blood_string()
	return ""

//Rotate all of the footprint directions too
/obj/effect/decal/cleanable/blood/footprints/setDir(newdir)
	if(dir == newdir)
		return ..()

	var/ang_change = dir2angle(newdir) - dir2angle(dir)
	var/old_entered_dirs = entered_dirs
	var/old_exited_dirs = exited_dirs
	entered_dirs = NONE
	exited_dirs = NONE

	for(var/Ddir in GLOB.cardinals)
		if(old_entered_dirs & Ddir)
			entered_dirs |= turn_cardinal(Ddir, ang_change)
		if(old_exited_dirs & Ddir)
			exited_dirs |= turn_cardinal(Ddir, ang_change)

	update_appearance()
	return ..()

/obj/effect/decal/cleanable/blood/footprints/update_overlays()
	. = ..()
	var/static/list/bloody_footprints_cache = list()
	var/icon_state_to_use = "blood"
	if(LAZYACCESS(species_types, BODYPART_ID_DIGITIGRADE))
		icon_state_to_use += "claw"
	else if(LAZYACCESS(species_types, SPECIES_MONKEY))
		icon_state_to_use += "paw"
	else if(LAZYACCESS(species_types, "bot"))
		icon_state_to_use += "bot"

	for(var/Ddir in GLOB.cardinals)
		if(entered_dirs & Ddir)
			var/enter_state = "entered-[icon_state_to_use]-[Ddir]"
			var/image/bloodstep_overlay = bloody_footprints_cache[enter_state]
			if(!bloodstep_overlay)
				bloodstep_overlay = image(icon, "[icon_state_to_use]1", dir = Ddir)
				bloody_footprints_cache[enter_state] = bloodstep_overlay
			. += bloodstep_overlay

			if(emissive_alpha && emissive_alpha < alpha && !dried)
				var/enter_emissive_state = "[enter_state]_emissive-[emissive_alpha]"
				var/mutable_appearance/emissive_overlay = bloody_footprints_cache[enter_emissive_state]
				if(!emissive_overlay)
					emissive_overlay = blood_emissive(icon, "[icon_state_to_use]1")
					emissive_overlay.dir = Ddir
					bloody_footprints_cache[enter_emissive_state] = emissive_overlay
				. += emissive_overlay

		if(exited_dirs & Ddir)
			var/exit_state = "exited-[icon_state_to_use]-[Ddir]"
			var/image/bloodstep_overlay = bloody_footprints_cache[exit_state]
			if(!bloodstep_overlay)
				bloodstep_overlay = image(icon, "[icon_state_to_use]2", dir = Ddir)
				bloody_footprints_cache[exit_state] = bloodstep_overlay
			. += bloodstep_overlay

			if(emissive_alpha && emissive_alpha < alpha && !dried)
				var/exit_emissive_state = "[exit_state]_emissive-[emissive_alpha]"
				var/mutable_appearance/emissive_overlay = bloody_footprints_cache[exit_emissive_state]
				if(!emissive_overlay)
					emissive_overlay = blood_emissive(icon, "[icon_state_to_use]2")
					emissive_overlay.dir = Ddir
					bloody_footprints_cache[exit_emissive_state] = emissive_overlay
				. += emissive_overlay

/obj/effect/decal/cleanable/blood/footprints/examine(mob/user)
	. = ..()
	if(LAZYLEN(species_types) + LAZYLEN(shoe_types) > 0)
		. += "You recognise the footprints as belonging to:"
		for(var/obj/item/clothing/shoes/sole as anything in shoe_types)
			var/article = initial(sole.article) || (initial(sole.gender) == PLURAL ? "Some" : "A")
			. += "[icon2html(initial(sole.icon), user, initial(sole.icon_state))] [article] <B>[initial(sole.name)]</B>."
		for(var/species in species_types)
			switch(species)
				if("unknown")
					. += "&bull; Some <B>creature's feet</B>."
				if(SPECIES_MONKEY)
					. += "&bull; Some <B>monkey feet</B>."
				if(SPECIES_HUMAN)
					. += "&bull; Some <B>human feet</B>."
				else
					. += "&bull; Some <B>[species] feet</B>."

/obj/effect/decal/cleanable/blood/hitsplatter
	name = "blood splatter"
	pass_flags = PASSTABLE | PASSGRILLE
	icon_state = "hitsplatter1"
	random_icon_states = list("hitsplatter1", "hitsplatter2", "hitsplatter3")

	base_name = ""
	can_dry = FALSE // No point

	/// The turf we just came from, so we can back up when we hit a wall
	var/turf/prev_loc
	/// The cached info about the blood
	var/list/blood_dna_info
	/// Skip making the final blood splatter when we're done, like if we're not in a turf
	var/skip = FALSE
	/// How many tiles/items/people we can paint red
	var/splatter_strength = 3
	/// Insurance so that we don't keep moving once we hit a stoppoint
	var/hit_endpoint = FALSE
	/// How fast the splatter moves
	var/splatter_speed = 0.1 SECONDS
	/// Tracks what direction we're flying
	var/flight_dir = NONE

/obj/effect/decal/cleanable/blood/hitsplatter/Initialize(mapload, list/datum/disease/diseases, splatter_strength)
	. = ..()
	prev_loc = loc //Just so we are sure prev_loc exists
	if(splatter_strength)
		src.splatter_strength = splatter_strength

/obj/effect/decal/cleanable/blood/hitsplatter/proc/expire()
	if(isturf(loc) && !skip)
		playsound(src, 'sound/effects/wounds/splatter.ogg', 60, TRUE, -1)
		loc.add_blood_DNA(blood_dna_info)
	qdel(src)

/// Set the splatter up to fly through the air until it rounds out of steam or hits something
/obj/effect/decal/cleanable/blood/hitsplatter/proc/fly_towards(turf/target_turf, range)
	flight_dir = get_dir(src, target_turf)
	var/datum/move_loop/loop = SSmove_manager.move_towards(src, target_turf, splatter_speed, timeout = splatter_speed * range, priority = MOVEMENT_ABOVE_SPACE_PRIORITY, flags = MOVEMENT_LOOP_START_FAST)
	RegisterSignal(loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, PROC_REF(pre_move))
	RegisterSignal(loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(post_move))
	RegisterSignal(loop, COMSIG_QDELETING, PROC_REF(loop_done))

/obj/effect/decal/cleanable/blood/hitsplatter/proc/pre_move(datum/move_loop/source)
	SIGNAL_HANDLER
	prev_loc = loc

/obj/effect/decal/cleanable/blood/hitsplatter/proc/post_move(datum/move_loop/source)
	SIGNAL_HANDLER
	if(loc == prev_loc)
		return

	for(var/atom/movable/iter_atom in loc)
		if(hit_endpoint)
			return
		if(iter_atom == src || iter_atom.invisibility || iter_atom.alpha <= 0 || (isobj(iter_atom) && !iter_atom.density))
			continue
		if(splatter_strength <= 0)
			break
		iter_atom.add_blood_DNA(blood_dna_info)

	splatter_strength--
	// we used all our blood so go away
	if(splatter_strength <= 0)
		expire()
		return
	// make a trail
	var/obj/effect/decal/cleanable/blood/fly_trail = new(loc)
	fly_trail.dir = dir
	if(ISDIAGONALDIR(flight_dir))
		fly_trail.transform = fly_trail.transform.Turn((flight_dir == NORTHEAST || flight_dir == SOUTHWEST) ? 135 : 45)
	fly_trail.icon_state = pick("trails_1", "trails2")
	fly_trail.adjust_bloodiness(fly_trail.bloodiness * -0.66)
	fly_trail.add_blood_DNA(blood_dna_info)

/obj/effect/decal/cleanable/blood/hitsplatter/proc/loop_done(datum/source)
	SIGNAL_HANDLER
	if(!QDELETED(src))
		expire()

/obj/effect/decal/cleanable/blood/hitsplatter/Bump(atom/bumped_atom)
	if(!iswallturf(bumped_atom) && !istype(bumped_atom, /obj/structure/window))
		expire()
		return

	if(istype(bumped_atom, /obj/structure/window))
		var/obj/structure/window/bumped_window = bumped_atom
		if(!bumped_window.fulltile)
			hit_endpoint = TRUE
			expire()
			return

	hit_endpoint = TRUE
	if(isturf(prev_loc))
		abstract_move(bumped_atom)
		skip = TRUE
		//Adjust pixel offset to make splatters appear on the wall
		if(istype(bumped_atom, /obj/structure/window))
			land_on_window(bumped_atom)
		else
			var/obj/effect/decal/cleanable/blood/splatter/over_window/final_splatter = new(prev_loc)
			final_splatter.pixel_x = (dir == EAST ? 32 : (dir == WEST ? -32 : 0))
			final_splatter.pixel_y = (dir == NORTH ? 32 : (dir == SOUTH ? -32 : 0))
			final_splatter.add_blood_DNA(GET_ATOM_BLOOD_DNA(src))
			final_splatter.add_blood_DNA(blood_dna_info)
	else // This will only happen if prev_loc is not even a turf, which is highly unlikely.
		abstract_move(bumped_atom)
		expire()

/// A special case for hitsplatters hitting windows, since those can actually be moved around, store it in the window and slap it in the vis_contents
/obj/effect/decal/cleanable/blood/hitsplatter/proc/land_on_window(obj/structure/window/the_window)
	if(!the_window.fulltile)
		return
	var/obj/effect/decal/cleanable/blood/splatter/over_window/final_splatter = new
	final_splatter.add_blood_DNA(GET_ATOM_BLOOD_DNA(src))
	final_splatter.add_blood_DNA(blood_dna_info)
	final_splatter.forceMove(the_window)
	the_window.vis_contents += final_splatter
	the_window.bloodied = TRUE
	expire()

/// Subtype which has random DNA baked in OUTSIDE of mapload.
/// For testing, mapping, or badmins
/obj/effect/decal/cleanable/blood/pre_dna
	var/list/dna_types = list("UNKNOWN DNA A" = /datum/blood_type/crew/human/a_minus)

/obj/effect/decal/cleanable/blood/pre_dna/Initialize(mapload)
	. = ..()
	add_blood_DNA(dna_types)

/obj/effect/decal/cleanable/blood/pre_dna/lizard
	dna_types = list("UNKNOWN DNA A" = /datum/blood_type/crew/lizard)

/obj/effect/decal/cleanable/blood/pre_dna/lizhuman
	dna_types = list("UNKNOWN DNA A" = /datum/blood_type/crew/human/a_minus, "UNKNOWN DNA B" = /datum/blood_type/crew/lizard)

/obj/effect/decal/cleanable/blood/pre_dna/ethereal
	dna_types = list("UNKNOWN DNA A" = /datum/blood_type/crew/ethereal)
