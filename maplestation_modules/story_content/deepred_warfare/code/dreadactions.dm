// vvvvv LEVEL 1 AKA LOW ENERGY ACTIONS vvvvv

// vvvvv LEVEL 2 AKA HIGH ENERGY ACTIONS vvvvv

// vvvvv LEVEL 3 AKA RED LIGHTNING ENERGY ACTIONS vvvvv

// vvvvv ALWAYS AVAILABLE ACTIONS vvvvv
/datum/action/cooldown/mob_cooldown/high_energy
	name = "Activate High Energy Mode"
	desc = "Activate High Energy Mode. Your cloak will need to be off to use this."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "bci_plus"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"
	cooldown_time = 2 SECONDS
	melee_cooldown_time = 0 SECONDS
	click_to_activate = FALSE

/datum/action/cooldown/mob_cooldown/high_energy/Activate(atom/target)
	var/mob/living/basic/redtechdread/ownercast = owner

	if(ownercast.neck) // Cloak on.
		owner.balloon_alert(owner, "You cannot enter high energy mode while your cloak is on.")
		return FALSE

	if(ownercast.energy_level == 2) // In RL energy mode.
		owner.balloon_alert(owner, "You cannot enter low energy mode while in RL energy mode.")
		return FALSE

	if(ownercast.RLEnergy < 0) // Negative RL energy.
		owner.balloon_alert(owner, "You need to wait for your red lightning energy to recharge.")
		return FALSE

	if(ownercast.energy_level == 1) // In high energy mode.
		owner.balloon_alert(owner, "You slow and and enter low energy mode.")
		ownercast.energy_level = 0
		ownercast.update_base_stats()
		return TRUE

	owner.balloon_alert(owner, "You speed up and enter high energy mode.")
	ownercast.energy_level = 1
	ownercast.update_base_stats()
	return TRUE

/datum/action/cooldown/mob_cooldown/lightning_energy
	name = "Activate Red Lightning Energy Mode"
	desc = "Activate Red Lightning Energy Mode. Needs to be at high energy to use this."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "bci_radioactive"
	background_icon_state = "bg_tech"
	overlay_icon_state = "bg_tech_border"
	cooldown_time = 2 SECONDS
	melee_cooldown_time = 0 SECONDS
	click_to_activate = FALSE

/datum/action/cooldown/mob_cooldown/lightning_energy/Activate(atom/target)
	var/mob/living/basic/redtechdread/ownercast = owner

	if(ownercast.neck) // Cloak on.
		owner.balloon_alert(owner, "You cannot enter red lightning energy mode while your cloak is on.")
		return FALSE

	if(ownercast.energy_level == 0) // In low energy mode.
		owner.balloon_alert(owner, "You need to be in high energy mode to enter red lightning energy mode.")
		return FALSE

	if(ownercast.RLEnergy < 0) // Negative RL energy.
		owner.balloon_alert(owner, "You need to wait for your red lightning energy to recharge.")
		return FALSE

	if(ownercast.energy_level == 2) // In RL energy mode.
		if(ownercast.RLEnergy < 0) // Negative RL energy.
			owner.balloon_alert(owner, "You slow and and enter low energy mode due to lack of red lightning energy.")
			ownercast.energy_level = 0
			ownercast.update_base_stats()
			return TRUE

		owner.balloon_alert(owner, "You cool down and enter high energy mode.")
		ownercast.energy_level = 1
		ownercast.update_base_stats()
		return TRUE

	owner.balloon_alert(owner, "You heat up and enter red lightning energy mode!")
	ownercast.energy_level = 2
	ownercast.update_base_stats()
	return TRUE
