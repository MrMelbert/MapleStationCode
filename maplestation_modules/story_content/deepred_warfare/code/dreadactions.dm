// vvvvv ABILITIES THAT CAN BE USED IN ANY MODE vvvvv
/datum/action/cooldown/mob_cooldown/high_energy
	name = "Activate High Energy Mode"
	desc = "Activate High Energy Mode. Your cloak will need to be off to use this."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "bci_power"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"
	cooldown_time = 10 SECONDS
	melee_cooldown_time = 0 SECONDS
	click_to_activate = FALSE
	shared_cooldown = MOB_SHARED_COOLDOWN_1

/datum/action/cooldown/mob_cooldown/high_energy/Activate(atom/target)
	var/mob/living/basic/redtechdread/ownercast = owner

	if(ownercast.neck) // Cloak on.
		owner.balloon_alert(owner, "you cannot enter high energy mode while your cloak is on")
		return FALSE

	if(ownercast.energy_level == 2) // In RL energy mode.
		owner.balloon_alert(owner, "you cannot enter low energy mode while in RL energy mode")
		return FALSE

	if(ownercast.RLEnergy < 0) // Negative RL energy.
		owner.balloon_alert(owner, "you need to wait for your red lightning energy to recharge")
		return FALSE

	if(ownercast.energy_level == 1) // In high energy mode.
		owner.balloon_alert(owner, "you slow and and enter low energy mode")
		ownercast.energy_level = 0
		ownercast.update_base_stats()
		StartCooldown()
		playsound(ownercast, 'sound/machines/clockcult/steam_whoosh.ogg', 120)
		return TRUE

	owner.balloon_alert(owner, "you speed up and enter high energy mode")
	ownercast.energy_level = 1
	ownercast.update_base_stats()
	StartCooldown()
	playsound(ownercast, 'sound/mecha/hydraulic.ogg', 120)
	return TRUE

/datum/action/cooldown/mob_cooldown/lightning_energy
	name = "Activate Red Lightning Energy Mode"
	desc = "Activate Red Lightning Energy Mode. Needs to be at high energy to use this."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "bci_radioactive"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"
	cooldown_time = 10 SECONDS
	melee_cooldown_time = 0 SECONDS
	click_to_activate = FALSE
	shared_cooldown = MOB_SHARED_COOLDOWN_1

/datum/action/cooldown/mob_cooldown/lightning_energy/Activate(atom/target)
	var/mob/living/basic/redtechdread/ownercast = owner

	if(ownercast.neck) // Cloak on.
		owner.balloon_alert(owner, "you cannot enter red lightning energy mode while your cloak is on")
		return FALSE

	if(!ownercast.back_storage)
		owner.balloon_alert(owner, "you need to have a red lightning canister to enter red lightning energy mode")
		return FALSE

	if(ownercast.energy_level == 0) // In low energy mode.
		owner.balloon_alert(owner, "you need to be in high energy mode to enter red lightning energy mode")
		return FALSE

	if(ownercast.RLEnergy < 0) // Negative RL energy.
		if(ownercast.energy_level == 2) // But already in RL energy mode.
			owner.balloon_alert(owner, "you slow and and enter low energy mode due to lack of red lightning energy")
			ownercast.energy_level = 0
			ownercast.update_base_stats()
			StartCooldown()
			playsound(ownercast, 'sound/machines/clockcult/steam_whoosh.ogg', 120)
			return TRUE

		owner.balloon_alert(owner, "you need to wait for your red lightning energy to recharge")
		return FALSE

	if(ownercast.energy_level == 2) // In RL energy mode.
		owner.balloon_alert(owner, "you cool down and enter high energy mode")
		ownercast.energy_level = 1
		ownercast.update_base_stats()
		StartCooldown()
		playsound(ownercast, 'sound/mecha/hydraulic.ogg', 120)
		return TRUE

	owner.balloon_alert(owner, "you heat up and enter red lightning energy mode!")
	ownercast.energy_level = 2
	ownercast.update_base_stats()
	StartCooldown()
	playsound(ownercast, 'sound/mecha/skyfall_power_up.ogg', 120)
	return TRUE

/datum/action/access_printer
	name = "Access Redtech Printer"
	desc = "Access the Redtech Printer to print out items."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "bci_repair"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"

/datum/action/access_printer/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return

	var/mob/living/basic/redtechdread/ownercast = owner

	if(!ownercast.back_storage)
		owner.balloon_alert(owner, "you need to have a red lightning canister to print items")
		return FALSE

	var/item_to_spawn = input("Item to fabricate (+ number to fabricate)?", "Item:", null) as text|null

	if(!item_to_spawn)
		return FALSE

	if(!ownercast.belt_storage)
		return FALSE

	var/list/preparsed = splittext(item_to_spawn,":")
	var/path = preparsed[1]
	var/amount = 1
	if(preparsed.len > 1)
		amount = clamp(text2num(preparsed[2]),1,ADMIN_SPAWN_CAP)

	var/chosen = pick_closest_path(path)
	if(!chosen)
		return

	var/turf/T = get_turf(usr)

	if(ispath(chosen, /turf))
		T.ChangeTurf(chosen)
	else
		if(ispath(chosen, /obj))
			var/storage = ownercast.belt_storage
			for(var/i in 1 to amount)
				new chosen(storage)
		else
			for(var/i in 1 to amount)
				new chosen(T)

/datum/action/cooldown/mob_cooldown/dreadscan
	name = "Ranged Scan"
	desc = "Scan a target from a distance."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "bci_scan"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"
	cooldown_time = 10 SECONDS
	melee_cooldown_time = 0 SECONDS
	click_to_activate = TRUE
	shared_cooldown = NONE

/datum/action/cooldown/mob_cooldown/dreadscan/Activate(atom/target_atom)
	var/mob/living/basic/redtechdread/ownercast = owner
	playsound(ownercast, 'sound/mecha/skyfall_power_up.ogg', 120)

	var/mutable_appearance/scan_effect = mutable_appearance('icons/mob/nonhuman-player/netguardian.dmi', "scan")
	ownercast.add_overlay(scan_effect)

	StartCooldown()
	if(!do_after(ownercast, 5 SECONDS))
		ownercast.balloon_alert(ownercast, "cancelled")
		StartCooldown(cooldown_time * 0.2)
		ownercast.cut_overlay(scan_effect)
		playsound(ownercast, 'sound/machines/scanbuzz.ogg', 120)
		return TRUE

	if(istype(target_atom, /mob/living))
		healthscan(ownercast, target_atom, advanced = TRUE)
	ownercast.cut_overlay(scan_effect)
	playsound(ownercast, 'sound/machines/ping.ogg', 120)
	return TRUE

// vvvvv ABILITIES THAT CAN ONLY BE USED IN RL MODE ONLY vvvvv
/datum/action/cooldown/mob_cooldown/charge/basic_charge/dread
	name = "Red Lightning Rushdown"
	desc = "Charge at your target with the power of red lightning."
	cooldown_time = 30 SECONDS
	charge_delay = 2.5 SECONDS
	charge_distance = 4
	melee_cooldown_time = 0
	shake_duration = 2 SECONDS
	shake_pixel_shift = 1
	recoil_duration = 0.5 SECONDS
	knockdown_duration = 1 SECONDS
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "bci_skull"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"
	shared_cooldown = NONE
