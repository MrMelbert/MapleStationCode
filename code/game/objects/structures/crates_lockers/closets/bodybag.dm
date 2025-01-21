/obj/structure/closet/body_bag
	name = "body bag"
	desc = "A plastic bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "bodybag"
	density = FALSE
	mob_storage_capacity = 2
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	open_sound_volume = 15
	close_sound_volume = 15
	integrity_failure = 0
	material_drop = /obj/item/stack/sheet/cloth
	delivery_icon = null //unwrappable
	anchorable = FALSE
	cutting_tool = null // Bodybags are not deconstructed by cutting
	drag_slowdown = 0
	has_closed_overlay = FALSE
	can_install_electronics = FALSE
	paint_jobs = null
	can_weld_shut = FALSE
	// For subtypes that seal
	air_volume = TANK_STANDARD_VOLUME

	var/foldedbag_path = /obj/item/bodybag
	var/obj/item/bodybag/foldedbag_instance = null
	/// The tagged name of the bodybag, also used to check if the bodybag IS tagged.
	var/tag_name
	/// Whether you can health-analyzer through the walls of the bodybag
	var/can_scan_through = FALSE
	/// Paper pinned to this bag
	var/obj/item/paper/pinned

/obj/structure/closet/body_bag/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_RMB] = "Fold up"
		. = CONTEXTUAL_SCREENTIP_SET
	else if(held_item.tool_behaviour == TOOL_WIRECUTTER || held_item.get_sharpness())
		context[SCREENTIP_CONTEXT_LMB] = "Remove [pinned ? "Paper" : "Tag"]"
		. = CONTEXTUAL_SCREENTIP_SET
	else if(!pinned && istype(held_item, /obj/item/paper) && !opened)
		context[SCREENTIP_CONTEXT_LMB] = "Pin Paper"
		. = CONTEXTUAL_SCREENTIP_SET
	else if(can_scan_through && istype(held_item, /obj/item/healthanalyzer) && !opened)
		context[SCREENTIP_CONTEXT_LMB] = "Scan Contents"
		. = CONTEXTUAL_SCREENTIP_SET

/obj/structure/closet/body_bag/Destroy()
	// If we have a stored bag, and it's in nullspace (not in someone's hand), delete it.
	if (foldedbag_instance && !foldedbag_instance.loc)
		QDEL_NULL(foldedbag_instance)
	return ..()

///Handles renaming of the bodybag's examine tag.
/obj/structure/closet/body_bag/proc/handle_tag(new_name)
	tag_name = new_name
	name = tag_name ? "[initial(name)] - [tag_name]" : initial(name)
	update_appearance()

/obj/structure/closet/body_bag/update_overlays()
	. = ..()
	if(tag_name)
		. += "bodybag_label"
	if(pinned)
		var/image/paper_image = image(
			icon = 'maplestation_modules/icons/obj/bodybag.dmi',
			icon_state = "paper[(pinned.is_empty() || !pinned.show_written_words) ? "" : "_written"]",
		)
		paper_image.color = pinned.color
		. += paper_image

/obj/structure/closet/body_bag/examine(mob/user)
	. = ..()
	if(tag_name)
		. += span_info("The tag reads: [tag_name]")
	if(can_scan_through)
		. += span_notice("The walls of the bag are thin enough to scan through via a <b>health analyzer</b>.")
	if(pinned)
		if(get_dist(user, src) <= 2 && user.client)
			pinned.ui_interact(user)
		else
			. += span_smallnoticeital("There's a paper pinned to the bag, but you can't make out what it says.")

/obj/structure/closet/body_bag/after_close(mob/living/user)
	. = ..()
	set_density(FALSE)

