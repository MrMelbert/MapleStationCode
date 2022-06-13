/// The amount of bonus matter units brass sheets give to the replica fab.
#define BRASS_BONUS_MATTER_AMOUNT 20

// Effect played when the replica fabricator is converting something.
/obj/effect/rep_fab_conversion
	name = "conversion"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'maplestation_modules/icons/effects/clockwork_effects.dmi'
	icon_state = "mending_mantra"
	layer = HIGH_OBJ_LAYER
	alpha = 0

/obj/effect/rep_fab_conversion/proc/completion_fade(init_alpha = 255)
	set waitfor = FALSE
	animate(src, transform = matrix() * 2, alpha = 0, time = 5, flags = ANIMATION_END_NOW)
	sleep(5)
	animate(src, transform = matrix(), alpha = init_alpha, time = 0, flags = ANIMATION_END_NOW)

// The Replica fabricator.
// It's a buffed RCD.
/obj/item/construction/rcd/clock
	name = "replica fabricator"
	desc = "A cryptic looking device that can be used by rat'varian cultists to construct and deconstruct at rapid pace."
	icon = 'maplestation_modules/icons/obj/clockwork_objects.dmi'
	icon_state = "replica_fabricator"
	lefthand_file = 'icons/mob/inhands/antag/clockwork_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/clockwork_righthand.dmi'
	inhand_icon_state = "replica_fabricator"
	max_matter = 200
	matter = 200
	delay_mod = 0.5
	actions_types = list()
	has_ammobar = FALSE

/obj/item/construction/rcd/clock/examine(mob/user)
	. = ..()
	if(IS_CULTIST(user) || isobserver(user))
		. += span_brass("While in combat mode, right clicking on a tile (or any structures on a tile) will convert contents of the tile to brass.")
		. += span_brasstalics("Can be refilled with brass sheets.")

/obj/item/construction/rcd/clock/loadwithsheets(obj/item/stack/added_sheet, mob/user)
	var/added_matter = added_sheet.matter_amount
	// Brass works in clock RCDs, very efficiently
	// TODO: Make this work with any item with brass mat datum
	if(istype(added_sheet, /obj/item/stack/sheet/brass))
		added_matter += BRASS_BONUS_MATTER_AMOUNT

	if(added_matter <= 0)
		to_chat(user, span_notice("You can't insert [added_sheet.name] into [src]!"))
		return FALSE

	// Calculate the max number of sheets that will fit in RCD
	var/max_sheets = round((max_matter - matter) / added_matter)
	if(max_sheets > 0)
		var/amount_to_use = min(added_sheet.amount, max_sheets)
		added_sheet.use(amount_to_use)
		matter += added_matter * amount_to_use
		playsound(get_turf(user), 'sound/machines/click.ogg', 50, TRUE)
		to_chat(user, span_notice("You insert [amount_to_use] [added_sheet.name] sheets into [src]."))
		return TRUE
	to_chat(user, span_warning("You can't insert any more [added_sheet.name] sheets into [src]!"))
	return FALSE

/obj/item/construction/rcd/clock/attack_self(mob/user)
	if(!IS_CULTIST(user))
		backfire(user)
		return TRUE

	return ..()

/obj/item/construction/rcd/clock/pre_attack(atom/A, mob/user, params)
	if(!IS_CULTIST(user))
		backfire(user)
		return TRUE

	return ..()

