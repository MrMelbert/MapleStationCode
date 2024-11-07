/obj/item/gun/coilgun
	name = "abstract coilgun"
	desc = "You should not be seeing this."
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/coilguns.dmi'
	icon_state = "debug"
	w_class = WEIGHT_CLASS_NORMAL
	drop_sound = 'maplestation_modules/sound/items/drop/gun.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/gun.ogg'
	equip_sound = 'maplestation_modules/sound/items/drop/gun.ogg'

	var/list/ammo_type = list(/obj/item/ammo_casing/coil, /obj/item/ammo_casing/coil/highvelo) // Different ammo selections (add meltdown later).
	var/select = 1 // Current ammo selection.

	var/max_capacity = 10 // How many shots can be stored.
	var/shots_stored = 10 // Current shots stored.

	var/max_matter = 200 // How much matter it can hold.
	var/matter = 200 // Current matter.
	var/matter_usage = 5 // How much matter it uses to make a shot.
	var/fabricator_speed = 40 // How many ticks (10 deciseconds = 1 second) it takes to make a shot and put it into the stored shots.
	var/fabricator_progress = 0 // How far along the fabricator is.

	var/obj/item/stock_parts/cell/internalcell // Current cell of the gun.
	var/obj/item/stock_parts/cell/defaultcell = /obj/item/stock_parts/cell/redtech // Remind me to make a None version of this.

	var/maximum_heat = 200 // How hot the gun can get.
	var/dangerous_heat = 100 // When the gun starts to get dangerous.
	var/current_heat = 0 // Current heat.
	var/heat_dissipation = 5 // How much heat is dissipated per process.

	var/recoil_multiplier = 0.01 // How much recoil is multiplied by heat (IE: mult of 0.01 x 100 heat = 1 recoil added to gun).
	var/heat_damage_multiplier = 0.5 // How much self damage is multiplied by heat (IE: mult of 0.5 x (200 heat - 100 dangerous heat) = 50 self damage) (always 0 self damage at exactly dangerous heat or below).

	var/load_sound = 'sound/weapons/gun/general/magazine_insert_full.ogg' // Inserting new cell sound.
	var/load_sound_volume = 40 // Volume of the sound.
	var/eject_sound = 'sound/weapons/gun/general/magazine_remove_full.ogg' // Ejecting cell sound.
	var/eject_sound_volume = 40 // Volume of the sound.
	var/regen_sound = 'sound/weapons/gun/general/magazine_insert_empty.ogg' // Regenerating sound.
	var/regen_sound_volume = 40 // Volume of the sound.

/obj/item/gun/coilgun/Initialize(mapload)
	. = ..()
	if(defaultcell)
		internalcell = new defaultcell(src)
	var/obj/item/ammo_casing/coil/shot = ammo_type[1]
	fire_sound = shot.fire_sound
	fire_delay = shot.delay
	START_PROCESSING(SSobj, src)

/obj/item/gun/coilgun/Destroy()
	if (internalcell)
		QDEL_NULL(internalcell)
	for (var/atom/item in ammo_type)
		qdel(item)
	ammo_type = null
	STOP_PROCESSING(SSobj, src)

	return ..()

/obj/item/gun/coilgun/process(seconds_per_tick)
	if(matter >= matter_usage && shots_stored < max_capacity) // Processing bullet regen.
		fabricator_progress += seconds_per_tick
		if(fabricator_progress >= fabricator_speed)
			fabricator_progress = 0
			matter -= matter_usage
			shots_stored++
			playsound(src, regen_sound, regen_sound_volume)
	if(current_heat > 0) // Processing heat cooling.
		current_heat -= heat_dissipation * seconds_per_tick
		if(current_heat < 0)
			current_heat = 0

/obj/item/gun/coilgun/can_shoot()
	var/obj/item/ammo_casing/coil/shot = ammo_type[select]
	return !QDELETED(internalcell) ? ((internalcell.charge >= shot.ammo_energy_usage) && shots_stored >= 1) : FALSE

/obj/item/gun/coilgun/attackby(obj/item/A, mob/user, params)
	. = ..()
	if(.)
		return
	if(istype(A, /obj/item/stock_parts/cell))
		if (!internalcell)
			var/obj/item/stock_parts/cell/input = A
			insert_cell(user, input)
		else
			balloon_alert(user, "Cell already loaded!")
		return
	insert_matter(A, user)