/obj/structure/closet/body_bag/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!attempt_fold(user))
		return SECONDARY_ATTACK_CONTINUE_CHAIN
	perform_fold(user)
	qdel(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		/**
		  * Checks to see if we can fold. Return TRUE to actually perform the fold and delete.
			*
		  * Arguments:
		  * * the_folder - aka user
		  */
/obj/structure/closet/body_bag/proc/attempt_fold(mob/living/carbon/human/the_folder)
	. = FALSE
	if(!istype(the_folder))
		return
	if(opened)
		to_chat(the_folder, span_warning("You wrestle with [src], but it won't fold while unzipped."))
		return
	for(var/content_thing in contents)
		if(istype(content_thing, /mob) || isobj(content_thing))
			to_chat(the_folder, span_warning("There are too many things inside of [src] to fold it up!"))
			return
	// toto we made it!
	return TRUE

	/**
		* Performs the actual folding. Deleting is automatic, please do not include.
		*
		* Arguments:
		* * the_folder - aka user
		*/
/obj/structure/closet/body_bag/proc/perform_fold(mob/living/carbon/human/the_folder)
	visible_message(span_notice("[the_folder] folds up [src]."))
	the_folder.put_in_hands(undeploy_bodybag(the_folder.loc))

/// Makes the bag into an item, returns that item
/obj/structure/closet/body_bag/proc/undeploy_bodybag(atom/fold_loc)
	var/obj/item/bodybag/folding_bodybag = foldedbag_instance || new foldedbag_path()
	if(fold_loc)
		folding_bodybag.forceMove(fold_loc)
	pinned?.forceMove(fold_loc || drop_location())
	return folding_bodybag

/obj/structure/closet/body_bag/container_resist_act(mob/living/user, loc_required = TRUE)
	// ideally we support this natively but i guess that's for a later time
	if(!istype(loc, /obj/machinery/disposal))
		return ..()
	for(var/atom/movable/thing as anything in src)
		thing.forceMove(loc)
	undeploy_bodybag(loc)

/obj/structure/closet/body_bag/bluespace
	name = "bluespace body bag"
	desc = "A bluespace body bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "bluebodybag"
	foldedbag_path = /obj/item/bodybag/bluespace
	mob_storage_capacity = 15
	max_mob_size = MOB_SIZE_LARGE
	sealed = TRUE
	air_volume = TANK_STANDARD_VOLUME * 2

/obj/structure/closet/body_bag/bluespace/attempt_fold(mob/living/carbon/human/the_folder)
	. = FALSE
	//copypaste zone, we do not want the content check so we don't want inheritance
	if(!istype(the_folder))
		return
	if(opened)
		to_chat(the_folder, span_warning("You wrestle with [src], but it won't fold while unzipped."))
		return
	//end copypaste zone
	if(contents.len >= mob_storage_capacity / 2)
		to_chat(the_folder, span_warning("There are too many things inside of [src] to fold it up!"))
		return

	if(the_folder.in_contents_of(src))
		to_chat(the_folder, span_warning("You can't fold [src] while you're inside of it!"))
		return

	for(var/obj/item/bodybag/bluespace/B in src)
		to_chat(the_folder, span_warning("You can't recursively fold bluespace body bags!") )
		return
	return TRUE

/obj/structure/closet/body_bag/bluespace/perform_fold(mob/living/carbon/human/the_folder)
	visible_message(span_notice("[the_folder] folds up [src]."))
	var/obj/item/bodybag/folding_bodybag = undeploy_bodybag(the_folder.loc)
	var/max_weight_of_contents = initial(folding_bodybag.w_class)
	for(var/am in contents)
		var/atom/movable/content = am
		content.forceMove(folding_bodybag)
		if(isliving(content))
			to_chat(content, span_userdanger("You're suddenly forced into a tiny, compressed space!"))
		if(iscarbon(content))
			var/mob/living/carbon/mob = content
			if (mob.dna?.get_mutation(/datum/mutation/human/dwarfism))
				max_weight_of_contents = max(WEIGHT_CLASS_NORMAL, max_weight_of_contents)
				continue
		if(!isitem(content))
			max_weight_of_contents = max(WEIGHT_CLASS_BULKY, max_weight_of_contents)
			continue
		var/obj/item/A_is_item = content
		if(A_is_item.w_class < max_weight_of_contents)
			continue
		max_weight_of_contents = A_is_item.w_class
	folding_bodybag.update_weight_class(max_weight_of_contents)
	the_folder.put_in_hands(folding_bodybag)

/obj/structure/closet/body_bag/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	ADD_TRAIT(arrived, TRAIT_FLOORED, REF(src))

/obj/structure/closet/body_bag/Exited(atom/movable/gone, direction)
	. = ..()
	REMOVE_TRAIT(gone, TRAIT_FLOORED, REF(src))
	if(gone == pinned)
		pinned.flags_1 &= ~IS_ONTOP_1
		pinned = null
		update_appearance()

/obj/structure/closet/body_bag/item_interaction(mob/living/user, obj/item/tool, list/modifiers, is_right_clicking)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .

	if(IS_WRITING_UTENSIL(tool))
		if(!user.can_write(tool))
			return . | ITEM_INTERACT_BLOCKING
		var/t = tgui_input_text(user, "What would you like the label to be?", name, max_length = 53)
		if(user.get_active_held_item() != tool)
			return . | ITEM_INTERACT_BLOCKING
		if(!user.can_perform_action(src))
			return . | ITEM_INTERACT_BLOCKING
		balloon_alert(user, "tag set")
		handle_tag("[t || initial(name)]")
		return . | ITEM_INTERACT_SUCCESS

	if(tool.tool_behaviour == TOOL_WIRECUTTER || tool.get_sharpness())
		if(pinned)
			balloon_alert(user, "paper removed")
			pinned.forceMove(drop_location())
			return . | ITEM_INTERACT_SUCCESS
		else if(tag_name)
			balloon_alert(user, "tag removed")
			handle_tag()
			return . | ITEM_INTERACT_SUCCESS

	if(opened)
		if(!user.combat_mode && !(tool.item_flags & (ABSTRACT|HAND_ITEM)) && user.transferItemToLoc(tool, loc, silent = FALSE))
			return . | ITEM_INTERACT_SUCCESS
		return .

	if(can_scan_through && istype(tool, /obj/item/healthanalyzer))
		for(var/mob/living/frozen in src)
			return tool.interact_with_atom(frozen, user)

	if(!pinned && istype(tool, /obj/item/paper) && user.transferItemToLoc(tool, src, silent = FALSE))
		pinned = tool
		pinned.flags_1 |= IS_ONTOP_1
		pinned.forceMove(src)
		update_appearance()
		return . | ITEM_INTERACT_SUCCESS

	return .

/obj/structure/closet/body_bag/before_open(mob/living/user, force)
	if(pinned)
		if(force)
			pinned.forceMove(drop_location())
			return TRUE // force open
		balloon_alert(user, "paper removed")
		if(!user.put_in_inactive_hand(pinned) || pinned.loc == src)
			pinned.forceMove(drop_location())
		return FALSE // blocked the open action
	return TRUE

/obj/structure/closet/body_bag/deconstruct(disassembled)
	. = ..()
	pinned?.forceMove(drop_location())

/// Environmental bags. They protect against bad weather.

/obj/structure/closet/body_bag/environmental
	name = "environmental protection bag"
	desc = "An insulated, reinforced bag designed to protect against exoplanetary storms and other environmental factors."
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "envirobag"
	mob_storage_capacity = 1
	contents_pressure_protection = 0.8
	contents_thermal_insulation = 0.5
	foldedbag_path = /obj/item/bodybag/environmental
	sealed = TRUE
	air_volume = TANK_STANDARD_VOLUME
	/// The list of weathers we protect from.
	var/list/weather_protection = list(TRAIT_ASHSTORM_IMMUNE, TRAIT_RADSTORM_IMMUNE, TRAIT_SNOWSTORM_IMMUNE, TRAIT_VOIDSTORM_IMMUNE) // Does not protect against lava or the The Floor Is Lava spell.

/obj/structure/closet/body_bag/environmental/Initialize(mapload)
	. = ..()
	add_traits(weather_protection, INNATE_TRAIT)

/obj/structure/closet/body_bag/environmental/togglelock(mob/living/user, silent)
	. = ..()
	for(var/mob/living/target in contents)
		to_chat(target, span_warning("You hear a faint hiss, and a white mist fills your vision..."))

/obj/structure/closet/body_bag/environmental/nanotrasen
	name = "elite environmental protection bag"
	desc = "A heavily reinforced and insulated bag, capable of fully isolating its contents from external factors."
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "ntenvirobag"
	contents_pressure_protection = 1
	contents_thermal_insulation = 1
	foldedbag_path = /obj/item/bodybag/environmental/nanotrasen
	weather_protection = list(TRAIT_WEATHER_IMMUNE)

/// Securable enviro. bags

/obj/structure/closet/body_bag/environmental/prisoner
	name = "prisoner transport bag"
	desc = "Intended for transport of prisoners through hazardous environments, this environmental protection bag comes with straps to keep an occupant secure."
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "prisonerenvirobag"
	foldedbag_path = /obj/item/bodybag/environmental/prisoner
	breakout_time = 4 MINUTES // because it's probably about as hard to get out of this as it is to get out of a straightjacket.
	/// How long it takes to sinch the bag.
	var/sinch_time = 10 SECONDS
	/// Whether or not the bag is sinched. Starts unsinched.
	var/sinched = FALSE
	/// The sound that plays when the bag is done sinching.
	var/sinch_sound = 'sound/items/equip/toolbelt_equip.ogg'

/obj/structure/closet/body_bag/environmental/prisoner/attempt_fold(mob/living/carbon/human/the_folder)
	if(sinched)
		to_chat(the_folder, span_warning("You wrestle with [src], but it won't fold while its straps are fastened."))
	return ..()

/obj/structure/closet/body_bag/environmental/prisoner/before_open(mob/living/user, force)
	. = ..()
	if(!.)
		return FALSE

	if(sinched && !force)
		to_chat(user, span_danger("The buckles on [src] are sinched down, preventing it from opening."))
		return FALSE

	sinched = FALSE //in case it was forced open unsinch it
	return TRUE

/obj/structure/closet/body_bag/environmental/prisoner/update_icon()
	. = ..()
	if(sinched)
		icon_state = initial(icon_state) + "_sinched"
	else
		icon_state = initial(icon_state)

/obj/structure/closet/body_bag/environmental/prisoner/container_resist_act(mob/living/user, loc_required = TRUE)
	// copy-pasted with changes because flavor text as well as some other misc stuff
	if(opened || ismovable(loc) || !sinched)
		return ..()

	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(span_warning("Someone in [src] begins to wriggle!"), \
		span_notice("You start wriggling, attempting to loosen [src]'s buckles... (this will take about [DisplayTimeText(breakout_time)].)"), \
		span_hear("You hear straining cloth from [src]."))
	if(do_after(user,(breakout_time), target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src || opened || !sinched )
			return
		//we check after a while whether there is a point of resisting anymore and whether the user is capable of resisting
		user.visible_message(span_danger("[user] successfully broke out of [src]!"),
							span_notice("You successfully break out of [src]!"))
		if(istype(loc, /obj/machinery/disposal))
			return ..()
		bust_open()
	else
		if(user.loc == src) //so we don't get the message if we resisted multiple times and succeeded.
			to_chat(user, span_warning("You fail to break out of [src]!"))


/obj/structure/closet/body_bag/environmental/prisoner/bust_open()
	sinched = FALSE
	// We don't break the bag, because the buckles were backed out as opposed to fully broken.
	open()

/obj/structure/closet/body_bag/environmental/prisoner/attack_hand_secondary(mob/user, modifiers)
	if(!user.can_perform_action(src) || !isturf(loc))
		return
	togglelock(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/closet/body_bag/environmental/prisoner/togglelock(mob/living/user, silent)
	if(opened)
		to_chat(user, span_warning("You can't close the buckles while [src] is unzipped!"))
		return
	if(user in contents)
		to_chat(user, span_warning("You can't reach the buckles from here!"))
		return
	if(iscarbon(user))
		add_fingerprint(user)
	if(!sinched)
		for(var/mob/living/target in contents)
			to_chat(target, span_userdanger("You feel the lining of [src] tighten around you! Soon, you won't be able to escape!"))
		user.visible_message(span_notice("[user] begins sinching down the buckles on [src]."))
		if(!(do_after(user,(sinch_time),target = src)))
			return
	sinched = !sinched
	if(sinched)
		playsound(loc, sinch_sound, 15, TRUE, -2)
	user.visible_message(span_notice("[user] [sinched ? null : "un"]sinches [src]."),
							span_notice("You [sinched ? null : "un"]sinch [src]."),
							span_hear("You hear stretching followed by metal clicking from [src]."))
	user.log_message("[sinched ? "sinched":"unsinched"] secure environmental bag [src]", LOG_GAME)
	update_appearance()

/obj/structure/closet/body_bag/environmental/prisoner/syndicate
	name = "syndicate prisoner transport bag"
	desc = "An alteration of Nanotrasen's environmental protection bag which has been used in several high-profile kidnappings. Designed to keep a victim unconscious, alive, and secured during transport."
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "syndieenvirobag"
	contents_pressure_protection = 1
	contents_thermal_insulation = 1
	foldedbag_path = /obj/item/bodybag/environmental/prisoner/syndicate
	weather_protection = list(TRAIT_WEATHER_IMMUNE)
	breakout_time = 8 MINUTES
	sinch_time = 20 SECONDS

/obj/structure/closet/body_bag/environmental/prisoner/syndicate/process_internal_air(seconds_per_tick)
	if(opened)
		// lose a majority of all n2o when we start leaking gas, to stop this being a free (obnoxious) way to make n2o
		internal_air.assert_gases(/datum/gas/nitrous_oxide)
		internal_air.gases[/datum/gas/nitrous_oxide][MOLES] *= 0.15
		return ..()

	internal_air.assert_gases(/datum/gas/nitrogen, /datum/gas/nitrous_oxide)
	var/conversion_amount = min(internal_air.gases[/datum/gas/nitrogen][MOLES], 0.2 * internal_air.total_moles() * seconds_per_tick)
	if(conversion_amount > 0)
		// 20% of the nitrogen in the bag is converted to nitrous oxide every second while closed
		internal_air.gases[/datum/gas/nitrogen][MOLES] = max(0, internal_air.gases[/datum/gas/nitrogen][MOLES] - conversion_amount)
		internal_air.gases[/datum/gas/nitrous_oxide][MOLES] += conversion_amount
	return ..()

/obj/structure/closet/body_bag/environmental/hardlight
	name = "hardlight bodybag"
	desc = "A hardlight bag for storing bodies. Resistant to space."
	icon_state = "holobag_med"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	foldedbag_path = null
	weather_protection = list(TRAIT_VOIDSTORM_IMMUNE, TRAIT_SNOWSTORM_IMMUNE)
	can_scan_through = TRUE

/obj/structure/closet/body_bag/environmental/hardlight/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	if(damage_type in list(BRUTE, BURN))
		playsound(src, 'sound/weapons/egloves.ogg', 80, TRUE)

/obj/structure/closet/body_bag/environmental/prisoner/hardlight
	name = "hardlight prisoner bodybag"
	desc = "A hardlight bag for storing bodies. Resistant to space, can be sinched to prevent escape."
	icon_state = "holobag_sec"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	foldedbag_path = null
	weather_protection = list(TRAIT_VOIDSTORM_IMMUNE, TRAIT_SNOWSTORM_IMMUNE)
	can_scan_through = TRUE

/obj/structure/closet/body_bag/environmental/prisoner/hardlight/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	if(damage_type in list(BRUTE, BURN))
		playsound(src, 'sound/weapons/egloves.ogg', 80, TRUE)

// NON-MODULE CHANGE / addition
/obj/structure/closet/body_bag/environmental/stasis
	name = "stasis bodybag"
	desc = "A disposable bodybag designed to keep its contents in stasis, preventing decay and further injury. \
		The bag itself cannot maintain stasis for long, and will eventually fall apart."
	max_integrity = 300
	icon_state = "holobag_med"
	breakout_time = 5 SECONDS
	can_scan_through = TRUE
	material_drop = /obj/item/stack/sheet/plastic
	material_drop_amount = 2
	appearance_flags = parent_type::appearance_flags | KEEP_TOGETHER
	/// Cooldown for playing the freeze sound effect
	COOLDOWN_DECLARE(freeze_sound_cd)
	/// Base color filter applied to the bodybag, adjusted based on integrity
	var/static/list/base_color_filter = list(
		1, 0, 0,
		0, 1, 0,
		0, 0, 2,
		0, 0, 0,
	)
	/// Cooldown between filter updates to prevent weirdness
	COOLDOWN_DECLARE(last_filter_update)

/obj/structure/closet/body_bag/environmental/stasis/Initialize(mapload)
	. = ..()
	add_filter("stasis_color", 1, color_matrix_filter(base_color_filter))

/obj/structure/closet/body_bag/environmental/stasis/on_update_integrity(old_value, new_value)
	. = ..()
	if(!COOLDOWN_FINISHED(src, last_filter_update))
		return

	var/damage_percent = 1 - get_integrity_percentage()
	var/list/new_color_filter = base_color_filter.Copy()
	new_color_filter[1] -= (0.5 * damage_percent)
	new_color_filter[5] -= (0.5 * damage_percent)
	new_color_filter[9] -= (1.25 * damage_percent)

	if(last_filter_update == -1)
		modify_filter("stasis_color", color_matrix_filter(new_color_filter), TRUE)
	else
		transition_filter("stasis_color", color_matrix_filter(new_color_filter), 1 SECONDS)

	COOLDOWN_START(src, last_filter_update, 1 SECONDS)

/obj/structure/closet/body_bag/environmental/stasis/process_internal_air(seconds_per_tick)
	if(opened)
		var/datum/gas_mixture/current_exposed_air = loc.return_air()
		if(!current_exposed_air)
			return
		internal_air.temperature = max(current_exposed_air.temperature, internal_air.temperature)
		return ..()

	if(internal_air.temperature > BODY_PRESERVATION_TEMP)
		var/temperature_decrease_this_tick = min(5 CELCIUS * seconds_per_tick, internal_air.temperature - BODY_PRESERVATION_TEMP)
		internal_air.temperature -= temperature_decrease_this_tick

	for(var/mob/living/freezing in src)
		if(internal_air.temperature <= T20C && SPT_PROB(4 * (abs((internal_air.temperature + BODY_PRESERVATION_TEMP) / BODY_PRESERVATION_TEMP) - 1), seconds_per_tick))
			freezing.Unconscious(1 SECONDS * seconds_per_tick)

		if(internal_air.temperature <= T0C && freezing.on_fire)
			freezing.extinguish_mob()

		if(internal_air.temperature <= BODY_PRESERVATION_TEMP && !HAS_TRAIT(freezing, TRAIT_STASIS))
			apply_stasis(freezing)

		// Bout two minutes of time
		take_damage(max_integrity * 0.004 * seconds_per_tick, sound_effect = FALSE)

/obj/structure/closet/body_bag/environmental/stasis/examine_status(mob/user)
	switch(100 * get_integrity_percentage())
		if(50 to 75)
			return span_warning("It looks worn.")
		if(25 to 50)
			return span_warning("It appears moderately worn.")
		if(0 to 25)
			return span_boldwarning("It's falling apart!")

/obj/structure/closet/body_bag/environmental/stasis/Exited(atom/movable/gone, direction)
	. = ..()
	if(HAS_TRAIT(gone, TRAIT_STASIS))
		remove_stasis(gone)

/obj/structure/closet/body_bag/environmental/stasis/after_open(mob/living/user, force = FALSE)
	if(COOLDOWN_FINISHED(src, freeze_sound_cd) && (locate(/mob/living) in loc))
		playsound(src, 'sound/effects/spray.ogg', 25, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE, frequency = 0.4)
	COOLDOWN_START(src, freeze_sound_cd, 2 SECONDS)

/obj/structure/closet/body_bag/environmental/stasis/proc/apply_stasis(mob/living/target)
	target.apply_status_effect(/datum/status_effect/grouped/stasis, REF(src))
	if(!target.incapacitated(IGNORE_STASIS))
		to_chat(target, span_notice("You feel a cold, numbing sensation..."))
	RegisterSignal(target, COMSIG_LIVING_EARLY_UNARMED_ATTACK, PROC_REF(skip_to_attack_hand))

/obj/structure/closet/body_bag/environmental/stasis/after_close(mob/living/user)
	if(COOLDOWN_FINISHED(src, freeze_sound_cd) && (locate(/mob/living) in src))
		playsound(src, 'sound/effects/spray.ogg', 25, TRUE, MEDIUM_RANGE_SOUND_EXTRARANGE, frequency = 0.5)
	COOLDOWN_START(src, freeze_sound_cd, 2 SECONDS)

/obj/structure/closet/body_bag/environmental/stasis/proc/remove_stasis(mob/living/target)
	target.remove_status_effect(/datum/status_effect/grouped/stasis, REF(src))
	if(!target.incapacitated(IGNORE_STASIS))
		to_chat(target, span_notice("You can feel your fingers and toes again."))
	UnregisterSignal(target, COMSIG_LIVING_EARLY_UNARMED_ATTACK)

/obj/structure/closet/body_bag/environmental/stasis/undeploy_bodybag(atom/fold_loc)
	. = ..()
	var/obj/item/bodybag/folded = .
	folded.update_integrity(get_integrity())

/obj/structure/closet/body_bag/environmental/stasis/proc/skip_to_attack_hand(mob/living/source, atom/attack_target)
	SIGNAL_HANDLER
	if(attack_target == src)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/atom, container_resist_act), source)
		return COMPONENT_CANCEL_ATTACK_CHAIN
	return NONE

/obj/structure/closet/body_bag/environmental/stasis/container_resist_act(mob/living/user)
	if(opened)
		return
	if(ismovable(loc))
		user.changeNext_move(CLICK_CD_BREAKOUT)
		user.last_special = world.time + CLICK_CD_BREAKOUT
		var/atom/movable/resisting_loc = loc
		resisting_loc.relay_container_resist_act(user, src)
		return
	if(!HAS_TRAIT(user, TRAIT_STASIS))
		open(user)
		return

	user.changeNext_move(6 SECONDS)
	user.last_special = world.time + 6 SECONDS
	user.visible_message(
		span_warning("Something in [src] begins to wriggle!"),
		span_notice("You start wriggling, attempting to climb out of [src]... (This will take about [DisplayTimeText(breakout_time)].)"),
		span_hear("You hear straining cloth from [src]."),
	)
	if(do_after(user, breakout_time, src, timed_action_flags = IGNORE_TARGET_LOC_CHANGE, extra_checks = CALLBACK(src, PROC_REF(breakout_checks), user)))
		user.visible_message(
			span_danger("[user] climbs out of [src]!"),
			span_notice("You successfully climb out of [src]!"),
		)
		open(user, force = TRUE, special_effects = FALSE)

	else if(!QDELETED(user) && user.loc == src)
		user.show_message("You fail to break out of [src]!", MSG_VISUAL)

/obj/structure/closet/body_bag/environmental/stasis/proc/breakout_checks(mob/living/user)
	if(QDELETED(user) || user.stat != CONSCIOUS || user.loc != src || opened)
		return FALSE
	return TRUE

/obj/structure/closet/body_bag/environmental/stasis/deconstruct(disassembled = TRUE)
	if (!(obj_flags & NO_DECONSTRUCTION))
		new /obj/effect/decal/cleanable/shreds(loc, name)
		new /obj/item/stack/sheet/cloth(loc, 4)
		playsound(loc, 'sound/items/duct_tape_rip.ogg', 50, TRUE, frequency = 0.5)
		for(var/mob/living/left_behind in src)
			left_behind.Knockdown(3 SECONDS)

	return ..()

/obj/structure/closet/body_bag/environmental/stasis/get_remote_view_fullscreens(mob/user)
	if(user.stat == DEAD || !(user.sight & (SEEOBJS|SEEMOBS)))
		user.overlay_fullscreen("remote_view", /atom/movable/screen/fullscreen/impaired, 2)
