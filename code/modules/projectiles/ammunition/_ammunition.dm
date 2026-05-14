/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/weapons/guns/ammo.dmi'
	icon_state = "s-casing"
	worn_icon_state = "bullet"
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*5)
	drop_sound = 'maplestation_modules/sound/items/drop/ring.ogg'
	///What sound should play when this ammo is fired
	var/fire_sound = null
	///Which kind of guns it can be loaded into
	var/caliber = null
	///The bullet type to create when New() is called
	var/obj/projectile/projectile_type = null
	///the loaded projectile in this ammo casing
	var/obj/projectile/loaded_projectile = null
	///Pellets for spreadshot
	var/pellets = 1
	///Variance for inaccuracy fundamental to the casing
	var/variance = 0
	///Randomspread for automatics
	var/randomspread = 0
	///Delay for energy weapons
	var/delay = 0
	///Override this to make your gun have a faster fire rate, in tenths of a second. 4 is the default gun cooldown.
	var/click_cooldown_override = 0
	///the visual effect appearing when the ammo is fired.
	var/firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect
	///pacifism check for boolet, set to FALSE if bullet is non-lethal
	var/harmful = TRUE

/obj/item/ammo_casing/Initialize(mapload)
	. = ..()
	if(projectile_type)
		loaded_projectile = new projectile_type(src)
	pixel_x = base_pixel_x + rand(-10, 10)
	pixel_y = base_pixel_y + rand(-10, 10)
	setDir(pick(GLOB.alldirs))
	update_appearance()

/obj/item/ammo_casing/Destroy()
	var/turf/T = get_turf(src)
	if(T && !loaded_projectile && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_destroyed", 1, name)
	QDEL_NULL(loaded_projectile)
	return ..()

/obj/item/ammo_casing/examine_weapon_descriptor(mob/user)
	return projectile_examine_description()

/obj/item/ammo_casing/proc/projectile_examine_description(preface = p_They(), include_caliber = TRUE)
	var/obj/projectile/mag_ammo_projectile = projectile_type
	var/actual_damage = 0
	var/disabling_damage = mag_ammo_projectile::stamina + mag_ammo_projectile::pain + mag_ammo_projectile::paralyze + mag_ammo_projectile::stun
	if(IS_DISABLING_DAMAGE(mag_ammo_projectile::damage_type))
		disabling_damage += mag_ammo_projectile::damage
	else
		actual_damage += mag_ammo_projectile::damage

	var/damage_text = ""
	switch(actual_damage)
		if(1 to 5)
			damage_text = "extremely weak"
		if(5 to 10)
			damage_text = "weak"
		if(10 to 15)
			damage_text = "decent"
		if(15 to 25)
			damage_text = "strong"
		if(25 to 50)
			damage_text = "very strong"
		if(50 to INFINITY)
			damage_text = "extremely strong"

	var/disabling_text = ""
	switch(disabling_damage)
		if(1 to 10)
			disabling_text = "extremely weak"
		if(10 to 20)
			disabling_text = "weak"
		if(20 to 30)
			disabling_text = "decent"
		if(30 to 40)
			disabling_text = "capable"
		if(40 to 50)
			disabling_text = "very capable"
		if(50 to INFINITY)
			disabling_text = "extremely capable"

	var/return_text = ""
	if(disabling_text)
		if(damage_text)
			return_text = "[preface] fire\s [damage_text] [include_caliber ? "[caliber] " : ""]round\s, which are [disabling_text] at disabling targets"
		else
			return_text = "[preface] fire\s [disabling_text] disabling [include_caliber ? "[caliber] " : ""]round\s"
	else if(damage_text)
		return_text = "[preface] fire\s [damage_text] [include_caliber ? "[caliber] " : ""]round\s"
	else
		return_text = "[preface] fire\s [include_caliber ? "[caliber] " : ""]round\s"

	return return_text

/obj/item/ammo_casing/update_icon_state()
	icon_state = "[initial(icon_state)][loaded_projectile ? "-live" : null]"
	return ..()

/*
 * On accidental consumption, 'spend' the ammo, and add in some gunpowder
 */
/obj/item/ammo_casing/on_accidental_consumption(mob/living/carbon/victim, mob/living/carbon/user, obj/item/source_item,  discover_after = TRUE)
	if(loaded_projectile)
		loaded_projectile = null
		update_appearance()
		victim.reagents?.add_reagent(/datum/reagent/gunpowder, 3)
		source_item?.reagents?.add_reagent(/datum/reagent/gunpowder, source_item.reagents.total_volume*(2/3))

	return ..()

//proc to magically refill a casing with a new projectile
/obj/item/ammo_casing/proc/newshot() //For energy weapons, syringe gun, shotgun shells and wands (!).
	if(!loaded_projectile)
		loaded_projectile = new projectile_type(src, src)

/obj/item/ammo_casing/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/ammo_box))
		var/obj/item/ammo_box/box = I
		if(isturf(loc))
			var/boolets = 0
			for(var/obj/item/ammo_casing/bullet in loc)
				if (box.stored_ammo.len >= box.max_ammo)
					break
				if (bullet.loaded_projectile)
					if (box.give_round(bullet, 0))
						boolets++
				else
					continue
			if (boolets > 0)
				box.update_appearance()
				to_chat(user, span_notice("You collect [boolets] shell\s. [box] now contains [box.stored_ammo.len] shell\s."))
			else
				to_chat(user, span_warning("You fail to collect anything!"))
	else
		return ..()

/obj/item/ammo_casing/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	bounce_away(FALSE, NONE)
	return ..()

/obj/item/ammo_casing/proc/bounce_away(still_warm = FALSE, bounce_delay = 3)
	update_appearance()
	SpinAnimation(10, 1)
	var/turf/T = get_turf(src)
	if(still_warm && T?.bullet_sizzle)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), src, 'sound/items/welder.ogg', 20, 1), bounce_delay) //If the turf is made of water and the shell casing is still hot, make a sizzling sound when it's ejected.
	else if(T?.bullet_bounce_sound)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), src, T.bullet_bounce_sound, 20, 1), bounce_delay) //Soft / non-solid turfs that shouldn't make a sound when a shell casing is ejected over them.

/obj/item/ammo_casing/proc/is_spent(mapload = FALSE)
	if(!mapload)
		add_smell(
			duration = 4 MINUTES,
			smell = "gunpowder",
			intensity = SMELL_INTENSITY_FAINT,
			radius = 1,
			wash_type = CLEAN_TYPE_FINGERPRINTS,
		)

	name = "spent [name]"
	desc += " This one is spent."

/obj/item/ammo_casing/spent
	loaded_projectile = null

/obj/item/ammo_casing/spent/Initialize(mapload)
	. = ..()
	is_spent(mapload)