/obj/item/gun/coilgun/attack_hand(mob/user, list/modifiers)
	if(loc == user && user.is_holding(src) && internalcell)
		eject_cell(user)
		return
	return ..()

/obj/item/gun/coilgun/attack_self(mob/living/user as mob)
	if(ammo_type.len > 1)
		select_fire(user)
	return ..()


/obj/item/gun/coilgun/recharge_newshot()
	if (!ammo_type || !internalcell)
		return
	if(!chambered)
		var/obj/item/ammo_casing/coil/shot = ammo_type[select]
		if(internalcell.charge >= shot.ammo_energy_usage)
			chambered = new shot(src)
			if(!chambered.loaded_projectile)
				chambered.newshot()

/obj/item/gun/coilgun/handle_chamber()
	if(chambered && !chambered.loaded_projectile)
		var/obj/item/ammo_casing/coil/shot = chambered
		internalcell.use(shot.ammo_energy_usage)
		shots_stored--
	chambered = null
	recharge_newshot()

/obj/item/gun/coilgun/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(!chambered && can_shoot())
		process_chamber()
	handle_heat(user)
	return ..()

/obj/item/gun/coilgun/process_burst(mob/living/user, atom/target, message = TRUE, params = null, zone_override="", randomized_gun_spread = 0, randomized_bonus_spread = 0, rand_spr = 0, iteration = 0)
	if(!chambered && can_shoot())
		process_chamber()
	handle_heat(user)
	return ..()


/obj/item/gun/coilgun/proc/handle_heat(mob/living/user)
	var/obj/item/ammo_casing/coil/shot = ammo_type[select]
	current_heat += shot.ammo_heat_generation
	if(current_heat > maximum_heat)
		current_heat = maximum_heat
	if(current_heat > dangerous_heat)
		var/damage = heat_damage_multiplier * (current_heat - dangerous_heat)
		user.adjustFireLoss(damage)
		balloon_alert(user, "Gun overheating!")
	update_heatrecoil()

/obj/item/gun/coilgun/proc/update_heatrecoil()
	recoil = recoil_multiplier * current_heat

/obj/item/gun/coilgun/proc/select_fire(mob/living/user)
	select++
	if (select > ammo_type.len)
		select = 1
	var/obj/item/ammo_casing/coil/shot = ammo_type[select]
	fire_sound = shot.fire_sound
	fire_delay = shot.delay
	if (shot.select_name && user)
		balloon_alert(user, "Set to [shot.select_name]!")
	chambered = null
	recharge_newshot(TRUE)
	update_appearance()

/obj/item/gun/coilgun/proc/insert_cell(mob/user, obj/item/stock_parts/cell/input)
	if(user.transferItemToLoc(input, src))
		internalcell = input
		balloon_alert(user, "Cell reloaded!")
		playsound(src, load_sound, load_sound_volume)
	else
		to_chat(user, span_warning("You cannot seem to get [input] out of your hands!"))

/obj/item/gun/coilgun/proc/eject_cell(mob/user)
	playsound(src, eject_sound, eject_sound_volume)
	internalcell.forceMove(drop_location())
	var/obj/item/stock_parts/cell/old_cell = internalcell
	internalcell = null
	user.put_in_hands(old_cell)
	old_cell.update_appearance()
	balloon_alert(user, "Cell unloaded!")

/obj/item/gun/coilgun/proc/insert_matter(obj/item, mob/user)
	if(istype(item, /obj/item/rcd_ammo))
		var/obj/item/rcd_ammo/ammo = item
		var/load = min(ammo.ammoamt, max_matter - matter)
		if(load <= 0)
			balloon_alert(user, "Matter storage full!")
			return FALSE
		ammo.ammoamt -= load
		if(ammo.ammoamt <= 0)
			qdel(ammo)
		matter += load
		playsound(loc, 'sound/machines/click.ogg', 50, TRUE)
	else if(isstack(item))
		loadwithsheets(item, user)

/obj/item/gun/coilgun/proc/loadwithsheets(obj/item/stack/the_stack, mob/user)
	if(the_stack.matter_amount <= 0)
		balloon_alert(user, "Invalid sheets!")
		return FALSE
	var/maxsheets = round((max_matter-matter) / the_stack.matter_amount)
	if(maxsheets > 0)
		var/amount_to_use = min(the_stack.amount, maxsheets)
		the_stack.use(amount_to_use)
		matter += the_stack.matter_amount * amount_to_use
		playsound(loc, 'sound/machines/click.ogg', 50, TRUE)
	balloon_alert(user, "Matter storage full!")