/obj/item/construction/rcd/clock/pre_attack_secondary(atom/target, mob/living/user, params)
	if(!IS_CULTIST(user))
		backfire(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(user.combat_mode)
		INVOKE_ASYNC(src, .proc/convert_tile, get_turf(target), user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	return ..()

/obj/item/construction/rcd/clock/handle_openspace_click(turf/target, mob/user, proximity_flag, click_parameters)
	if(!IS_CULTIST(user))
		backfire(user)
		return

	return ..()

/obj/item/construction/rcd/clock/rcd_create(atom/A, mob/user)
	if(!IS_CULTIST(user))
		backfire(user)
		return FALSE

	var/original_x = A.x
	var/original_y = A.y
	var/original_z = A.z

	// Get the turf we're affecting.
	var/turf/target_turf = isturf(A) ? A : get_turf(A)
	. = ..()
	if(!.)
		return

	// After the construction is done.
	// We need to check if the turf was scraped or built on (changed)
	// and re-find it if it did.
	if(QDELETED(target_turf))
		target_turf = locate(original_x, original_y, original_z)
		if(!target_turf) // No turf at all, quit
			return

	// Calls x_act() on all contents of the turf, turf included.
	target_turf.ratvar_act(TRUE, FALSE)

/// Convert all the contents of [target_turf] to ratvarian, after some do-afters for each stage.
/obj/item/construction/rcd/clock/proc/convert_tile(turf/target_turf, mob/living/user)
	var/obj/effect/rep_fab_conversion/conversion_effect = new /obj/effect/rep_fab_conversion(target_turf)
	animate(conversion_effect, alpha = 200, time = 2 SECONDS)

	to_chat(user, span_brass("You begin converting [target_turf], and anything above it, to brass..."))
	if(!do_after(user, 2 SECONDS, target_turf))
		qdel(conversion_effect)
		return

	if(QDELETED(src) || QDELETED(target_turf) || QDELETED(user))
		qdel(conversion_effect)
		return

	for(var/obj/thing in target_turf)
		if(QDELETED(src) || QDELETED(user))
			qdel(conversion_effect)
			return

		if(QDELETED(thing))
			continue

		// Effects can be skipped
		if(iseffect(thing))
			continue

		// Some underfloor things we probably don't want to care about
		if(istype(thing, /obj/structure/cable))
			continue
		if(istype(thing, /obj/machinery/atmospherics))
			continue
		if(istype(thing, /obj/machinery/duct))
			continue

		// Abstract items / items not seen can be skipped
		// Otherwise, all items are done instantly
		if(isitem(thing))
			var/obj/item/item_thing = thing
			if((item_thing.item_flags & ABSTRACT) || isnull(item_thing.icon_state))
				continue

		// Only bothering with feedback + a do_after for big things (structures, machines)
		// Otherwise it'd require a do_after for every item on a table, and so on...
		else
			if(!useResource(5, user))
				qdel(conversion_effect)
				return
			conversion_effect.SpinAnimation(7, 1)
			if(!do_after(user, 1 SECONDS, thing))
				qdel(conversion_effect)
				return

			if(QDELETED(src) || QDELETED(user))
				qdel(conversion_effect)
				return

			if(QDELETED(thing))
				continue

			conversion_effect.completion_fade(200)

		thing.ratvar_act()
		playsound(target_turf, 'sound/machines/click.ogg', 50, TRUE)

	if(QDELETED(src) || QDELETED(target_turf) || QDELETED(user))
		qdel(conversion_effect)
		return

	target_turf.visible_message(span_brass("[target_turf] glows a bright blue as it suddenly appears encased in brass!"), ignored_mobs = user)
	to_chat(user, span_brass("You use [src] to convert [target_turf] to brass."))
	target_turf.ratvar_act(FALSE)
	animate(conversion_effect, alpha = 0, time = 0.5 SECONDS)
	QDEL_IN(conversion_effect, 0.6 SECONDS)

/// Harm whoever tried to use it.
/obj/item/construction/rcd/clock/proc/backfire(mob/living/user)
	to_chat(user, span_danger("The [src] begins to whirr and shake as it rejects your hand!"))
	var/obj/item/bodypart/affecting = user.get_active_hand()

	if(affecting)
		user.apply_damage(12, def_zone = affecting.body_zone, forced = TRUE, wound_bonus = CANT_WOUND)

	user.Paralyze(1.5 SECONDS)
	new /obj/effect/temp_visual/clock/disable(get_turf(user))

#undef BRASS_BONUS_MATTER_AMOUNT
