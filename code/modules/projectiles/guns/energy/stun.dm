/obj/item/gun/energy/taser
	name = "taser gun"
	desc = "A low-capacity, energy-based stun gun used by security teams to subdue targets at range."
	icon_state = "taser"
	inhand_icon_state = null //so the human update icon uses the icon_state instead.
	ammo_type = list(/obj/item/ammo_casing/energy/electrode)
	ammo_x_offset = 3

/obj/item/gun/energy/e_gun/advtaser
	name = "hybrid taser"
	desc = "A dual-mode taser designed to fire both short-range high-power electrodes and long-range disabler beams."
	icon_state = "advtaser"
	ammo_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/disabler)
	ammo_x_offset = 2

/obj/item/gun/energy/e_gun/advtaser/cyborg
	name = "cyborg taser"
	desc = "An integrated hybrid taser that draws directly from a cyborg's power cell. The weapon contains a limiter to prevent the cyborg's power cell from overheating."
	can_charge = FALSE
	use_cyborg_cell = TRUE

/obj/item/gun/energy/e_gun/advtaser/cyborg/add_seclight_point()
	return

/obj/item/gun/energy/e_gun/advtaser/cyborg/emp_act()
	return

/obj/item/gun/energy/disabler
	name = "disabler"
	desc = "A self-defense weapon that exhausts organic targets, weakening them until they collapse."
	icon_state = "disabler"
	inhand_icon_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/disabler)
	ammo_x_offset = 2

/obj/item/gun/energy/disabler/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 15, \
		overlay_y = 10)

/obj/item/gun/energy/disabler/phaser
	name = "energy phaser"
	desc = "A standard issue energy phaser, designed for field use by security personnel. \
		It has two settings: disable, which fires incapacitating nociception beams, \
		and kill, which fires lower wavelength laser beams largely incapable of causing serious burns."
	// lore: nociception beams (colloquially called "disabler beams")
	// - temporarily overstimulate your nociceptors which causes extreme pain -> exhaustion -> incapacitation without causing skin damage.
	// lore: lower wavelength = higher frequency = more energy used = less energy put in the beam = less damage...
	// - ok this one's a bit of a stretch. it'd make more sense if damage went up as frequency went up
	// - logically, we should swap laser red with phaser green so lower wavelength = less damage... but that's a lot of effort
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/phaser, /obj/item/ammo_casing/energy/laser/phaser)
	modifystate = TRUE
	icon_state = "phaser"
	base_icon_state = "phaser"
	icon = 'maplestation_modules/icons/obj/weapons/guns/phaser.dmi'
	lefthand_file = 'maplestation_modules/icons/mob/inhands/weapons/phaser_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/weapons/phaser_righthand.dmi'

/obj/item/gun/energy/disabler/smg
	name = "disabler smg"
	desc = "An automatic disabler variant, as opposed to the conventional model, boasts a higher ammunition capacity at the cost of slightly reduced beam effectiveness."
	icon_state = "disabler_smg"
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/smg)
	shaded_charge = 1

/obj/item/gun/energy/disabler/smg/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.15 SECONDS, allow_akimbo = FALSE)

/obj/item/gun/energy/disabler/add_seclight_point()
	AddComponent(\
		/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 15, \
		overlay_y = 13, \
	)

/obj/item/gun/energy/disabler/cyborg
	name = "cyborg disabler"
	desc = "An integrated disabler that draws from a cyborg's power cell. This weapon contains a limiter to prevent the cyborg's power cell from overheating."
	can_charge = FALSE
	use_cyborg_cell = TRUE

/obj/item/gun/energy/disabler/cyborg/emp_act()
	return
